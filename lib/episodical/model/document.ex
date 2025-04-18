defmodule Episodical.Model.Document do
  use Ecto.Schema
  import Ecto.Changeset

  alias Episodical.External.Provider

  @type t :: %__MODULE__{
    id: binary,
    title: String.t(),
    author: String.t(),
    released_at: DateTime.t(),
    is_read: bool(),
    read_at: DateTime.t(),
    last_checked_at: DateTime.t(),
    should_auto_check: bool(),
    external_id: String.t(),
    provider: Provider.t(),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "documents" do
    field :title, :string
    field :author, :string
    field :released_at, :utc_datetime
    field :is_read, :boolean, default: false
    field :read_at, :utc_datetime_usec
    field :last_checked_at, :utc_datetime_usec
    field :should_auto_check, :boolean, default: false
    field :external_id, :string
    belongs_to :provider, Provider

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [
      :title,
      :author,
      :released_at,
      :is_read,
      :read_at,
      :last_checked_at,
      :should_auto_check,
      :external_id
    ])
    |> validate_required([
      :title,
      :author,
      :released_at,
      :is_read,
      :read_at,
      :last_checked_at,
      :should_auto_check
    ])
  end
end
