defmodule Episodical.Local.File do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: binary,
    name: String.t(),
    last_checked_at: DateTime.t(),
    path: Episodical.Local.Path.t(),
    episodic: Episodical.Model.Episodic.t(),
    episode: Episodical.Model.Episodic.Episode.t(),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

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
    |> put_assoc(:episodic, attrs["episodic"])
    |> put_assoc(:path, attrs["path"])
    |> put_assoc(:episode, attrs["episode"])
    |> validate_required([:name])
  end
end
