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
      options: provider_options()
    )
  end

  def create(conn, %{"provider" => provider_params}) do
    case External.create_provider(provider_params) do
      {:ok, provider} ->
        conn
        |> put_flash(:info, "Provider created successfully.")
        |> redirect(to: ~p"/providers/#{provider}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset, options: provider_options())
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
      options: provider_options()
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
        render(conn, :edit, provider: provider, changeset: changeset, options: provider_options())
    end
  end

  def delete(conn, %{"id" => id}) do
    provider = External.get_provider!(id)
    {:ok, _provider} = External.delete_provider(provider)

    conn
    |> put_flash(:info, "Provider deleted successfully.")
    |> redirect(to: ~p"/providers")
  end

  def delete_token(conn, %{"provider_id" => provider_id, "id" => id}) do
    token = External.get_token!(id)
    {:ok, _token} = External.delete_token(token)

    conn
    |> put_flash(:info, "Token deleted successfully.")
    |> redirect(to: ~p"/providers/#{provider_id}")
  end

  defp provider_options(), do: [Episodic: "episodic", Artist: "artist", Document: "document"]
end
