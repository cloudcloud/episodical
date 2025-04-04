defmodule EpisodicalWeb.ConfigHTML do
  use EpisodicalWeb, :html

  embed_templates "config_html/*"

  @doc """
  Renders a config form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def config_form(assigns)
end
