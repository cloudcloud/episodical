defmodule Episodical.Local do
  @moduledoc """
  The Local context.
  """

  import Ecto.Query, warn: false
  alias Episodical.Repo

  alias Episodical.Local.Path

  @doc """
  Returns the list of paths.

  ## Examples

      iex> list_paths()
      [%Path{}, ...]

  """
  def list_paths do
    Repo.all(Path)
  end

  @doc """
  Gets a single path.

  Raises `Ecto.NoResultsError` if the Path does not exist.

  ## Examples

      iex> get_path!(123)
      %Path{}

      iex> get_path!(456)
      ** (Ecto.NoResultsError)

  """
  def get_path!(id), do: Repo.get!(Path, id)

  @doc """
  Creates a path.

  ## Examples

      iex> create_path(%{field: value})
      {:ok, %Path{}}

      iex> create_path(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_path(attrs \\ %{}) do
    %Path{}
    |> Path.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a path.

  ## Examples

      iex> update_path(path, %{field: new_value})
      {:ok, %Path{}}

      iex> update_path(path, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_path(%Path{} = path, attrs) do
    path
    |> Path.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a path.

  ## Examples

      iex> delete_path(path)
      {:ok, %Path{}}

      iex> delete_path(path)
      {:error, %Ecto.Changeset{}}

  """
  def delete_path(%Path{} = path) do
    Repo.delete(path)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking path changes.

  ## Examples

      iex> change_path(path)
      %Ecto.Changeset{data: %Path{}}

  """
  def change_path(%Path{} = path, attrs \\ %{}) do
    Path.changeset(path, attrs)
  end

  alias Episodical.Local.File

  @doc """
  Returns the list of files.

  ## Examples

      iex> list_files()
      [%File{}, ...]

  """
  def list_files do
    Repo.all(File)
  end

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the File does not exist.

  ## Examples

      iex> get_file!(123)
      %File{}

      iex> get_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_file!(id), do: Repo.get!(File, id)

  @doc """
  Creates a file.

  ## Examples

      iex> create_file(%{field: value})
      {:ok, %File{}}

      iex> create_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_file(attrs \\ %{}) do
    %File{}
    |> File.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a file.

  ## Examples

      iex> update_file(file, %{field: new_value})
      {:ok, %File{}}

      iex> update_file(file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_file(%File{} = file, attrs) do
    file
    |> File.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a file.

  ## Examples

      iex> delete_file(file)
      {:ok, %File{}}

      iex> delete_file(file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_file(%File{} = file) do
    Repo.delete(file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.

  ## Examples

      iex> change_file(file)
      %Ecto.Changeset{data: %File{}}

  """
  def change_file(%File{} = file, attrs \\ %{}) do
    File.changeset(file, attrs)
  end
end
