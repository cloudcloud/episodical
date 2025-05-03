defmodule EpisodicalWeb.EpisodicAssociateControllerTest do
  use EpisodicalWeb.ConnCase

  import Episodical.ExternalFixtures
  import Episodical.ModelFixtures

  describe "#show happy path" do
    setup do
      [status_code: 200]
    end

    setup [:setup_data]

    test "will display the selection of provider based results", %{
      conn: conn,
      provider: provider,
      episodic: episodic
    } do
      conn = get(conn, ~p"/episodics/#{episodic}/associate/#{provider}")
      response = html_response(conn, 200)

      assert response =~ episodic.title
    end
  end

  describe "#show unhappy path" do
    setup do
      [status_code: 401]
    end

    setup [:setup_data]

    test "will redirect upon receiving an error", %{
      conn: conn,
      provider: provider,
      episodic: episodic
    } do
      conn = get(conn, ~p"/episodics/#{episodic}/associate/#{provider}")
      assert redirected_to(conn) == ~p"/episodics/#{episodic}"
    end
  end

  describe "#create happy path" do
    setup [:setup_create]

    test "clicking a link will associate the provider result with the episodic and redirect", %{
      conn: conn,
      provider: provider,
      episodic: episodic
    } do
      conn =
        post(conn, ~p"/episodics/#{episodic}/associate", %{
          provider_id: provider.id,
          external_id: "tv666updated"
        })

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/episodics/#{id}"

      episodic = Episodical.Model.get_episodic!(episodic.id)
      assert episodic.external_id == "tv666updated"
    end
  end

  defp setup_create(_) do
    provider = provider_fixture()
    episodic = episodic_fixture()

    %{provider: provider, episodic: episodic}
  end

  defp setup_data(context) do
    token = token_fixture() |> Episodical.Repo.preload([:provider])
    episodic = episodic_fixture()

    query =
      %{"type" => "series", "query" => episodic.title, "year" => episodic.release_year}
      |> URI.encode_query()

    RequestStub.set_response(
      :get,
      "https://api4.thetvdb.com/v4/search?#{query}",
      {:ok,
       %{
         status_code: context[:status_code],
         body:
           %{
             status: "success",
             data: [
               %{
                 name: episodic.title,
                 first_air_time: "2025-05-03",
                 overview: episodic.overview,
                 tvdb_id: "tv123"
               }
             ]
           }
           |> Jason.encode!()
       }}
    )

    %{provider: token.provider, episodic: episodic}
  end
end
