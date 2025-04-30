defmodule Episodical.External.Provider.TheTVDB do
  require Logger

  alias Episodical.External.Provider
  alias Episodical.External.Token

  @base_url "https://api4.thetvdb.com/v4/"
  @headers [
    {"User-agent", "cloudcloud/episodical v#{Episodical.Application.version()}"},
    {"Accept", "application/json"}
  ]
  @service_type "thetvdb"
  @request_module Application.compile_env(:episodical, :http_adapter, Request)

  def service_type?, do: @service_type

  @doc """
  For a given model type, is this provider valid for it?
  """
  @spec valid_for?(String.t()) :: boolean()
  def valid_for?("episodic"), do: true
  def valid_for?(_), do: false

  @doc """
  Make an API call to retrieve potential matches for a given show.
  """
  @spec search_by_show_title(Provider.t(), String.t(), integer()) :: list()
  def search_by_show_title(
        %Provider{model_type: :episodic} = provider,
        title,
        year
      ) do
    query =
      %{"type" => "series", "query" => title, "year" => year}
      |> URI.encode_query()

    case api_call(provider, "#{@base_url}search?#{query}") do
      {:ok, %{"status" => "success", "data" => data}} ->
        {:ok, data}

      _ ->
        :error
    end
  end

  @doc """
  Fetch the full detail for a specific series identifier.
  """
  @spec get_series(Provider.t(), integer()) :: {:atom, map()}
  def get_series(%Provider{model_type: :episodic} = provider, id) do
    provider
    |> api_call("#{@base_url}series/#{id}/extended?meta=episodes&short=true")
  end

  @doc """
  Retrieve the language specific details for the get_series function.
  There are subtle differences in the response here, likely both are needed.
  """
  @spec get_series_specific_language(Provider.t(), integer(), String.t(), integer()) :: map()
  def get_series_specific_language(
        %Provider{model_type: :episodic} = provider,
        id,
        lang,
        page \\ 0
      ) do
    provider
    |> api_call("#{@base_url}series/#{id}/episodes/official/#{lang}?page=#{page}")
  end

  defp api_call(provider, url) do
    provider = Episodical.Repo.preload(provider, [:token])

    value =
      with true <- Ecto.assoc_loaded?(provider.token),
           true <- length(provider.token) > 0,
           true <- List.first(provider.token).is_valid do
        true
      else
        _ -> retrieve_token(provider)
      end

    if value == true do
      make_request(url, List.first(provider.token).value)
    else
      {:error, "Unable to make request"}
    end
  end

  defp retrieve_token(%Provider{access_key: key} = provider) do
    response =
      "#{@base_url}login"
      |> @request_module.post(%{"apikey" => key}, [
        {"Content-type", "application/json"} | @headers
      ])

    with {:ok, %{status_code: 200, body: body}} <- response,
         %{"data" => %{"token" => token}, "status" => "success"} <- Jason.decode!(body),
         {:ok, %Token{}} <-
           Episodical.External.create_token(%{
             value: token,
             expires_at: DateTime.shift(DateTime.now!("Etc/UTC"), month: 1),
             is_valid: true,
             provider_id: provider.id
           }) do
      true
    else
      _ -> false
    end
  end

  defp make_request(url, key) do
    url
    |> @request_module.get(%{}, [{"Authorization", "Bearer #{key}"} | @headers])
    |> handle_response
  end

  defp handle_response({:ok, %{status_code: 401, body: _}}) do
    # token has expired, refresh it
    {:error}
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info("Successful response!")

    {:ok, Jason.decode!(body)}
  end
end
