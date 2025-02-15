defmodule EpisodicalWeb.ProviderHTML do
  @moduledoc """
  This module contains pages rendered by ProviderController.

  See the `provider_html` directory for all templates available.
  """
  use EpisodicalWeb, :html

  embed_templates "provider_html/*"
end
