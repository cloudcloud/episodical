defmodule EpisodicalWeb.EpisodicController do
  use EpisodicalWeb, :controller

  alias Episodical.External
  alias Episodical.Model
  alias Episodical.Model.Episodic
  alias Episodical.Repo
  alias Episodical.Workers

  def index(conn, params) do
    {:ok, {episodics, meta}} = Model.list_episodics(params)

    eps = Enum.map(episodics, fn x ->
      presenter = %Episodical.Presenters.Episodic{episodic: x}
      Episodical.Presenters.Episodic.basic(presenter)
    end)

    render(conn, :index, meta: meta, episodics: eps)
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
    episodic =
      Model.get_episodic!(id)
      |> Repo.preload([:provider, :genres, :episodes])

    presenter = %Episodical.Presenters.Episodic{episodic: episodic, seasons: %{}, genres: %{}}
    render(conn, :show, episodic: Episodical.Presenters.Episodic.present(presenter))
  end

  def edit(conn, %{"id" => id}) do
    episodic = Model.get_episodic!(id)
    changeset = Model.change_episodic(episodic)

    render(conn, :edit, episodic: episodic, providers: External.list_providers_by_type("episodic"), changeset: changeset)
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

  def refresh(conn, %{"episodic_id" => id}) do
    Que.add(Workers.EpisodicalUpdate, %{"id" => id})

    conn
    |> put_flash(:info, "Content refresh begun.")
    |> redirect(to: ~p"/episodics/#{id}")
  end

  def watch(conn, %{"episodic_id" => id, "episode_id" => episode_id}) do
    episodic = Model.get_episodic!(id)
      |> Repo.preload(:episodes)

    conn
    |> put_flash(:info, "Toggle episode as watched.")
    |> redirect(to: ~p"/episodics/#{id}")
  end
end
