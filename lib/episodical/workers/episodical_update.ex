defmodule Episodical.Workers.EpisodicalUpdate do
  use Que.Worker

  alias Episodical.Repo
  alias Episodical.Model
  alias Episodical.External
  alias Episodical.External.Provider.TheTVDB

  def perform(input) do
    episodic =
      Model.get_episodic!(input["id"])
      |> Repo.preload([:provider])

    provider =
      External.get_provider!(episodic.provider_id)
      |> Repo.preload([:token])

    {:ok, episodic} =
      provider
      |> query_provider(:main_episodic, episodic)
      |> update_episodic(episodic)
      |> capture_episodes(episodic)

    IO.inspect episodic
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
  } = results}, episodic) do

    %{"id" => imdb_id} = Enum.find(remotes, fn x -> x["sourceName"] == "IMDB" end)
    date = case Date.from_iso8601(next_airing) do
      {:ok, date} ->
        DateTime.new!(date, ~T[00:00:00])
      _ ->
        nil
    end

    case Model.update_episodic(episodic, %{
      image: image,
      status: status,
      last_checked_at: DateTime.now!("Etc/UTC"),
      overview: overview,
      original_language: original_language,
      next_airing: date,
      imdb_id: imdb_id,
    }) do
      {:ok, _} ->
        {:ok, results}

      {:error, %Ecto.Changeset{}} ->
        {:error, results}
    end
  end

  defp capture_genres({:ok, %{
    "data" => %{
      "genres" => _genres,
    }
  }}, episodic) do

    {:ok, episodic}
  end

  defp capture_episodes({:ok, %{
    "data" => %{
      "episodes" => _episodes,
    }
  }}, episodic) do

    {:ok, episodic}
  end
end
