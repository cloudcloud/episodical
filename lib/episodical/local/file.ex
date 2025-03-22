defmodule Episodical.Local.File do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "files" do
    field :name, :string
    field :last_checked_at, :utc_datetime_usec

    belongs_to :path, Episodical.Local.Path
    belongs_to :episodic, Episodical.Model.Episodic
    belongs_to :episode, Episodical.Model.Episodic.Episode

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:name, :last_checked_at])
    |> validate_required([:name, :last_checked_at])
  end
end
