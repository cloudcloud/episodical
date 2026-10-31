defmodule EpisodicalWeb.PageControllerTest do
  use EpisodicalWeb.ConnCase, async: true

  import Phoenix.Template
  import Episodical.ModelFixtures

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Episodics"
  end

  test "renders the home view" do
    html =
      render_to_string(EpisodicalWeb.PageHTML, "home", "html",
        flash: %{},
        upcoming: []
      )

    assert html =~ "Upcoming episodes"
    assert html =~ "No upcoming episodes found."
  end

  test "lists the next upcoming episode per episodic", %{conn: conn} do
    today = DateTime.new!(Date.utc_today(), ~T[00:00:00])

    survivor = episodic_fixture(%{title: "Survivor Series Test"})
    expanse = episodic_fixture(%{title: "Expanse Series Test"})

    episode_fixture(%{
      episodic_id: survivor.id,
      title: "Survivor Later",
      released_at: DateTime.add(today, 14, :day)
    })

    episode_fixture(%{
      episodic_id: survivor.id,
      title: "Survivor First",
      released_at: DateTime.add(today, 2, :day)
    })

    episode_fixture(%{
      episodic_id: expanse.id,
      title: "Expanse First",
      released_at: DateTime.add(today, 5, :day)
    })

    # Already aired, so it must not appear.
    episode_fixture(%{
      episodic_id: expanse.id,
      title: "Expanse Past",
      released_at: DateTime.add(today, -1, :day)
    })

    html = get(conn, ~p"/") |> html_response(200)

    assert html =~ "Survivor First"
    assert html =~ "Expanse First"
    refute html =~ "Survivor Later"    refute html =~ "Expanse Past"
  end
end
