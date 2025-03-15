defmodule EpisodicalWeb.EpisodicHTML do
  use EpisodicalWeb, :html

  embed_templates "episodic_html/*"

  @doc """
  Renders a episodic form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def episodic_form(assigns)

  @doc ~S"""
  Generate a block for each Season within the Episodic.

  ## Examples

      <.seasons episodes={@episodes}>
      </.seasons>
  """
  attr :episodes, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def seasons(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    """
  end
end
