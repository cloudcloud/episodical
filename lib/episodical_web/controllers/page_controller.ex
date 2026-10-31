defmodule EpisodicalWeb.PageController do
  use EpisodicalWeb, :controller

  alias Episodical.Model

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, upcoming: Model.list_upcoming_episodes())
  end
end
