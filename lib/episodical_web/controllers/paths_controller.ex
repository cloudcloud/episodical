defmodule EpisodicalWeb.PathsController do
  use EpisodicalWeb, :controller

  alias Episodical.Local
  alias Episodical.Local.Path

  def index(conn, _params) do
    paths = Local.list_paths()
    render(conn, :index, paths: paths, options: [])
  end

  def new(conn, _params) do
    changeset = Local.change_path(%Path{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"path" => path_params}) do
    case Local.create_path(path_params) do
      {:ok, path} ->
        conn
        |> put_flash(:info, "Path created successfully.")
        |> redirect(to: ~p"/paths/#{path}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    path = Local.get_path!(id)
    render(conn, :show, path: path)
  end

  def edit(conn, %{"id" => id}) do
    path = Local.get_path!(id)
    changeset = Local.change_path(path)

    render(conn, :edit, path: path, changeset: changeset)
  end

  def update(conn, %{"id" => id, "path" => path_params}) do
    path = Local.get_path!(id)

    case Local.update_path(path, path_params) do
      {:ok, path} ->
        conn
        |> put_flash(:info, "Path updated successfully.")
        |> redirect(to: ~p"/paths/#{path}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, path: path, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    path = Local.get_path!(id)
    {:ok, _} = Local.delete_path(path)

    conn
    |> put_flash(:info, "Path deleted successfully.")
    |> redirect(to: ~p"/paths")
  end
end
