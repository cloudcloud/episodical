defmodule Episodical.Encryption do
  @aad "AWS256GCM"

  @doc """
    Encrypt the provided value and provide the generated binary representation back.
  """
  @spec encrypt(any) :: String.t()
  def encrypt(plaintext) do
    iv = :crypto.strong_rand_bytes(16)

    {cipher, tag} =
      :crypto.crypto_one_time_aead(:aes_256_gcm, get_key(), iv, to_string(plaintext), @aad, true)

    iv <> tag <> <<get_key_id()::unsigned-big-integer-32>> <> cipher
  end

  @doc """
    Decrypt the provided binary data into the original string that was provided.
  """
  @spec decrypt(any) :: String.t()
  def decrypt(cipher) do
    <<iv::binary-16, tag::binary-16, key_id::unsigned-big-integer-32, cipher::binary>> = cipher
    :crypto.crypto_one_time_aead(:aes_256_gcm, get_key(key_id), iv, cipher, @aad, tag, false)
  end

  @spec get_key() :: String.t()
  defp get_key, do: get_key_id() |> get_key()

  @spec get_key(number) :: String.t()
  defp get_key(id), do: encryption_keys() |> Enum.at(id)

  @spec get_key_id() :: integer()
  defp get_key_id, do: Enum.count(encryption_keys()) - 1

  @spec encryption_keys() :: list(binary())
  defp encryption_keys do
    Application.get_env(:episodical, Episodical.Encryption)[:keys]
  end
end
