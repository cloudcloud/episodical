defmodule EpisodicalWeb.ConfigController do
  use EpisodicalWeb, :controller

  alias Episodical.Model

  def index(conn, _params) do
    config = Model.list_config()
    render(conn, :index, config: config)
  end

  def edit(conn, %{"id" => id}) do
    config = Model.get_config!(id)
    changeset = Model.change_config(config)
    render(conn, :edit, config: config, changeset: changeset)
  end

  def update(conn, %{"id" => id, "config" => config_params}) do
    config = Model.get_config!(id)

    case Model.update_config(config, config_params) do
      {:ok, ^config} ->
        conn
        |> put_flash(:info, "Config updated successfully.")
        |> redirect(to: ~p"/config")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, config: config, changeset: changeset)
    end
  end
end
