defmodule Episodical.Model.Config do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "config" do
    field :name, :string
    field :value, :string
    field :is_active, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [:name, :value, :is_active])
    |> validate_required([:name, :value])
  end
end
