defmodule Request do
  @headers ["Content-Type": "application/json"]

  def get(url, params \\ %{}, options \\ []) do
    query =
      if params == %{} do
        ""
      else
        "?" <> URI.encode_query(params)
      end

    HTTPoison.get(url <> query, options)
  end

  def post(url, body, options \\ @headers) do
    HTTPoison.post(url, Jason.encode!(body), options)
  end
end
