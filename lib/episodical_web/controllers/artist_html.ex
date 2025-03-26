defmodule EpisodicalWeb.ArtistHTML do
  use EpisodicalWeb, :html

  embed_templates "artist_html/*"

  @doc """
  Renders a artist form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def artist_form(assigns)
end
