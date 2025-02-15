defmodule EpisodicalWeb.EpisodicController do
  use EpisodicalWeb, :controller

  alias Episodical.Model
  alias Episodical.Model.Episodic

  def index(conn, _params) do
    episodics = Model.list_episodics()
    render(conn, :index, episodics: episodics)
  end

  def new(conn, _params) do
    changeset = Model.change_episodic(%Episodic{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"episodic" => episodic_params}) do
    case Model.create_episodic(episodic_params) do
      {:ok, episodic} ->
        conn
        |> put_flash(:info, "Episodic created successfully.")
        |> redirect(to: ~p"/episodics/#{episodic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    episodic = Model.get_episodic!(id)
    render(conn, :show, episodic: episodic)
  end

  def edit(conn, %{"id" => id}) do
    episodic = Model.get_episodic!(id)
    changeset = Model.change_episodic(episodic)
    render(conn, :edit, episodic: episodic, changeset: changeset)
  end

  def update(conn, %{"id" => id, "episodic" => episodic_params}) do
    episodic = Model.get_episodic!(id)

    case Model.update_episodic(episodic, episodic_params) do
      {:ok, episodic} ->
        conn
        |> put_flash(:info, "Episodic updated successfully.")
        |> redirect(to: ~p"/episodics/#{episodic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, episodic: episodic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    episodic = Model.get_episodic!(id)
    {:ok, _episodic} = Model.delete_episodic(episodic)

    conn
    |> put_flash(:info, "Episodic deleted successfully.")
    |> redirect(to: ~p"/episodics")
  end
end
