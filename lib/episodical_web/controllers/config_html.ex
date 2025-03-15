defmodule EpisodicalWeb.ConfigHTML do
  use EpisodicalWeb, :html

  embed_templates "config_html/*"

  @doc """
  Renders a config form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def config_form(assigns)

  def display_slashes(value) do
    IO.inspect String.split(value, "")
  end
end
