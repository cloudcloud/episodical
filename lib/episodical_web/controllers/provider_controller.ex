defmodule EpisodicalWeb.ProviderController do
  use EpisodicalWeb, :controller

  alias Episodical.External
  alias Episodical.External.Provider

  def index(conn, _params) do
    providers =
      External.list_providers()
      |> Episodical.Repo.preload([:token])

    render(conn, :index, providers: providers, options: [])
  end

  def new(conn, _params) do
    changeset = External.change_provider(%Provider{})

    render(conn, :new,
      changeset: changeset,
      options: [Episodic: "episodic", Artist: "artist", Document: "document"]
    )
  end

  def create(conn, %{"provider" => provider_params}) do
    case External.create_provider(provider_params) do
      {:ok, provider} ->
        conn
        |> put_flash(:info, "Provider created successfully.")
        |> redirect(to: ~p"/providers/#{provider}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    provider =
      External.get_provider!(id)
      |> Episodical.Repo.preload([:token])

    render(conn, :show, provider: provider)
  end

  def edit(conn, %{"id" => id}) do
    provider = External.get_provider!(id)
    changeset = External.change_provider(provider)

    render(conn, :edit,
      provider: provider,
      changeset: changeset,
      options: [Episodic: "episodic", Artist: "artist", Document: "document"]
    )
  end

  def update(conn, %{"id" => id, "provider" => provider_params}) do
    provider = External.get_provider!(id)

    case External.update_provider(provider, provider_params) do
      {:ok, provider} ->
        conn
        |> put_flash(:info, "Provider updated successfully.")
        |> redirect(to: ~p"/providers/#{provider}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, provider: provider, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    provider = External.get_provider!(id)
    {:ok, _provider} = External.delete_provider(provider)

    conn
    |> put_flash(:info, "Provider deleted successfully.")
    |> redirect(to: ~p"/providers")
  end
end
