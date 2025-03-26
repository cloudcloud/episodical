defmodule Episodical.Model.Artist.Song do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: binary(),
    title: String.t(),
    length_seconds: Integer.t(),
    track_index: Integer.t(),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "artist_songs" do
    field :title, :string
    field :length_seconds, :integer
    field :track_index, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:title, :length_seconds, :track_index])
    |> validate_required([:title, :length_seconds, :track_index])
  end
end
