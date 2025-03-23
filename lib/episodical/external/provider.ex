defmodule Episodical.External.Provider do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: binary,
    name: String.t(),
    base_url: String.t(),
    model_type: String.t(),
    access_key: String.t(),
    token: list(),
    service_type: String.t(),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  alias Episodical.External.Token
  alias Episodical.Encryption.EncryptedField

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "providers" do
    field :name, :string
    field :base_url, :string
    field :model_type, Ecto.Enum, values: [:episodic, :artist, :document]
    field :access_key, EncryptedField
    field :service_type, :string
    has_many :token, Token

    timestamps(type: :utc_datetime_usec)
  end

  @doc """
    Processes the provided attributes against the existing provider.
  """
  def changeset(provider, attrs) do
    provider
    |> cast(attrs, [:name, :base_url, :model_type, :access_key, :service_type])
    |> validate_required([:name, :base_url, :model_type, :access_key, :service_type])
  end
end
