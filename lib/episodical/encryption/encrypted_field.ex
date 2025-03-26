defmodule Episodical.Encryption.EncryptedField do
  alias Episodical.Encryption

  @behaviour Ecto.Type

  @doc """
  We always expect the value to be a string, so we cast it to one.
  """
  @spec cast(any) :: {:ok, String.t()}
  def cast(value), do: {:ok, to_string(value)}

  @doc """
  We preserve the higher level representation as we don't need to specify anything here.
  """
  @spec embed_as(any) :: :self
  def embed_as(_), do: :self

  @doc """
  Called to check if 2 specific values are the same.
  """
  @spec equal?(any, any) :: boolean()
  def equal?(a, b), do: a == b

  @doc """
  Called when the value is being retrieved from the database, so we decrypt.
  """
  @spec load(binary()) :: {:ok, String.t()}
  def load(value), do: {:ok, Encryption.decrypt(value)}

  @doc """
  The type of storage the value we'll be generating should be placed into.
  """
  @spec type() :: :binary
  def type, do: :binary

  @doc """
  Called during write methods to the database, so we encrypt the value.
  """
  @spec dump(String.t()) :: {:ok, binary()}
  def dump(value) do
    cipher = value |> to_string |> Encryption.encrypt()
    {:ok, cipher}
  end
end
