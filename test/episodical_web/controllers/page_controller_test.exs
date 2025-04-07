defmodule EpisodicalWeb.PageControllerTest do
  use EpisodicalWeb.ConnCase, async: true

  import Phoenix.Template

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Episodics"
  end

  test "renders the home view" do
    assert render_to_string(EpisodicalWeb.PageHTML, "home", "html", [{:flash, %{}}]) =~
             "Latest releases"
  end
end
