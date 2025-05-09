defmodule Episodical.Model.Artist.Album do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: binary(),
    title: String.t(),
    released_at: DateTime.t(),
    song_count: Integer.t(),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "artist_albums" do
    field :title, :string
    field :released_at, :utc_datetime
    field :song_count, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:title, :released_at, :song_count])
    |> validate_required([:title, :released_at, :song_count])
  end
end
