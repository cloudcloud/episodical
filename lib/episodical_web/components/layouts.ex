defmodule EpisodicalWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use EpisodicalWeb, :controller` and
  `use EpisodicalWeb, :live_view`.
  """
  use EpisodicalWeb, :html

  embed_templates "layouts/*"
end
