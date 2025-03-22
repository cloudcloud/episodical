defmodule Episodical.External do
  @moduledoc """
  The External context.
  """

  import Ecto.Query, warn: false
  alias Episodical.Repo

  alias Episodical.External.Genre
  alias Episodical.External.EpisodicGenre
  alias Episodical.External.Token
  alias Episodical.External.Provider

  @doc """
  Returns the list of genres.
  """
  @spec list_genres() :: [Genre.t()]
  def list_genres do
    Repo.all(Genre)
  end

  @doc """
  Gets a single genre.

  Raises `Ecto.NoResultsError` if the Genre does not exist.
  """
  @spec get_genre!(String.t()) :: Genre.t()
  def get_genre!(id), do: Repo.get!(Genre, id)

  @doc """
  Upsert a Genre, based on the external_id for it.
  """
  @spec get_or_insert_genre(map) :: Genre.t()
  def get_or_insert_genre(%{"name" => name, "external_id" => external_id, "provider_id" => provider_id}) do
    Repo.insert!(
      %Genre{genre: name, external_id: Integer.to_string(external_id), provider_id: provider_id},
      on_conflict: [set: [genre: name, external_id: Integer.to_string(external_id), provider_id: provider_id]],
      conflict_target: :external_id
    )
  end

  @spec associate_genre_episodic(map) :: {:ok, EpisodicGenre.t()} | {:error, Ecto.Changeset.t()}
  def associate_genre_episodic(attrs \\ %{}) do
    %EpisodicGenre{}
    |> EpisodicGenre.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a genre.
  """
  @spec create_genre(map) :: {:ok, Genre.t()} | {:error, Ecto.Changeset.t()}
  def create_genre(attrs \\ %{}) do
    %Genre{}
    |> Genre.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a genre.
  """
  @spec update_genre(Genre.t(), map) :: {:ok, Genre.t()} | {:error, Ecto.Changeset.t()}
  def update_genre(%Genre{} = genre, attrs) do
    genre
    |> Genre.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a genre.
  """
  @spec delete_genre(Genre.t()) :: {:ok, Genre.t()} | {:error, Ecto.Changeset.t()}
  def delete_genre(%Genre{} = genre) do
    Repo.delete(genre)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking genre changes.
  """
  @spec change_genre(Genre.t(), map) :: Ecto.Changeset.t()
  def change_genre(%Genre{} = genre, attrs \\ %{}) do
    Genre.changeset(genre, attrs)
  end

  @doc """
  Returns the list of tokens.
  """
  @spec list_tokens() :: [Token.t()]
  def list_tokens do
    Repo.all(Token)
  end

  @doc """
  Gets a single token.

  Raises `Ecto.NoResultsError` if the Token does not exist.
  """
  @spec get_token!(String.t()) :: Token.t()
  def get_token!(id), do: Repo.get!(Token, id)

  @doc """
  Creates a token.
  """
  @spec create_token(map) :: {:ok, Token.t()} | {:error, Ecto.Changeset.t()}
  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a token.
  """
  @spec update_token(Token.t(), map) :: {:ok, Token.t()} | {:error, Ecto.Changeset.t()}
  def update_token(%Token{} = token, attrs) do
    token
    |> Token.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a token.
  """
  @spec delete_token(Token.t()) :: {:ok, Token.t()} | {:error, Ecto.Changeset.t()}
  def delete_token(%Token{} = token) do
    Repo.delete(token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking token changes.
  """
  @spec change_token(Token.t(), map) :: Ecto.Changeset.t()
  def change_token(%Token{} = token, attrs \\ %{}) do
    Token.changeset(token, attrs)
  end

  @doc """
  Returns the list of providers.
  """
  @spec list_providers() :: [Provider.t()]
  def list_providers do
    Repo.all(Provider)
  end

  @doc """
  List available providers for the Episodical type.
  """
  @spec list_providers_by_type(atom) :: [Provider.t()]
  def list_providers_by_type(type) do
    Repo.all(Provider, [{:model_type, String.to_atom(type)}])
  end

  @doc """
  Gets a single provider.

  Raises `Ecto.NoResultsError` if the Provider does not exist.
  """
  @spec get_provider!(String.t()) :: Provider.t()
  def get_provider!(id), do: Repo.get!(Provider, id)

  @doc """
  Creates a provider.
  """
  @spec create_provider(map) :: {:ok, Provider.t()} | {:error, Ecto.Changeset.t()}
  def create_provider(attrs \\ %{}) do
    %Provider{}
    |> Provider.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a provider.
  """
  @spec update_provider(Provider.t(), map) :: {:ok, Provider.t()} | {:error, Ecto.Changeset.t()}
  def update_provider(%Provider{} = provider, attrs) do
    provider
    |> Provider.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a provider.
  """
  @spec delete_provider(Provider.t()) :: {:ok, Provider.t()} | {:error, Ecto.Changeset.t()}
  def delete_provider(%Provider{} = provider) do
    Repo.delete(provider)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking provider changes.
  """
  @spec change_provider(Provider.t(), map) :: Ecto.Changeset.t()
  def change_provider(%Provider{} = provider, attrs \\ %{}) do
    Provider.changeset(provider, attrs)
  end
end
