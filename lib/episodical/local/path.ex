defmodule Episodical.Local.Path do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "paths" do
    field :name, :string
    field :last_checked_at, :utc_datetime_usec
    field :should_auto_check, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(path, attrs) do
    path
    |> cast(attrs, [:name, :last_checked_at, :should_auto_check])
    |> validate_required([:name, :last_checked_at, :should_auto_check])
  end
end
