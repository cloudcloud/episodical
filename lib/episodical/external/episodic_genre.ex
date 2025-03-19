defmodule Episodical.External.EpisodicGenre do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "episodics_genres" do
    belongs_to :episodic, Episodical.Model.Episodic, type: :binary_id
    belongs_to :genre, Episodical.External.Genre, type: :binary_id

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(episodic_genre, attrs) do
    episodic_genre
    |> cast(attrs, [:episodic_id, :genre_id])
    |> validate_required([:episodic_id, :genre_id])
  end
end
