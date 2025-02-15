defmodule Episodical.ExternalFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Episodical.External` context.
  """

  @doc """
  Generate a genre.
  """
  def genre_fixture(attrs \\ %{}) do
    {:ok, genre} =
      attrs
      |> Enum.into(%{
        external_id: "some external_id",
        genre: "some genre"
      })
      |> Episodical.External.create_genre()

    genre
  end

  @doc """
  Generate a token.
  """
  def token_fixture(attrs \\ %{}) do
    {:ok, token} =
      attrs
      |> Enum.into(%{
        expires_at: ~U[2025-02-07 22:58:00.000000Z],
        is_valid: true,
        value: "some value"
      })
      |> Episodical.External.create_token()

    token
  end

  @doc """
  Generate a provider.
  """
  def provider_fixture(attrs \\ %{}) do
    {:ok, provider} =
      attrs
      |> Enum.into(%{
        base_url: "some base_url",
        external_id: "some external_id",
        model_type: :episodic,
        name: "some name",
        access_key: "access-key"
      })
      |> Episodical.External.create_provider()

    provider
  end
end
