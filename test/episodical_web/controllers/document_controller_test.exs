defmodule EpisodicalWeb.DocumentControllerTest do
  use EpisodicalWeb.ConnCase

  import Episodical.ModelFixtures

  @create_attrs %{
    title: "some title",
    author: "some author",
    released_at: ~U[2025-02-07 22:58:00Z],
    is_read: true,
    last_checked_at: ~U[2025-02-07 22:58:00.000000Z],
    should_auto_check: true,
    read_at: ~U[2025-02-07 22:58:00.000000Z]
  }
  @update_attrs %{
    title: "some updated title",
    author: "some updated author",
    released_at: ~U[2025-02-08 22:58:00Z],
    is_read: false,
    last_checked_at: ~U[2025-02-08 22:58:00.000000Z],
    read_at: ~U[2025-02-07 22:58:00.000000Z],
    should_auto_check: false
  }
  @invalid_attrs %{
    title: nil,
    author: nil,
    released_at: nil,
    is_read: nil,
    last_checked_at: nil,
    should_auto_check: nil
  }

  describe "index" do
    test "lists all documents", %{conn: conn} do
      conn = get(conn, ~p"/documents")
      assert html_response(conn, 200) =~ "Listing Documents"
    end
  end

  describe "new document" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/documents/new")
      assert html_response(conn, 200) =~ "New Document"
    end
  end

  describe "create document" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/documents", document: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/documents/#{id}"

      conn = get(conn, ~p"/documents/#{id}")
      assert html_response(conn, 200) =~ "Document #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/documents", document: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Document"
    end
  end

  describe "edit document" do
    setup [:create_document]

    test "renders form for editing chosen document", %{conn: conn, document: document} do
      conn = get(conn, ~p"/documents/#{document}/edit")
      assert html_response(conn, 200) =~ "Edit Document"
    end
  end

  describe "update document" do
    setup [:create_document]

    test "redirects when data is valid", %{conn: conn, document: document} do
      conn = put(conn, ~p"/documents/#{document}", document: @update_attrs)
      assert redirected_to(conn) == ~p"/documents/#{document}"

      conn = get(conn, ~p"/documents/#{document}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, document: document} do
      conn = put(conn, ~p"/documents/#{document}", document: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Document"
    end
  end

  describe "delete document" do
    setup [:create_document]

    test "deletes chosen document", %{conn: conn, document: document} do
      conn = delete(conn, ~p"/documents/#{document}")
      assert redirected_to(conn) == ~p"/documents"

      assert_error_sent 404, fn ->
        get(conn, ~p"/documents/#{document}")
      end
    end
  end

  defp create_document(_) do
    document = document_fixture()
    %{document: document}
  end
end
