defmodule EpisodicalWeb.EpisodicAssociateController do
  use EpisodicalWeb, :controller

  alias Episodical.Model
  alias Episodical.External
  alias Episodical.External.Provider.TheTVDB
  alias Episodical.Presenters.ProviderSearchResults

  def show(conn, %{"id" => id, "episodic_id" => episodic_id}) do
    episodic = Model.get_episodic!(episodic_id)
    changeset = Model.change_episodic(episodic)

    provider = External.get_provider!(id)

    with %{service_type: "thetvdb"} <- provider,
        {:ok, results} <- TheTVDB.search_by_show_title(provider, episodic.title, episodic.release_year),
        {:ok, data} <- ProviderSearchResults.from_thetvdb(%ProviderSearchResults{service_type: TheTVDB.service_type?, results: results}) do
      render(conn, :show, episodic: episodic, provider: provider, results: data, changeset: changeset)
    end
  end

  def create(conn, %{"episodic_id" => id, "external_id" => external_id, "provider_id" => provider_id}) do
    episodic = Model.get_episodic!(id)
    provider = External.get_provider!(provider_id)

    case Model.update_episodic(episodic, %{"id" => id, "external_id" => external_id, "provider_id" => provider.id}) do
      {:ok, episodic} ->
        conn
        |> put_flash(:info, "Episodic provider updated successfully.")
        |> redirect(to: ~p"/episodics/#{episodic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :show, episodic: episodic, changeset: changeset, provider: provider)
    end
  end
end
