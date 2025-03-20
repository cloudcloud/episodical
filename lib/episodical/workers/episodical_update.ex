defmodule Episodical.Workers.EpisodicalUpdate do
  use Que.Worker

  alias Episodical.Repo
  alias Episodical.Model
  alias Episodical.External
  alias Episodical.External.Provider.TheTVDB
  alias Episodical.Model.Episodic

  def perform(input) do
    episodic =
      Model.get_episodic!(input["id"])
      |> Repo.preload([:provider])

    provider =
      External.get_provider!(episodic.provider_id)
      |> Repo.preload([:token])
    provider_id = provider.id

    {:ok, episodic} =
      provider
      |> query_provider(:main_episodic, episodic)
      |> update_episodic
      |> capture_genres(provider_id)
      |> capture_episodes(provider_id)
      |> store_full_episodic(episodic)

    episodic
  end

  defp query_provider(%{service_type: "thetvdb"} = provider, type, episodic) do
    case type do
      :main_episodic ->
        TheTVDB.get_series(provider, episodic.external_id)
      :episodic_episodes ->
        {:ok, ""}
      _ ->
        {:error, ""}
    end
  end

  defp update_episodic({:ok, %{
    "data" => %{
      "remoteIds" => remotes,
      "image" => image,
      "status" => %{
        "name" => status,
      },
      "nextAired" => next_airing,
      "overview" => overview,
      "originalLanguage" => original_language,
    },
  } = results}) do

    %{"id" => imdb_id} = Enum.find(remotes, fn x -> x["sourceName"] == "IMDB" end)
    date = case Date.from_iso8601(next_airing) do
      {:ok, date} ->
        DateTime.new!(date, ~T[00:00:00])
      _ ->
        nil
    end

    {:ok, %{
      :image => image,
      :status => status,
      :last_checked_at => DateTime.now!("Etc/UTC"),
      :overview => overview,
      :original_language => original_language,
      :next_airing => date,
      :imdb_id => imdb_id,
    }, results}
  end

  defp capture_genres({:ok, change, %{"data" => %{"id" => series_id, "genres" => genres}} = results}, provider_id) do
    genre_changes = Enum.map(genres, fn v -> %{
      :external_id => "#{Integer.to_string(series_id)}.#{Integer.to_string(v["id"])}",
      :genre => v["name"],
      :provider_id => provider_id,
    } end)

    {:ok, Map.put_new(change, :genres, genre_changes), results}
  end

  defp capture_episodes({:ok, change, %{"data" => %{"id" => series_id, "episodes" => episodes}} = results}, provider_id) do
    episode_changes = Enum.map(episodes, fn v ->

      released_at = try do
        case Date.from_iso8601(v["aired"]) do
          {:ok, released} ->
            DateTime.new!(released, ~T[00:00:00])
          _ ->
            nil
        end
      rescue
        FunctionClauseError -> nil
      end

      %{
        :provider_id => provider_id,
        :external_id => "#{Integer.to_string(series_id)}.#{Integer.to_string(v["id"])}",
        :title => v["name"],
        :season => v["seasonNumber"],
        :released_at => released_at,
        :is_watched => false,
        :watched_at => nil,
        :overview => v["overview"],
        :index => v["number"],
      }
    end )

    {:ok, Map.put_new(change, :episodes, episode_changes), results}
  end

  defp store_full_episodic({:ok, change, _}, episodic) do
    Episodic.full_changeset(episodic, change)
    |> Repo.update()
  end
end
