defmodule Episodical.Local do
  @moduledoc """
  The Local context.
  """

  import Ecto.Query, warn: false

  alias Episodical.Repo
  alias Episodical.Local
  alias Episodical.Model

  @doc """
  Returns the list of paths.
  """
  @spec list_paths() :: [Local.Path.t()]
  def list_paths do
    Repo.all(Local.Path)
  end

  @doc """
  Gets a single path.

  Raises `Ecto.NoResultsError` if the Local.Path does not exist.
  """
  @spec get_path!(String.t()) :: Local.Path.t()
  def get_path!(id), do: Repo.get!(Local.Path, id)

  @doc """
  Creates a path.
  """
  @spec create_path(map) :: {:ok, Local.Path.t()} | {:error, Ecto.Changeset.t()}
  def create_path(attrs \\ %{}) do
    %Local.Path{}
    |> Local.Path.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a path.
  """
  @spec update_path(Local.Path.t(), map) :: {:ok, Local.Path.t()} | {:error, Ecto.Changeset.t()}
  def update_path(%Local.Path{} = path, attrs) do
    path
    |> Local.Path.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a path.
  """
  @spec delete_path(Local.Path.t()) :: {:ok, Local.Path.t()} | {:error, Ecto.Changeset.t()}
  def delete_path(%Local.Path{} = path) do
    Repo.delete(path)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking path changes.
  """
  @spec change_path(Local.Path.t(), map) :: Ecto.Changeset.t()
  def change_path(%Local.Path{} = path, attrs \\ %{}) do
    Local.Path.changeset(path, attrs)
  end

  @doc """
  Returns the list of files.
  """
  @spec list_files() :: [Local.File.t()]
  def list_files do
    Repo.all(Local.File)
      |> Enum.map(fn x -> Repo.preload(x, [:episode, :episodic, :path]) end)
  end

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the Local.File does not exist.
  """
  @spec get_file!(String.t()) :: Local.File.t()
  def get_file!(id), do: Repo.get!(Local.File, id)

  @doc """
  Creates a file.
  """
  @spec create_file(map) :: {:ok, Local.File.t()} | {:error, Ecto.Changeset.t()}
  def create_file(attrs \\ %{}) do
    %Local.File{}
    |> Local.File.changeset(attrs)
    |> Repo.insert()
  end

  @spec get_or_insert_file(map) :: Local.File.t()
  def get_or_insert_file(attrs) do
    %Local.File{}
    |> Local.File.changeset(attrs)
    |> Repo.insert(
        on_conflict: {:replace_all_except, [:id, :created_at]},
        conflict_target: [:name],
        returning: true
      )
  end

  @doc """
  Updates a file.
  """
  @spec update_file(Local.File.t(), map) :: {:ok, Local.File.t()} | {:error, Ecto.Changeset.t()}
  def update_file(%Local.File{} = file, attrs) do
    file
    |> Local.File.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a file.
  """
  @spec delete_file(Local.File.t()) :: {:ok, Local.File.t()} | {:error, Ecto.Changeset.t()}
  def delete_file(%Local.File{} = file) do
    Repo.delete(file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.
  """
  @spec change_file(Local.File.t(), map) :: Ecto.Changeset.t()
  def change_file(%Local.File{} = file, attrs \\ %{}) do
    Local.File.changeset(file, attrs)
  end

  @doc """
  Taken a path, find files that match a particular pattern.
  """
  @spec discover_files(Model.Episodic.t()) :: list()
  def discover_files(%Model.Episodic{} = episodic) do
    {:ok, layout_regex} = Model.get_config_by_name!("episodic_path_layout")
      |> Local.Path.use_path_layout(episodic)

    with true <- File.dir?(episodic.path.name),
      {:ok, files} <- Local.Path.find_matching_files(episodic.path, layout_regex) do
        {:ok, file_match} = Model.get_config_by_name!("episodic_filename_pattern")
          |> Map.fetch!(:value)
          |> Regex.compile

        match_file_to_episode(episodic, file_match, files)

    else
      false ->
        {:error, "Path is not a valid location."}

    end
  end

  defp match_file_to_episode(episodic, file_match, files, count \\ 0)
  defp match_file_to_episode(_, _, [], count), do: {:ok, count}
  defp match_file_to_episode(episodic, file_match, [file | files], count) do
    matches = Regex.named_captures(file_match, file)

    with true <- Model.file_find_matching_episode(episodic, matches, file) do
      match_file_to_episode(episodic, file_match, files, count+1)
    else
      _ ->
        match_file_to_episode(episodic, file_match, files, count)
    end
  end
end
