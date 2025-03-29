defmodule EpisodicalWeb.PathsControllerTest do
  use EpisodicalWeb.ConnCase

  import Episodical.LocalFixtures

  @create_attrs %{name: "/some/path", should_auto_check: false}
  @update_attrs %{name: "/updated/path/now", should_auto_check: true}
  @invalid_attrs %{name: nil, should_auto_check: nil}

  describe "index" do
    test "displays all paths", %{conn: conn} do
      conn = get(conn, ~p"/paths")
      assert html_response(conn, 200) =~ "Listing Paths"
    end
  end

  describe "new path" do
    test "renders the form to create", %{conn: conn} do
      conn = get(conn, ~p"/paths/new")
      assert html_response(conn, 200) =~ "add a new path"
    end
  end

  describe "create path" do
    test "redirects to path when created successfully", %{conn: conn} do
      conn = post(conn, ~p"/paths", path: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/paths/#{id}"

      conn = get(conn, ~p"/paths/#{id}")
      assert html_response(conn, 200) =~ "Path <b>/some/path</b>"
    end

    test "renders errors when the change is unsuccessful", %{conn: conn} do
      conn = post(conn, ~p"/paths", path: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Path"
    end
  end

  describe "edit path" do
    setup [:create_path]

    test "renders form for editing the path", %{conn: conn, path: path} do
      conn = get(conn, ~p"/paths/#{path}/edit")
      assert html_response(conn, 200) =~ "Edit Path #{path.id}"
    end
  end

  describe "update path" do
    setup [:create_path]

    test "redirects when data is valid", %{conn: conn, path: path} do
      conn = put(conn, ~p"/paths/#{path}", path: @update_attrs)
      assert redirected_to(conn) == ~p"/paths/#{path}"

      conn = get(conn, ~p"/paths/#{path}")
      response = html_response(conn, 200)

      assert response =~ @update_attrs[:name]
      assert response =~ "Path updated successfully"
    end

    test "renders errors when data is invalid", %{conn: conn, path: path} do
      conn = put(conn, ~p"/paths/#{path}", path: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Path #{path.id}"
    end
  end

  describe "delete path" do
    setup [:create_path]

    test "deletes the correct path", %{conn: conn, path: path} do
      conn = delete(conn, ~p"/paths/#{path}")
      assert redirected_to(conn) == ~p"/paths"

      assert_error_sent 404, fn ->
        get(conn, ~p"/paths/#{path}")
      end
    end
  end

  defp create_path(_) do
    path = path_fixture()
    %{path: path}
  end
end
