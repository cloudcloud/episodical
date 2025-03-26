defmodule Episodical.External.Genre do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: binary(),
    genre: String.t(),
    external_id: String.t(),
    provider: Episodical.External.Provider.t(),
    episodics: list(Episodical.Model.Episodic.t()),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "genres" do
    field :genre, :string
    field :external_id, :string

    belongs_to :provider, Episodical.External.Provider
    many_to_many :episodics, Episodical.Model.Episodic, join_through: Episodical.External.EpisodicGenre

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:genre, :external_id, :provider_id])
    |> validate_required([:genre, :external_id])
  end
end
