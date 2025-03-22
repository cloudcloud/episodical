defmodule Episodical.Model.Episodic.Episode do
  use Ecto.Schema
  import Ecto.Changeset

  alias Episodical.Model.Episodic

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "episodic_episodes" do
    field :index, :integer
    field :title, :string
    field :season, :integer
    field :released_at, :utc_datetime
    field :is_watched, :boolean, default: false
    field :watched_at, :utc_datetime_usec
    field :overview, :string
    field :external_id, :string

    belongs_to :provider, Episodical.External.Provider
    belongs_to :episodic, Episodic
    has_one :episode, Episodic.Episode

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(episode, attrs) do
    episode
    |> cast(attrs, [:index, :title, :season, :released_at, :is_watched, :watched_at, :overview])
    |> validate_required([
      :index,
      :title,
      :season,
      :released_at,
      :is_watched,
      :watched_at,
      :overview
    ])
  end
end
