defmodule Episodical.Local do
  @moduledoc """
  The Local context.
  """

  import Ecto.Query, warn: false

  alias Episodical.Repo
  alias Episodical.Local.Path
  alias Episodical.Local.File

  @doc """
  Returns the list of paths.
  """
  @spec list_paths() :: [Path.t()]
  def list_paths do
    Repo.all(Path)
  end

  @doc """
  Gets a single path.

  Raises `Ecto.NoResultsError` if the Path does not exist.
  """
  @spec get_path!(String.t()) :: Path.t()
  def get_path!(id), do: Repo.get!(Path, id)

  @doc """
  Creates a path.
  """
  @spec create_path(map) :: {:ok, Path.t()} | {:error, Ecto.Changeset.t()}
  def create_path(attrs \\ %{}) do
    %Path{}
    |> Path.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a path.
  """
  @spec update_path(Path.t(), map) :: {:ok, Path.t()} | {:error, Ecto.Changeset.t()}
  def update_path(%Path{} = path, attrs) do
    path
    |> Path.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a path.
  """
  @spec delete_path(Path.t()) :: {:ok, Path.t()} | {:error, Ecto.Changeset.t()}
  def delete_path(%Path{} = path) do
    Repo.delete(path)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking path changes.
  """
  @spec change_path(Path.t(), map) :: Ecto.Changeset.t()
  def change_path(%Path{} = path, attrs \\ %{}) do
    Path.changeset(path, attrs)
  end

  @doc """
  Returns the list of files.
  """
  @spec list_files() :: [File.t()]
  def list_files do
    Repo.all(File)
  end

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the File does not exist.
  """
  @spec get_file!(String.t()) :: File.t()
  def get_file!(id), do: Repo.get!(File, id)

  @doc """
  Creates a file.
  """
  @spec create_file(map) :: {:ok, File.t()} | {:error, Ecto.Changeset.t()}
  def create_file(attrs \\ %{}) do
    %File{}
    |> File.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a file.
  """
  @spec update_file(File.t(), map) :: {:ok, File.t()} | {:error, Ecto.Changeset.t()}
  def update_file(%File{} = file, attrs) do
    file
    |> File.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a file.
  """
  @spec delete_file(File.t()) :: {:ok, File.t()} | {:error, Ecto.Changeset.t()}
  def delete_file(%File{} = file) do
    Repo.delete(file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.
  """
  @spec change_file(File.t(), map) :: Ecto.Changeset.t()
  def change_file(%File{} = file, attrs \\ %{}) do
    File.changeset(file, attrs)
  end
end
