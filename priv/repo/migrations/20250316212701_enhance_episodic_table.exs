defmodule Episodical.Repo.Migrations.EnhanceEpisodicTable do
  use Ecto.Migration

  def change do
    alter table(:episodics) do
      add :image, :text
      add :overview, :text
      add :original_language, :string
      add :next_airing, :utc_datetime, null: true
      add :imdb_id, :string, null: true
    end
  end
end
