defmodule EpisodicalWeb.PathsHTML do
  @moduledoc """
  This module contains pages rendered by PathController.

  See the `paths_html` directory for all templates available.
  """
  use EpisodicalWeb, :html

  embed_templates "paths_html/*"
end
