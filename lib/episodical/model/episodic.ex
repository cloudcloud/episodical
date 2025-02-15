defmodule Episodical.Model.Episodic do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "episodics" do
    field :status, :string
    field :title, :string
    field :release_year, :integer
    field :last_checked_at, :utc_datetime_usec
    field :should_auto_check, :boolean, default: false

    field :external_id, :string, default: ""

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
      :external_id
    ])
    |> validate_required([:title, :release_year, :status, :last_checked_at, :should_auto_check])
  end
end
