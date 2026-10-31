defmodule Episodical.External.Provider.TheTVDBTest do
  use Episodical.DataCase

  alias Episodical.External.Provider.TheTVDB
  alias Episodical.External.Token

  import Episodical.ExternalFixtures

  describe "search_by_show_title/3" do
    test "fetches a token on first use and searches with it" do
      provider = provider_fixture()
      query = URI.encode_query(%{"type" => "series", "query" => "Survivor", "year" => 2000})

      RequestStub.set_response(
        :post,
        "https://api4.thetvdb.com/v4/login",
        {:ok,
         %{
           status_code: 200,
           body: Jason.encode!(%{"status" => "success", "data" => %{"token" => "fresh-token"}})
         }}
      )

      RequestStub.set_response(
        :get,
        "https://api4.thetvdb.com/v4/search?#{query}",
        {:ok,
         %{
           status_code: 200,
           body:
             Jason.encode!(%{
               "status" => "success",
               "data" => [%{"name" => "Survivor", "tvdb_id" => 76733}]
             })
         }}
      )

      assert {:ok, [%{"name" => "Survivor", "tvdb_id" => 76733}]} =
               TheTVDB.search_by_show_title(provider, "Survivor", 2000)

      assert [%Token{value: "fresh-token"}] = Repo.preload(provider, :token).token
    end

    test "reuses an existing valid token" do
      token = token_fixture()
      provider = Repo.get!(Episodical.External.Provider, token.provider_id)
      query = URI.encode_query(%{"type" => "series", "query" => "Survivor", "year" => 2000})

      RequestStub.set_response(
        :get,
        "https://api4.thetvdb.com/v4/search?#{query}",
        {:ok, %{status_code: 200, body: Jason.encode!(%{"status" => "success", "data" => []})}}
      )

      assert {:ok, []} = TheTVDB.search_by_show_title(provider, "Survivor", 2000)
      assert Repo.aggregate(Token, :count) == 1
    end

    test "returns an error instead of crashing when the token cannot be fetched" do
      provider = provider_fixture()

      RequestStub.set_response(
        :post,
        "https://api4.thetvdb.com/v4/login",
        {:ok, %{status_code: 401, body: "{}"}}
      )

      assert :error = TheTVDB.search_by_show_title(provider, "Survivor", 2000)
    end
  end
end
