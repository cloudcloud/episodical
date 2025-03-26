defmodule Episodical.Model.Episodic do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Episodical.Repo
  alias Episodical.External.Genre
  alias Episodical.Model.Episodic.Episode
  alias Episodical.Local.Path

  @type t :: %__MODULE__{
    id: binary,
    status: String.t(),
    title: String.t(),
    release_year: Integer.t(),
    last_checked_at: DateTime.t(),
    should_auto_check: Boolean.t(),
    external_id: String.t(),
    image: String.t(),
    overview: String.t(),
    original_language: String.t(),
    next_airing: DateTime.t(),
    imdb_id: String.t(),
    provider: Provider.t(),
    episodes: [Episode.t()],
    genres: [Genre.t()],
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @derive {
    Flop.Schema,
    filterable: [:title],
    sortable: [:title, :release_year, :last_checked_at]
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "episodics" do
    field :status, :string
    field :title, :string
    field :release_year, :integer
    field :last_checked_at, :utc_datetime_usec
    field :should_auto_check, :boolean, default: false

    field :external_id, :string, default: ""
    field :image, :string
    field :overview, :string
    field :original_language, :string
    field :next_airing, :utc_datetime
    field :imdb_id, :string

    belongs_to :provider, Episodical.External.Provider
    has_many :episodes, Episodical.Model.Episodic.Episode
    many_to_many :genres, Episodical.External.Genre,
      join_through: Episodical.External.EpisodicGenre,
      on_replace: :delete
    belongs_to :path, Episodical.Local.Path
    has_many :files, Episodical.Local.File

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(episodic, attrs) do
    episodic
    |> cast(attrs, [
      :title,
      :release_year,
      :status,
      :last_checked_at,
      :should_auto_check,
      :provider_id,
      :external_id,
      :image,
      :overview,
      :original_language,
      :next_airing,
      :imdb_id,
    ])
    |> validate_required([:title, :release_year, :should_auto_check])
  end

  def assoc_path(episodic, %Path{} = path) do
    episodic
    |> changeset(%{})
    |> put_assoc(:path, path)
  end

  def full_changeset(episodic, attrs) do
    episodic
    |> Repo.preload([:genres, :episodes])
    |> cast(attrs, [
      :release_year,
      :status,
      :last_checked_at,
      :external_id,
      :image,
      :overview,
      :original_language,
      :next_airing,
      :imdb_id,
    ])
    |> put_assoc(:genres, insert_and_get_all_genres(attrs[:genres]))
    |> put_assoc(:episodes, insert_and_get_all_episodes(attrs[:episodes]))
  end

  defp insert_and_get_all_genres([]), do: []
  defp insert_and_get_all_genres(genres) do
    genre_list = Enum.map(genres, fn g -> g[:external_id] end)

    timestamp = DateTime.now!("Etc/UTC")
    placeholders = %{timestamp: timestamp}

    maps = Enum.map(genres, fn g ->
      g
      |> Map.put_new(:inserted_at, {:placeholder, :timestamp})
      |> Map.put_new(:updated_at, {:placeholder, :timestamp})
    end)

    Repo.insert_all(
      Genre,
      maps,
      placeholders: placeholders,
      on_conflict: :nothing
    )

    Repo.all(from g in Genre, where: g.external_id in ^genre_list)
  end

  defp insert_and_get_all_episodes([]), do: []
  defp insert_and_get_all_episodes(episodes) do
    episode_list = Enum.map(episodes, fn e -> e[:external_id] end)

    timestamp = DateTime.now!("Etc/UTC")
    placeholders = %{timestamp: timestamp}

    maps = Enum.map(episodes, fn e ->
      e
      |> Map.put_new(:inserted_at, {:placeholder, :timestamp})
      |> Map.put_new(:updated_at, {:placeholder, :timestamp})
    end)

    Repo.insert_all(
      Episode,
      maps,
      placeholders: placeholders,
      on_conflict: :nothing
    )

    Repo.all(from t in Episode, where: t.external_id in ^episode_list)
  end
end
