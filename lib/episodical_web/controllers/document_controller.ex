defmodule EpisodicalWeb.DocumentController do
  use EpisodicalWeb, :controller

  alias Episodical.Model
  alias Episodical.Model.Document

  def index(conn, _params) do
    documents = Model.list_documents()
    render(conn, :index, documents: documents)
  end

  def new(conn, _params) do
    changeset = Model.change_document(%Document{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"document" => document_params}) do
    case Model.create_document(document_params) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document created successfully.")
        |> redirect(to: ~p"/documents/#{document}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    document = Model.get_document!(id)
    render(conn, :show, document: document)
  end

  def edit(conn, %{"id" => id}) do
    document = Model.get_document!(id)
    changeset = Model.change_document(document)
    render(conn, :edit, document: document, changeset: changeset)
  end

  def update(conn, %{"id" => id, "document" => document_params}) do
    document = Model.get_document!(id)

    case Model.update_document(document, document_params) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document updated successfully.")
        |> redirect(to: ~p"/documents/#{document}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, document: document, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    document = Model.get_document!(id)
    {:ok, _document} = Model.delete_document(document)

    conn
    |> put_flash(:info, "Document deleted successfully.")
    |> redirect(to: ~p"/documents")
  end
end
