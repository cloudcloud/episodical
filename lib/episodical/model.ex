defmodule Episodical.Model do
  @moduledoc """
  The Model context. This context wraps the base Models across Episodical, giving
  nice ways of interacting with them from the outside.
  """

  import Logger
  import Ecto.Query, warn: false

  alias Episodical.Repo
  alias Episodical.Model.Episodic
  alias Episodical.Model.Artist
  alias Episodical.Model.Document
  alias Episodical.Model.Episodic.Episode
  alias Episodical.Model.Artist.Album
  alias Episodical.Model.Artist.Song
  alias Episodical.Model.Config
  alias Episodical.Local

  @doc """
  Returns the list of episodics.
  """
  @spec list_episodics(map) :: {:ok, {[Pet.t()], Flop.Meta.t()}} | {:error, Flop.Meta.t()}
  def list_episodics(params) do
    {:ok, {episodes, meta}} = Episodic
      |> Flop.validate_and_run(params, for: Episodic, replace_invalid_params: true)

    {:ok, {Repo.preload(episodes, [:episodes, :genres]), meta}}
  end

  @doc """
  Gets a single episodic.

  Raises `Ecto.NoResultsError` if the Episodic does not exist.
  """
  @spec get_episodic!(String.t()) :: Episodic.t()
  def get_episodic!(id), do: Repo.get!(Episodic, id)

  @doc """
  Creates a episodic.
  """
  @spec create_episodic(map) :: {:ok, Episodic.t()} | {:error, Ecto.Changeset.t()}
  def create_episodic(attrs \\ %{}) do
    path = Local.get_path!(attrs["path"])
      |> Repo.preload(:episodic)

    %Episodic{}
      |> Repo.preload(:path)
      |> Episodic.changeset(attrs)
      |> Episodic.assoc_path(path)
      |> Repo.insert()
  end

  @doc """
  Updates a episodic.
  """
  @spec update_episodic(Episodic.t(), map) :: {:ok, Episodic.t()} | {:error, Ecto.Changeset.t()}
  def update_episodic(%Episodic{} = episodic, attrs) do
    # Load the Path for associating
    case Map.pop(attrs, "path", "") do
      {"", _} ->
        episodic
          |> Episodic.changeset(attrs)
          |> Repo.update()

      {path_id, _} ->
        path = Local.get_path!(path_id)
          |> Repo.preload(:episodic)

        episodic
          |> Repo.preload(:path)
          |> Episodic.assoc_path(path)
          |> Repo.update()
    end
  end

  @doc """
  Deletes a episodic.
  """
  @spec delete_episodic(Episodic.t()) :: {:ok, Episodic.t()} | {:error, Ecto.Changeset.t()}
  def delete_episodic(%Episodic{} = episodic) do
    Repo.delete(episodic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking episodic changes.
  """
  @spec change_episodic(Episodic.t(), map) :: Ecto.Changeset.t()
  def change_episodic(%Episodic{} = episodic, attrs \\ %{}) do
    Episodic.changeset(episodic, attrs)
  end

  @doc """
  Returns the list of artists.
  """
  @spec list_artists() :: [Artist.t()]
  def list_artists do
    Repo.all(Artist)
  end

  @doc """
  Gets a single artist.

  Raises `Ecto.NoResultsError` if the Artist does not exist.
  """
  @spec get_artist!(String.t()) :: Artist.t()
  def get_artist!(id), do: Repo.get!(Artist, id)

  @doc """
  Creates a artist.
  """
  @spec create_artist(map) :: {:ok, Artist.t()} | {:error, Ecto.Changeset.t()}
  def create_artist(attrs \\ %{}) do
    %Artist{}
    |> Artist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a artist.
  """
  @spec update_artist(Artist.t(), map) :: {:ok, Artist.t()} | {:error, Ecto.Changeset.t()}
  def update_artist(%Artist{} = artist, attrs) do
    artist
    |> Artist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a artist.
  """
  @spec delete_artist(Artist.t()) :: {:ok, Artist.t()} | {:error, Ecto.Changeset.t()}
  def delete_artist(%Artist{} = artist) do
    Repo.delete(artist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking artist changes.
  """
  @spec change_artist(Artist.t(), map) :: Ecto.Changeset.t()
  def change_artist(%Artist{} = artist, attrs \\ %{}) do
    Artist.changeset(artist, attrs)
  end


  @doc """
  Returns the list of documents.
  """
  @spec list_documents() :: [Document.t()]
  def list_documents do
    Repo.all(Document)
  end

  @doc """
  Gets a single document.

  Raises `Ecto.NoResultsError` if the Document does not exist.
  """
  @spec get_document!(String.t()) :: Document.t()
  def get_document!(id), do: Repo.get!(Document, id)

  @doc """
  Creates a document.
  """
  @spec create_document(map) :: {:ok, Document.t()} | {:error, Ecto.Changeset.t()}
  def create_document(attrs \\ %{}) do
    %Document{}
    |> Document.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a document.
  """
  @spec update_document(Document.t(), map) :: {:ok, Document.t()} | {:error, Ecto.Changeset.t()}
  def update_document(%Document{} = document, attrs) do
    document
    |> Document.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a document.
  """
  @spec delete_document(Document.t()) :: {:ok, Document.t()} | {:error, Ecto.Changeset.t()}
  def delete_document(%Document{} = document) do
    Repo.delete(document)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking document changes.
  """
  @spec change_document(Document.t(), map) :: Ecto.Changeset.t()
  def change_document(%Document{} = document, attrs \\ %{}) do
    Document.changeset(document, attrs)
  end

  @doc """
  Returns the list of episodic_episodes.
  """
  @spec list_episodic_episodes() :: [Episode.t()]
  def list_episodic_episodes do
    Repo.all(Episode)
  end

  @doc """
  Gets a single episode.
  """
  @spec get_episode!(String.t()) :: Episode.t()
  def get_episode!(id), do: Repo.get!(Episode, id)

  @doc """
  Creates a episode.
  """
  @spec create_episode(map) :: {:ok, Episode.t()} | {:error, Ecto.Changeset.t()}
  def create_episode(attrs \\ %{}) do
    %Episode{}
    |> Episode.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a episode.
  """
  @spec update_episode(Episode.t(), map) :: {:ok, Episode.t()} | {:error, Ecto.Changeset.t()}
  def update_episode(%Episode{} = episode, attrs) do
    episode
    |> Episode.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a episode.
  """
  @spec delete_episode(Episode.t()) :: {:ok, Episode.t()} | {:error, Ecto.Changeset.t()}
  def delete_episode(%Episode{} = episode) do
    Repo.delete(episode)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking episode changes.
  """
  @spec change_episode(Episode.t(), map) :: {:ok, Ecto.Changeset.t()}
  def change_episode(%Episode{} = episode, attrs \\ %{}) do
    Episode.changeset(episode, attrs)
  end

  @doc """
  Returns the list of artist_albums.
  """
  @spec list_artist_albums() :: [Album.t()]
  def list_artist_albums do
    Repo.all(Album)
  end

  @doc """
  Gets a single album.

  Raises `Ecto.NoResultsError` if the Album does not exist.
  """
  @spec get_album!(String.t()) :: Album.t()
  def get_album!(id), do: Repo.get!(Album, id)

  @doc """
  Creates a album.
  """
  @spec create_album(map) :: {:ok, Album.t()} | {:error, Ecto.Changeset.t()}
  def create_album(attrs \\ %{}) do
    %Album{}
    |> Album.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a album.
  """
  @spec update_album(Album.t(), map) :: {:ok, Album.t()} | {:error, Ecto.Changeset.t()}
  def update_album(%Album{} = album, attrs) do
    album
    |> Album.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a album.
  """
  @spec delete_album(Album.t()) :: {:ok, Album.t()} | {:error, Ecto.Changeset.t()}
  def delete_album(%Album{} = album) do
    Repo.delete(album)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking album changes.
  """
  @spec change_album(Album.t(), map) :: Ecto.Changeset.t()
  def change_album(%Album{} = album, attrs \\ %{}) do
    Album.changeset(album, attrs)
  end

  @doc """
  Returns the list of artist_songs.
  """
  @spec list_artist_songs() :: [Song.t()]
  def list_artist_songs do
    Repo.all(Song)
  end

  @doc """
  Gets a single song.

  Raises `Ecto.NoResultsError` if the Song does not exist.
  """
  @spec get_song!(String.t()) :: Song.t()
  def get_song!(id), do: Repo.get!(Song, id)

  @doc """
  Creates a song.
  """
  @spec create_song(map) :: {:ok, Song.t()} | {:error, Ecto.Changeset.t()}
  def create_song(attrs \\ %{}) do
    %Song{}
    |> Song.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a song.
  """
  @spec update_song(Song.t(), map) :: {:ok, Song.t()} | {:error, Ecto.Changeset.t()}
  def update_song(%Song{} = song, attrs) do
    song
    |> Song.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a song.
  """
  @spec delete_song(Song.t()) :: {:ok, Song.t()} | {:error, Ecto.Changeset.t()}
  def delete_song(%Song{} = song) do
    Repo.delete(song)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking song changes.
  """
  @spec change_song(Song.t(), map) :: Ecto.Changeset.t()
  def change_song(%Song{} = song, attrs \\ %{}) do
    Song.changeset(song, attrs)
  end

  @doc """
  List all of the config options.
  """
  @spec list_config() :: [Config.t()]
  def list_config, do: Repo.all(Config)

  @doc """
  Retrieve a single Config based on the ID.
  """
  @spec get_config!(String.t()) :: Config.t()
  def get_config!(id), do: Repo.get!(Config, id)

  @doc """
  Retrieve a single Config based on the visible name.
  """
  @spec get_config_by_name!(String.t()) :: Config.t()
  def get_config_by_name!(name), do: Repo.get_by!(Config, name: name)

  @doc """
  Update a single Config entry.
  """
  @spec update_config(Config.t(), map) :: {:ok, Config.t()} | {:error, Ecto.Changeset.t()}
  def update_config(%Config{} = config, attrs) do
    config
    |> Config.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Generate the Changeset for a single Config.
  """
  @spec change_config(Config.t(), map) :: Ecto.Changeset.t()
  def change_config(%Config{} = config, attrs \\ %{}), do: Config.changeset(config, attrs)

  @doc """
  """
  @spec file_find_matching_episode(Episodic.t(), map(), String.t()) :: bool()
  def file_find_matching_episode(episodic, matches, file) do
    season = String.to_integer(matches["season"])
    episode = String.to_integer(matches["episode"])

    case file_matching_episode(episodic.episodes, season, episode) do
      {:ok, id} ->
        case Local.get_or_insert_file(%{"name" => file, "episodic" => episodic, "episode_id" => id, "path" => episodic.path, "last_checked_at" => DateTime.now!("Etc/UTC")}) do
          %Local.File{} = file ->
            episode = Episodical.Model.get_episode!(id)
              |> Repo.preload(:file)

            file
              |> Repo.preload([:episode, :episodic, :path])
              |> Local.update_file_assoc(%{
                  "episode" => episode,
                  "path" => episodic.path,
                  "episodic" => episodic,
                })
              |> Repo.update

            true
          {:error, changeset} ->
            Logger.info "Unable to create File! #{changeset}"
            false
        end

      false ->
        false
    end
  end

  @spec file_matching_episode(Episodic.t(), Integer.t(), Integer.t()) :: bool()
  defp file_matching_episode([], _, _), do: false
  defp file_matching_episode([episode | episodes], season, index) do
    if episode.season == season && episode.index == index do
      {:ok, episode.id}
    else
      file_matching_episode(episodes, season, index)
    end
  end
end
