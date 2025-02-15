defmodule Episodical.External.Token do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(attrs, [:value, :is_valid, :expires_at])
    |> validate_required([:value, :is_valid, :expires_at])
  end
end
