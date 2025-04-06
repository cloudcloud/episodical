defmodule Episodical.ModelTest do
  use Episodical.DataCase

  alias Episodical.Model

  import Logger

  describe "episodics" do
    alias Episodical.Model.Episodic

    import Episodical.ModelFixtures

    @invalid_attrs %{
      status: nil,
      title: nil,
      release_year: nil,
      last_checked_at: nil,
      external_id: nil
    }

    test "list_episodics/0 returns all episodics" do
      episodic = episodic_fixture()

      {:ok, {_, meta}} = Model.list_episodics(%{})

      assert {:ok, {[episodic |> Episodical.Repo.preload([:episodes, :genres])], meta}} ==
               Model.list_episodics(%{})
    end

    test "get_episodic!/1 returns the episodic with given id" do
      episodic = episodic_fixture()
      assert Model.get_episodic!(episodic.id) == episodic
    end

    test "create_episodic/1 with valid data creates a episodic" do
      valid_attrs = %{
        status: "some status",
        title: "some title",
        release_year: 42,
        last_checked_at: ~U[2025-02-07 10:15:00.000000Z],
        external_id: "some external_id"
      }

      assert {:ok, %Episodic{} = episodic} = Model.create_episodic(valid_attrs)
      assert episodic.status == "some status"
      assert episodic.title == "some title"
      assert episodic.release_year == 42
      assert episodic.last_checked_at == ~U[2025-02-07 10:15:00.000000Z]
      assert episodic.external_id == "some external_id"
    end

    test "create_episodic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_episodic(@invalid_attrs)
    end

    test "update_episodic/2 with valid data updates the episodic" do
      episodic = episodic_fixture()

      update_attrs = %{
        status: "some updated status",
        title: "some updated title",
        release_year: 43,
        last_checked_at: ~U[2025-02-08 10:15:00.000000Z],
        external_id: "some updated external_id"
      }

      assert {:ok, %Episodic{} = episodic} = Model.update_episodic(episodic, update_attrs)
      assert episodic.status == "some updated status"
      assert episodic.title == "some updated title"
      assert episodic.release_year == 43
      assert episodic.last_checked_at == ~U[2025-02-08 10:15:00.000000Z]
      assert episodic.external_id == "some updated external_id"
    end

    test "update_episodic/2 with invalid data returns error changeset" do
      episodic = episodic_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_episodic(episodic, @invalid_attrs)
      assert episodic == Model.get_episodic!(episodic.id)
    end

    test "delete_episodic/1 deletes the episodic" do
      episodic = episodic_fixture()
      assert {:ok, %Episodic{}} = Model.delete_episodic(episodic)
      assert_raise Ecto.NoResultsError, fn -> Model.get_episodic!(episodic.id) end
    end

    test "change_episodic/1 returns a episodic changeset" do
      episodic = episodic_fixture()
      assert %Ecto.Changeset{} = Model.change_episodic(episodic)
    end
  end

  describe "artists" do
    alias Episodical.Model.Artist

    import Episodical.ModelFixtures

    @invalid_attrs %{name: nil, formed_year: nil, base_location: nil, external_id: nil}

    test "list_artists/0 returns all artists" do
      artist = artist_fixture()
      assert Model.list_artists() == [artist]
    end

    test "get_artist!/1 returns the artist with given id" do
      artist = artist_fixture()
      assert Model.get_artist!(artist.id) == artist
    end

    test "create_artist/1 with valid data creates a artist" do
      valid_attrs = %{
        name: "some name",
        formed_year: 42,
        base_location: "some base_location",
        external_id: "some external_id",
        last_checked_at: ~U[2025-02-08 10:15:00.000000Z]
      }

      assert {:ok, %Artist{} = artist} = Model.create_artist(valid_attrs)
      assert artist.name == "some name"
      assert artist.formed_year == 42
      assert artist.base_location == "some base_location"
      assert artist.external_id == "some external_id"
    end

    test "create_artist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_artist(@invalid_attrs)
    end

    test "update_artist/2 with valid data updates the artist" do
      artist = artist_fixture()

      update_attrs = %{
        name: "some updated name",
        formed_year: 43,
        base_location: "some updated base_location",
        external_id: "some updated external_id"
      }

      assert {:ok, %Artist{} = artist} = Model.update_artist(artist, update_attrs)
      assert artist.name == "some updated name"
      assert artist.formed_year == 43
      assert artist.base_location == "some updated base_location"
      assert artist.external_id == "some updated external_id"
    end

    test "update_artist/2 with invalid data returns error changeset" do
      artist = artist_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_artist(artist, @invalid_attrs)
      assert artist == Model.get_artist!(artist.id)
    end

    test "delete_artist/1 deletes the artist" do
      artist = artist_fixture()
      assert {:ok, %Artist{}} = Model.delete_artist(artist)
      assert_raise Ecto.NoResultsError, fn -> Model.get_artist!(artist.id) end
    end

    test "change_artist/1 returns a artist changeset" do
      artist = artist_fixture()
      assert %Ecto.Changeset{} = Model.change_artist(artist)
    end
  end

  describe "documents" do
    alias Episodical.Model.Document

    import Episodical.ModelFixtures

    @invalid_attrs %{title: nil, author: nil, released_at: nil, external_id: nil, is_read: nil}

    test "list_documents/0 returns all documents" do
      documents = document_fixture()
      assert Model.list_documents() == [documents]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Model.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      valid_attrs = %{
        title: "some title",
        author: "some author",
        released_at: ~U[2025-02-07 10:16:00Z],
        last_checked_at: ~U[2025-02-07 10:16:00.000000Z],
        is_read: true,
        read_at: ~U[2025-02-08 10:16:00.000000Z]
      }

      assert {:ok, %Document{} = document} = Model.create_document(valid_attrs)
      assert document.title == "some title"
      assert document.author == "some author"
      assert document.released_at == ~U[2025-02-07 10:16:00Z]
      assert document.is_read == true
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()

      update_attrs = %{
        title: "some updated title",
        author: "some updated author",
        released_at: ~U[2025-02-08 10:16:00Z],
        external_id: "some updated external_id",
        is_read: false,
        read_at: ~U[2025-02-08 10:16:00.000000Z]
      }

      assert {:ok, %Document{} = document} = Model.update_document(document, update_attrs)
      assert document.title == "some updated title"
      assert document.author == "some updated author"
      assert document.released_at == ~U[2025-02-08 10:16:00Z]
      assert document.external_id == "some updated external_id"
      assert document.is_read == false
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_document(document, @invalid_attrs)
      assert document == Model.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Model.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Model.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Model.change_document(document)
    end
  end

  describe "episodic_episodes" do
    alias Episodical.Model.Episodic.Episode

    import Episodical.ModelFixtures

    @invalid_attrs %{
      index: nil,
      title: nil,
      season: nil,
      released_at: nil,
      is_watched: nil,
      watched_at: nil,
      overview: nil
    }

    test "list_episodic_episodes/0 returns all episodic_episodes" do
      episode = episode_fixture()
      assert Model.list_episodic_episodes() == [episode]
    end

    test "get_episode!/1 returns the episode with given id" do
      episode = episode_fixture()
      assert Model.get_episode!(episode.id) == episode
    end

    test "create_episode/1 with valid data creates a episode" do
      valid_attrs = %{
        index: 42,
        title: "some title",
        season: 42,
        released_at: ~U[2025-02-07 22:58:00Z],
        is_watched: true,
        watched_at: ~U[2025-02-07 22:58:00Z],
        overview: "some overview"
      }

      assert {:ok, %Episode{} = episode} = Model.create_episode(valid_attrs)
      assert episode.index == 42
      assert episode.title == "some title"
      assert episode.season == 42
      assert episode.released_at == ~U[2025-02-07 22:58:00Z]
      assert episode.is_watched == true
      assert episode.watched_at == ~U[2025-02-07 22:58:00.000000Z]
      assert episode.overview == "some overview"
    end

    test "create_episode/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_episode(@invalid_attrs)
    end

    test "update_episode/2 with valid data updates the episode" do
      episode = episode_fixture()

      update_attrs = %{
        index: 43,
        title: "some updated title",
        season: 43,
        released_at: ~U[2025-02-08 22:58:00Z],
        is_watched: false,
        watched_at: ~U[2025-02-08 22:58:00Z],
        overview: "some updated overview"
      }

      assert {:ok, %Episode{} = episode} = Model.update_episode(episode, update_attrs)
      assert episode.index == 43
      assert episode.title == "some updated title"
      assert episode.season == 43
      assert episode.released_at == ~U[2025-02-08 22:58:00Z]
      assert episode.is_watched == false
      assert episode.watched_at == ~U[2025-02-08 22:58:00.000000Z]
      assert episode.overview == "some updated overview"
    end

    test "update_episode/2 with invalid data returns error changeset" do
      episode = episode_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_episode(episode, @invalid_attrs)
      assert episode == Model.get_episode!(episode.id)
    end

    test "delete_episode/1 deletes the episode" do
      episode = episode_fixture()
      assert {:ok, %Episode{}} = Model.delete_episode(episode)
      assert_raise Ecto.NoResultsError, fn -> Model.get_episode!(episode.id) end
    end

    test "change_episode/1 returns a episode changeset" do
      episode = episode_fixture()
      assert %Ecto.Changeset{} = Model.change_episode(episode)
    end
  end

  describe "artist_albums" do
    alias Episodical.Model.Artist.Album

    import Episodical.ModelFixtures

    @invalid_attrs %{title: nil, released_at: nil, song_count: nil}

    test "list_artist_albums/0 returns all artist_albums" do
      album = album_fixture()
      assert Model.list_artist_albums() == [album]
    end

    test "get_album!/1 returns the album with given id" do
      album = album_fixture()
      assert Model.get_album!(album.id) == album
    end

    test "create_album/1 with valid data creates a album" do
      valid_attrs = %{title: "some title", released_at: ~U[2025-02-07 22:58:00Z], song_count: 42}

      assert {:ok, %Album{} = album} = Model.create_album(valid_attrs)
      assert album.title == "some title"
      assert album.released_at == ~U[2025-02-07 22:58:00Z]
      assert album.song_count == 42
    end

    test "create_album/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_album(@invalid_attrs)
    end

    test "update_album/2 with valid data updates the album" do
      album = album_fixture()

      update_attrs = %{
        title: "some updated title",
        released_at: ~U[2025-02-08 22:58:00Z],
        song_count: 43
      }

      assert {:ok, %Album{} = album} = Model.update_album(album, update_attrs)
      assert album.title == "some updated title"
      assert album.released_at == ~U[2025-02-08 22:58:00Z]
      assert album.song_count == 43
    end

    test "update_album/2 with invalid data returns error changeset" do
      album = album_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_album(album, @invalid_attrs)
      assert album == Model.get_album!(album.id)
    end

    test "delete_album/1 deletes the album" do
      album = album_fixture()
      assert {:ok, %Album{}} = Model.delete_album(album)
      assert_raise Ecto.NoResultsError, fn -> Model.get_album!(album.id) end
    end

    test "change_album/1 returns a album changeset" do
      album = album_fixture()
      assert %Ecto.Changeset{} = Model.change_album(album)
    end
  end

  describe "artist_songs" do
    alias Episodical.Model.Artist.Song

    import Episodical.ModelFixtures

    @invalid_attrs %{title: nil, length_seconds: nil, track_index: nil}

    test "list_artist_songs/0 returns all artist_songs" do
      song = song_fixture()
      assert Model.list_artist_songs() == [song]
    end

    test "get_song!/1 returns the song with given id" do
      song = song_fixture()
      assert Model.get_song!(song.id) == song
    end

    test "create_song/1 with valid data creates a song" do
      valid_attrs = %{title: "some title", length_seconds: 42, track_index: 42}

      assert {:ok, %Song{} = song} = Model.create_song(valid_attrs)
      assert song.title == "some title"
      assert song.length_seconds == 42
      assert song.track_index == 42
    end

    test "create_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_song(@invalid_attrs)
    end

    test "update_song/2 with valid data updates the song" do
      song = song_fixture()
      update_attrs = %{title: "some updated title", length_seconds: 43, track_index: 43}

      assert {:ok, %Song{} = song} = Model.update_song(song, update_attrs)
      assert song.title == "some updated title"
      assert song.length_seconds == 43
      assert song.track_index == 43
    end

    test "update_song/2 with invalid data returns error changeset" do
      song = song_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_song(song, @invalid_attrs)
      assert song == Model.get_song!(song.id)
    end

    test "delete_song/1 deletes the song" do
      song = song_fixture()
      assert {:ok, %Song{}} = Model.delete_song(song)
      assert_raise Ecto.NoResultsError, fn -> Model.get_song!(song.id) end
    end

    test "change_song/1 returns a song changeset" do
      song = song_fixture()
      assert %Ecto.Changeset{} = Model.change_song(song)
    end
  end
end
