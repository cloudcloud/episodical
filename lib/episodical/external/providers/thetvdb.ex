defmodule Episodical.External.Provider.TheTVDB do
  require Logger

  alias Episodical.External.Provider
  alias Episodical.External.Token

  @base_url "https://api4.thetvdb.com/v4/"
  @headers [{"User-agent", "cloudcloud/episodical v#{Episodical.Application.version()}"}, {"Accept", "application/json"}]

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
    provider
    |> api_call("#{@base_url}search?type=series&query=#{title}&year=#{year}")

    # data []
    #   image_url
    #   tvdb_id
    #   primary_language
    #   first_air_time
    #   status
    #   year
    #   overviews {}
    #     "eng"
    #   translations {}
    #     "eng"
    #   network
    #   remote_ids []
    #     id
    #     sourceName
  end

  @doc """
  Fetch the full detail for a specific series identifier.
  """
  @spec get_series(Provider.t(), integer()) :: map()
  def get_series(%Provider{model_type: :episodic} = provider, id) do
    provider
    |> api_call("#{@base_url}series/#{id}/extended?meta=episodes&short=true")

    # data
    #   id
    #   name
    #   image
    #   firstAired
    #   status
    #     name
    #   episodes []
    #     id
    #     name
    #     aired
    #     overview
    #     seasonNumber
    #     number
    #   overview
    #   year
    #   genres []
    #     id
    #     name
    #   remoteIds []
    #     id
    #     sourceName (IMDB)
    #
  end

  @doc """
  Retrieve the language specific details for the get_series function.
  There are subtle differences in the response here, likely both are needed.
  """
  @spec get_series_specific_language(Provider.t(), integer(), String.t(), integer()) :: map()
  def get_series_specific_language(%Provider{model_type: :episodic} = provider, id, lang, page \\ 0) do
    provider
    |> api_call("#{@base_url}series/#{id}/episodes/official/#{lang}?page=#{page}")

    # data
    #   id
    #   name
    #   image
    #   firstAired
    #   status
    #     name
    #   episodes []
    #     id
    #     name
    #     aired
    #     overview
    #     seasonNumber
    #     number
    #   overview (not translated)
    #   year
  end

  defp api_call(provider, url) do
    provider = Episodical.Repo.preload(provider, [:token])
    value = with true <- Ecto.assoc_loaded?(provider.token),
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
    Logger.debug("Fetching ourselves a token!")
    response =
      "#{@base_url}login"
      |> HTTPoison.post(Jason.encode!(%{"apikey" => key}), [{"Content-type", "application/json"} | @headers])

    with {:ok, %{status_code: 200, body: body}} <- response,
         %{"data" => %{"token" => token}, "status" => "success"} <- Jason.decode!(body),
         {:ok, %Token{}} <- Episodical.External.create_token(%{
           value: token,
           expires_at: DateTime.shift(DateTime.now!("Etc/UTC"), month: 1),
           is_valid: true,
           provider_id: provider.id
         }) do

      Logger.debug("Got through to the token piece!")
      true
    else
      _ -> false
    end
  end

  defp make_request(url, key) do
    url
    |> HTTPoison.get([{"Authorization", "Bearer #{key}"} | @headers])
    |> handle_response
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info("Successful response!")
    Logger.debug(fn -> inspect(body) end)

    {:ok, Jason.decode!(body)}
  end
end
