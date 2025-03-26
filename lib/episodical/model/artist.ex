defmodule Episodical.Model.Artist do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: binary(),
    name: String.t(),
    formed_year: Integer.t(),
    base_location: String.t(),
    last_checked_at: DateTime.t(),
    should_auto_check: bool(),
    external_id: String.t(),
    provider: Episodical.External.Provider.t(),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "artists" do
    field :name, :string
    field :formed_year, :integer
    field :base_location, :string
    field :last_checked_at, :utc_datetime_usec
    field :should_auto_check, :boolean, default: false
    field :external_id, :string, default: ""

    belongs_to :provider, Episodical.External.Provider

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [
      :name,
      :formed_year,
      :base_location,
      :last_checked_at,
      :should_auto_check,
      :external_id
    ])
    |> validate_required([
      :name,
      :formed_year,
      :base_location,
      :last_checked_at,
      :should_auto_check
    ])
  end
end
