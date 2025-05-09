defmodule EpisodicalWeb.EpisodicHTML do
  use EpisodicalWeb, :html

  embed_templates "episodic_html/*"

  @doc """
  Renders a episodic form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :paths, :list, required: true
  attr :episodic, :any, required: true

  def episodic_form(assigns)
end
