defmodule Walker do
  @moduledoc """
  Walker is a filesystem walker that will provide an interface for discovering
  directories and files matching within a specific path system.

  Shamelessly borrowed from https://github.com/pragdave/dir_walker/
  """

  use GenServer

  require Logger

  @doc """
  Start the Walker with a given path to walk from.

  {:ok, pid} = Walker.start_link("/some/path/here")
  """
  @spec start_link(String.t(), map()) :: {:ok, PID.t()}
  def start_link(path_list, matching) when is_list(path_list) do
    GenServer.start_link(
      __MODULE__,
      {path_list,
       %{
         matching: fn path -> String.match?(path, matching) end
       }}
    )
  end

  def start_link(path, matching) when is_binary(path), do: start_link([path], matching)

  @doc """
  Retrieve the next N files, defaulting to a single file.
  """
  @spec next(PID.t(), Integer.t()) :: list(String.t()) | nil
  def next(iterator, n \\ 1) do
    GenServer.call(iterator, {:get_next, n})
  end

  @doc """
  Stop the walking and terminate the Walker.
  """
  @spec stop(PID.t()) :: :ok
  def stop(server) do
    GenServer.call(server, :stop)
  end

  @spec init(list(String.t())) :: {:ok, list(String.t())}
  def init(path_list) do
    {:ok, path_list}
  end

  def handle_call({:get_next, _n}, _from, state = {[], _}), do: {:reply, nil, state}

  def handle_call({:get_next, n}, _from, {path_list, matching}) do
    {result, new_path_list} = first_n(path_list, n, matching, _result = [])

    return_result =
      case {result, new_path_list} do
        {[], []} -> nil
        _ -> result
      end

    {:reply, return_result, {new_path_list, matching}}
  end

  def handle_call(:stop, from, state) do
    GenServer.reply(from, :ok)
    {:stop, :normal, state}
  end

  ##
  # Internal implementation and helpers.
  ##

  defp first_n([[] | rest], n, matching, result), do: first_n(rest, n, matching, result)

  defp first_n([[first] | rest], n, matching, result),
    do: first_n([first | rest], n, matching, result)

  defp first_n([[first | nested] | rest], n, matching, result),
    do: first_n([first | [nested | rest]], n, matching, result)

  defp first_n(path_list, 0, _, result), do: {result, path_list}
  defp first_n([], _, _, result), do: {result, []}

  defp first_n([path | rest], n, matching, result) do
    time_opts = [time: :posix]

    lstat = :file.read_link_info(path, time_opts)

    stat =
      case lstat do
        {:ok, fileinfo} ->
          File.Stat.from_record(fileinfo)

        {:error, reason} ->
          raise File.Error, reason: reason, action: "read file stats", path: path
      end

    case stat.type do
      :directory ->
        first_n(
          [files_in(path) | rest],
          n,
          matching,
          result
        )

      :regular ->
        handle_regular_file(path, rest, n, matching, result)

      :symlink ->
        handle_symlink(path, time_opts, rest, n, matching, result)

      _ ->
        first_n(rest, n, matching, result)
    end
  end

  defp files_in(path) do
    path
    |> :file.list_dir()
    |> ignore_error(path)
    |> Enum.map(fn rel -> Path.join(path, rel) end)
  end

  defp ignore_error({:error, type}, path) do
    Logger.info("Ignore folder #{path} (#{type})")
    []
  end

  defp ignore_error({:ok, list}, _), do: list

  defp handle_symlink(path, time_opts, rest, n, matching, result) do
    rstat = File.stat(path, time_opts)

    case rstat do
      {:ok, rstat} ->
        handle_existing_symlink(path, rstat, rest, n, matching, result)

      {:error, :enoent} ->
        Logger.info("Dangling symlink found: #{path}")
        handle_regular_file(path, rest, n, matching, result)

      {:error, reason} ->
        Logger.info("Stat failed on #{path} with #{reason}")
        {result, []}
    end
  end

  defp handle_existing_symlink(path, stat, rest, n, matching, result) do
    case stat.type do
      :directory ->
        first_n(
          [files_in(path) | rest],
          n,
          matching,
          result
        )

      :regular ->
        handle_regular_file(path, rest, n, matching, result)

      true ->
        first_n(rest, n - 1, matching, [result])
    end
  end

  defp handle_regular_file(path, rest, n, matching, result) do
    if matching.(path) do
      first_n(rest, n - 1, matching, result)
    else
      first_n(rest, n, matching, result)
    end
  end
end
