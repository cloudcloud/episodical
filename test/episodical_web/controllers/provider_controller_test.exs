defmodule EpisodicalWeb.ProviderControllerTest do
  use EpisodicalWeb.ConnCase

  import Episodical.ExternalFixtures

  @create_attrs %{
    name: "my-provider",
    base_url: "https://localhost",
    model_type: "episodic",
    access_key: "secret",
    service_type: "thetvdb"
  }
  @update_attrs %{
    name: "actual-name",
    base_url: "https://locahost.alternate",
    model_type: "episodic",
    access_key: "fresh-key",
    service_type: "thetvdb"
  }
  @invalid_attrs %{name: nil, base_url: nil, model_type: nil, access_key: nil, service_type: nil}

  describe "index" do
    test "displays all providers", %{conn: conn} do
      conn = get(conn, ~p"/providers")
      assert html_response(conn, 200) =~ "Listing Providers"
    end
  end

  describe "new provider" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/providers/new")
      assert html_response(conn, 200) =~ "New Provider"
    end
  end

  describe "create provider" do
    test "redirects to provider when created successfully", %{conn: conn} do
      conn = post(conn, ~p"/providers", provider: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/providers/#{id}"

      conn = get(conn, ~p"/providers/#{id}")
      assert html_response(conn, 200) =~ "Provider <b>my-provider</b>"
    end

    test "renders errors when the submission is invalid", %{conn: conn} do
      conn = post(conn, ~p"/providers", provider: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Provider"
    end
  end

  describe "edit provider" do
    setup [:create_provider]

    test "renders form for editing provider details", %{conn: conn, provider: provider} do
      conn = get(conn, ~p"/providers/#{provider}/edit")
      assert html_response(conn, 200) =~ "Edit Provider #{provider.id}"
    end
  end

  describe "update provider" do
    setup [:create_provider]

    test "redirects when data is valid", %{conn: conn, provider: provider} do
      conn = put(conn, ~p"/providers/#{provider}", provider: @update_attrs)
      assert redirected_to(conn) == ~p"/providers/#{provider}"

      conn = get(conn, ~p"/providers/#{provider}")
      response = html_response(conn, 200)

      assert response =~ @update_attrs[:name]
      assert response =~ "Provider updated successfully"
    end

    test "renders errors when data is invalid", %{conn: conn, provider: provider} do
      conn = put(conn, ~p"/providers/#{provider}", provider: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Provider #{provider.id}"
    end
  end

  describe "delete provider" do
    setup [:create_provider]

    test "deletes chosen provider", %{conn: conn, provider: provider} do
      conn = delete(conn, ~p"/providers/#{provider}")
      assert redirected_to(conn) == ~p"/providers"

      assert_error_sent 404, fn ->
        get(conn, ~p"/providers/#{provider}")
      end
    end
  end

  defp create_provider(_) do
    provider = provider_fixture()
    %{provider: provider}
  end
end
