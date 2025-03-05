defmodule EpisodicalWeb.ProviderHTML do
  @moduledoc """
  This module contains pages rendered by ProviderController.

  See the `provider_html` directory for all templates available.
  """
  use EpisodicalWeb, :html

  def printable_token(val), do: "#{munge_token_value(val)}..."

  defp munge_token_value(val), do: val |> String.split("") |> Enum.take(70) |> Enum.join

  embed_templates "provider_html/*"
end
