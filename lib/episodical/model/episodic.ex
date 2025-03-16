defmodule Episodical.Model.Episodic do
  use Ecto.Schema
  import Ecto.Changeset

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
    has_many :episodic_episode, Episodical.Model.Episodic.Episode

    timestamps(type: :utc_datetime)
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
end
