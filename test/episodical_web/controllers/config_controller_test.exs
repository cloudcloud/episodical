defmodule EpisodicalWeb.ConfigControllerTest do
  use EpisodicalWeb.ConnCase

  import Episodical.ModelFixtures

  describe "index" do
    test "lists all available config entries", %{conn: conn} do
      conn = get(conn, ~p"/config")
      assert html_response(conn, 200) =~ "Configuration Options"
    end
  end

  describe "edit config item" do
    setup [:create_config]

    test "it displays the correct details", %{conn: conn, config: config} do
      conn = get(conn, ~p"/config/#{config}/edit")
      resp = html_response(conn, 200)

      assert resp =~ "Editing configuration"
      assert resp =~ config.value
    end
  end

  describe "updating config item" do
    setup [:create_config]

    @valid_attrs %{name: "episodic_path_layout", value: "updated-value", is_active: true}
    @invalid_attrs %{name: nil, value: nil}

    test "redirects when data is valid", %{conn: conn, config: config} do
      conn = put(conn, ~p"/config/#{config}", config: @valid_attrs)
      assert redirected_to(conn) == ~p"/config"

      conn = get(conn, ~p"/config/#{config}/edit")
      response = html_response(conn, 200)

      assert response =~ "Editing configuration"
      assert response =~ @valid_attrs.value
    end

    test "does not redirect if data is invalid", %{conn: conn, config: config} do
      conn = put(conn, ~p"/config/#{config}", config: @invalid_attrs)
      assert html_response(conn, 200) =~ "Editing configuration"
    end
  end

  defp create_config(_) do
    config =
      config_fixture(:episodic_path_layout, %{
        value: ":upper_word_title/:upper_word_season/:files"
      })

    config_fixture(:episodic_filename_pattern, %{value: ":dotted_title\.S(\d+)E(\d+).([a-z]+)"})

    %{config: config}
  end
end
