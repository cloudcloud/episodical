defmodule EpisodicalWeb.EpisodicController do
  use EpisodicalWeb, :controller

  alias Episodical.External
  alias Episodical.Model
  alias Episodical.Model.Episodic
  alias Episodical.Repo
  alias Episodical.Workers.EpisodicalUpdate
  alias Episodical.Local

  def index(conn, _) do
    episodics = Model.list_episodics()

    eps =
      Enum.map(episodics, fn x ->
        presenter = %Episodical.Presenters.Episodic{episodic: x}
        Episodical.Presenters.Episodic.basic(presenter)
      end)

    render(conn, :index, episodics: eps)
  end

  def new(conn, _params) do
    changeset = Model.change_episodic(%Episodic{} |> Repo.preload(:path))
    render(conn, :new, paths: list_paths(), changeset: changeset)
  end

  def create(conn, %{"episodic" => episodic_params}) do
    case Model.create_episodic(episodic_params) do
      {:ok, episodic} ->
        conn
        |> put_flash(:info, "Episodic created successfully.")
        |> redirect(to: ~p"/episodics/#{episodic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset, paths: list_paths())
    end
  end

  def show(conn, %{"id" => id}) do
    episodic =
      Model.get_episodic!(id)
      |> Repo.preload([:provider, :genres, :path, :files, episodes: [:file]])

    presenter = %Episodical.Presenters.Episodic{episodic: episodic, seasons: %{}, genres: %{}}
    render(conn, :show, episodic: Episodical.Presenters.Episodic.present(presenter))
  end

  def edit(conn, %{"id" => id}) do
    episodic =
      Model.get_episodic!(id)
      |> Repo.preload(:path)

    changeset = Model.change_episodic(episodic)

    render(conn, :edit,
      episodic: episodic,
      providers: External.list_providers_by_type("episodic"),
      paths: list_paths(),
      changeset: changeset
    )
  end

  def update(conn, %{"id" => id, "episodic" => episodic_params}) do
    episodic = Model.get_episodic!(id)

    case Model.update_episodic(episodic, episodic_params) do
      {:ok, episodic} ->
        conn
        |> put_flash(:info, "Episodic updated successfully.")
        |> redirect(to: ~p"/episodics/#{episodic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit,
          episodic: episodic,
          providers: External.list_providers_by_type("episodic"),
          paths: list_paths(),
          changeset: changeset
        )
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
    Que.add(EpisodicalUpdate, %{"id" => id})

    conn
    |> put_flash(:info, "Content refresh begun.")
    |> redirect(to: ~p"/episodics/#{id}")
  end

  def watch(conn, %{"episodic_id" => id, "episode_id" => episode_id}) do
    episode = Model.get_episode!(episode_id)

    if episode.episodic_id != id do
      conn
      |> put_flash(:error, "Unable to mark episode watched!")
      |> redirect(to: ~p"/episodics/#{id}")
    else
      conn
      |> put_flash(:info, "Toggle episode as watched.")
      |> redirect(to: ~p"/episodics/#{id}")
    end
  end

  defp list_paths do
    Local.list_paths()
    |> Enum.map(fn x -> {x.name, x.id} end)
  end
end
