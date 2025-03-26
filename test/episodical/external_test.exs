defmodule Episodical.ExternalTest do
  use Episodical.DataCase

  alias Episodical.External

  describe "genres" do
    alias Episodical.External.Genre

    import Episodical.ExternalFixtures

    @invalid_attrs %{genre: nil, external_id: nil}

    test "list_genres/0 returns all genres" do
      genre = genre_fixture()
      assert External.list_genres() == [genre]
    end

    test "get_genre!/1 returns the genre with given id" do
      genre = genre_fixture()
      assert External.get_genre!(genre.id) == genre
    end

    test "create_genre/1 with valid data creates a genre" do
      valid_attrs = %{genre: "some genre", external_id: "some external_id"}

      assert {:ok, %Genre{} = genre} = External.create_genre(valid_attrs)
      assert genre.genre == "some genre"
      assert genre.external_id == "some external_id"
    end

    test "create_genre/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = External.create_genre(@invalid_attrs)
    end

    test "update_genre/2 with valid data updates the genre" do
      genre = genre_fixture()
      update_attrs = %{genre: "some updated genre", external_id: "some updated external_id"}

      assert {:ok, %Genre{} = genre} = External.update_genre(genre, update_attrs)
      assert genre.genre == "some updated genre"
      assert genre.external_id == "some updated external_id"
    end

    test "update_genre/2 with invalid data returns error changeset" do
      genre = genre_fixture()
      assert {:error, %Ecto.Changeset{}} = External.update_genre(genre, @invalid_attrs)
      assert genre == External.get_genre!(genre.id)
    end

    test "delete_genre/1 deletes the genre" do
      genre = genre_fixture()
      assert {:ok, %Genre{}} = External.delete_genre(genre)
      assert_raise Ecto.NoResultsError, fn -> External.get_genre!(genre.id) end
    end

    test "change_genre/1 returns a genre changeset" do
      genre = genre_fixture()
      assert %Ecto.Changeset{} = External.change_genre(genre)
    end
  end

  describe "tokens" do
    alias Episodical.External.Token

    import Episodical.ExternalFixtures

    @invalid_attrs %{value: nil, is_valid: nil, expires_at: nil}

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert External.list_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert External.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      provider = provider_fixture()
      valid_attrs = %{
        value: "some value",
        is_valid: true,
        expires_at: ~U[2025-02-07 22:58:00.000000Z],
        provider_id: provider.id
      }

      assert {:ok, %Token{} = token} = External.create_token(valid_attrs)
      assert token.value == "some value"
      assert token.is_valid == true
      assert token.expires_at == ~U[2025-02-07 22:58:00.000000Z]
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = External.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()

      update_attrs = %{
        value: "some updated value",
        is_valid: false,
        expires_at: ~U[2025-02-08 22:58:00.000000Z]
      }

      assert {:ok, %Token{} = token} = External.update_token(token, update_attrs)
      assert token.value == "some updated value"
      assert token.is_valid == false
      assert token.expires_at == ~U[2025-02-08 22:58:00.000000Z]
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = External.update_token(token, @invalid_attrs)
      assert token == External.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = External.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> External.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = External.change_token(token)
    end
  end

  describe "providers" do
    alias Episodical.External.Provider

    import Episodical.ExternalFixtures

    @invalid_attrs %{name: nil, external_id: nil, base_url: nil, model_type: nil}

    test "list_providers/0 returns all providers" do
      provider = provider_fixture()
      assert External.list_providers() == [provider]
    end

    test "get_provider!/1 returns the provider with given id" do
      provider = provider_fixture()
      assert External.get_provider!(provider.id) == provider
    end

    test "create_provider/1 with valid data creates a provider" do
      valid_attrs = %{
        name: "some name",
        external_id: "some external_id",
        base_url: "some base_url",
        model_type: :episodic,
        access_key: "some-access-key",
        service_type: "thetvdb"
      }

      assert {:ok, %Provider{} = provider} = External.create_provider(valid_attrs)
      assert provider.name == "some name"
      assert provider.access_key == "some-access-key"
      assert provider.base_url == "some base_url"
      assert provider.model_type == :episodic
    end

    test "create_provider/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = External.create_provider(@invalid_attrs)
    end

    test "update_provider/2 with valid data updates the provider" do
      provider = provider_fixture()

      update_attrs = %{
        name: "some updated name",
        access_key: "some updated access_key",
        base_url: "some updated base_url",
        model_type: :artist
      }

      assert {:ok, %Provider{} = provider} = External.update_provider(provider, update_attrs)
      assert provider.name == "some updated name"
      assert provider.access_key == "some updated access_key"
      assert provider.base_url == "some updated base_url"
      assert provider.model_type == :artist
    end

    test "update_provider/2 with invalid data returns error changeset" do
      provider = provider_fixture()
      assert {:error, %Ecto.Changeset{}} = External.update_provider(provider, @invalid_attrs)
      assert provider == External.get_provider!(provider.id)
    end

    test "delete_provider/1 deletes the provider" do
      provider = provider_fixture()
      assert {:ok, %Provider{}} = External.delete_provider(provider)
      assert_raise Ecto.NoResultsError, fn -> External.get_provider!(provider.id) end
    end

    test "change_provider/1 returns a provider changeset" do
      provider = provider_fixture()
      assert %Ecto.Changeset{} = External.change_provider(provider)
    end
  end
end
