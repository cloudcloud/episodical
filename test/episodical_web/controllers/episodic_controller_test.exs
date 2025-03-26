defmodule EpisodicalWeb.EpisodicControllerTest do
  use EpisodicalWeb.ConnCase

  import Episodical.ModelFixtures

  @create_attrs %{status: "some status", title: "some title", release_year: 42, last_checked_at: ~U[2025-02-07 22:58:00.000000Z], should_auto_check: true}
  @update_attrs %{status: "some updated status", title: "some updated title", release_year: 43, last_checked_at: ~U[2025-02-08 22:58:00.000000Z], should_auto_check: false}
  @invalid_attrs %{status: nil, title: nil, release_year: nil, last_checked_at: nil, should_auto_check: nil}

  describe "index" do
    test "lists all episodics", %{conn: conn} do
      conn = get(conn, ~p"/episodics")
      assert html_response(conn, 200) =~ "Listing Episodics"
    end
  end

  describe "new episodic" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/episodics/new")
      assert html_response(conn, 200) =~ "New Episodic"
    end
  end

  describe "create episodic" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/episodics", episodic: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/episodics/#{id}"

      conn = get(conn, ~p"/episodics/#{id}")
      assert html_response(conn, 200) =~ "Episodic <b>some title</b>"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/episodics", episodic: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Episodic"
    end
  end

  describe "edit episodic" do
    setup [:create_episodic]

    test "renders form for editing chosen episodic", %{conn: conn, episodic: episodic} do
      conn = get(conn, ~p"/episodics/#{episodic}/edit")
      assert html_response(conn, 200) =~ "Editing \"some title\""
    end
  end

  describe "update episodic" do
    setup [:create_episodic]

    test "redirects when data is valid", %{conn: conn, episodic: episodic} do
      conn = put(conn, ~p"/episodics/#{episodic}", episodic: @update_attrs)
      assert redirected_to(conn) == ~p"/episodics/#{episodic}"

      conn = get(conn, ~p"/episodics/#{episodic}")
      assert html_response(conn, 200) =~ "some updated status"
    end

    test "renders errors when data is invalid", %{conn: conn, episodic: episodic} do
      conn = put(conn, ~p"/episodics/#{episodic}", episodic: @invalid_attrs)
      assert html_response(conn, 200) =~ "Editing \"some title\""
    end
  end

  describe "delete episodic" do
    setup [:create_episodic]

    test "deletes chosen episodic", %{conn: conn, episodic: episodic} do
      conn = delete(conn, ~p"/episodics/#{episodic}")
      assert redirected_to(conn) == ~p"/episodics"

      assert_error_sent 404, fn ->
        get(conn, ~p"/episodics/#{episodic}")
      end
    end
  end

  defp create_episodic(_) do
    episodic = episodic_fixture()
    %{episodic: episodic}
  end
end
