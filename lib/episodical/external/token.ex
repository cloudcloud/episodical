defmodule Episodical.External.Token do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: binary(),
    value: String.t(),
    is_valid: bool(),
    expires_at: DateTime.t(),
    provider: Provider.t(),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  alias Episodical.External.Provider
  alias Episodical.Encryption.EncryptedField

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tokens" do
    field :value, EncryptedField
    field :is_valid, :boolean, default: false
    field :expires_at, :utc_datetime_usec
    belongs_to :provider, Provider

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:value, :is_valid, :expires_at, :provider_id])
    |> validate_required([:value, :is_valid, :expires_at, :provider_id])
  end
end
