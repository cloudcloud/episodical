defmodule Episodical.ModelFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Episodical.Model` context.
  """

  @doc """
  Generate a song.
  """
  def song_fixture(attrs \\ %{}) do
    {:ok, song} =
      attrs
      |> Enum.into(%{
        length_seconds: 42,
        title: "some title",
        track_index: 42
      })
      |> Episodical.Model.create_song()

    song
  end

  @doc """
  Generate a episodic.
  """
  def episodic_fixture(attrs \\ %{}) do
    {:ok, episodic} =
      attrs
      |> Enum.into(%{
        status: "some status",
        title: "some title",
        release_year: 1942,
        last_checked_at: ~U[2025-02-07 22:58:00.000000Z],
        should_auto_check: true,
        external_id: "abc123",
        image: "https://",
        overview: "overview of the episodic",
        original_language: "eng",
        imdb_id: "tt666"
      })
      |> Episodical.Model.create_episodic()

    episodic
  end

  @doc """
  Generate a artist.
  """
  def artist_fixture(attrs \\ %{}) do
    {:ok, artist} =
      attrs
      |> Enum.into(%{
        base_location: "some base_location",
        formed_year: 42,
        last_checked_at: ~U[2025-02-07 22:58:00.000000Z],
        name: "some name",
        should_auto_check: true
      })
      |> Episodical.Model.create_artist()

    artist
  end

  @doc """
  Generate a document.
  """
  def document_fixture(attrs \\ %{}) do
    {:ok, document} =
      attrs
      |> Enum.into(%{
        author: "some author",
        is_read: true,
        read_at: ~U[2025-02-08 10:16:00.000000Z],
        last_checked_at: ~U[2025-02-07 22:58:00.000000Z],
        released_at: ~U[2025-02-07 22:58:00Z],
        should_auto_check: true,
        title: "some title"
      })
      |> Episodical.Model.create_document()

    document
  end

  @doc """
  Generate a episode.
  """
  def episode_fixture(attrs \\ %{}) do
    {:ok, episode} =
      attrs
      |> Enum.into(%{
        index: 42,
        is_watched: true,
        overview: "some overview",
        released_at: ~U[2025-02-07 22:58:00Z],
        season: 42,
        title: "some title",
        watched_at: ~U[2025-02-07 22:58:00.000000Z]
      })
      |> Episodical.Model.create_episode()

    episode
  end

  @doc """
  Generate a album.
  """
  def album_fixture(attrs \\ %{}) do
    {:ok, album} =
      attrs
      |> Enum.into(%{
        released_at: ~U[2025-02-07 22:58:00Z],
        song_count: 42,
        title: "some title"
      })
      |> Episodical.Model.create_album()

    album
  end

  @doc """
  Generate a config of a specific type.
  """
  def config_fixture(atom, attrs \\ %{}) do
    input =
      attrs
      |> Enum.into(%{
        "name" => Atom.to_string(atom),
        "value" => gen_config_input(atom),
        "is_active" => true
      })

    Episodical.Repo.insert!(%Episodical.Model.Config{
      name: input["name"],
      value: input["value"],
      is_active: input["is_active"]
    })
  end

  defp gen_config_input(atom) do
    case atom do
      :episodic_path_layout -> ":upper_word_title/:upper_word_season/:files"
      :episodic_filename_pattern -> ""
      :episodical_language -> "eng"
    end
  end
end
