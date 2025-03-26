defmodule Episodical.Audit.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: binary(),
    debug: String.t(),
    action_taken: String.t(),
    entity_id: binary(),
    entity_type: String.t(),
    was_manual: bool(),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :debug, :string
    field :action_taken, :string
    field :entity_id, :binary
    field :entity_type, :string
    field :was_manual, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:action_taken, :entity_id, :entity_type, :was_manual, :debug])
    |> validate_required([:action_taken, :entity_id, :entity_type, :was_manual, :debug])
  end
end
