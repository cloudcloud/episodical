defmodule Episodical.Repo.Migrations.AddEpisodicGenreAssociationTable do
  use Ecto.Migration

  def change do
    create table(:episodics_genres, primary_key: false) do
      add :episodic_id,
        references(:episodics, type: :binary_id, on_delete: :delete_all),
        null: false

      add :genre_id,
        references(:genres, type: :binary_id, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:episodics_genres, [:episodic_id, :genre_id])
    create unique_index(:genres, [:external_id])

    alter table(:episodic_episodes) do
      modify :overview, :text
      add :provider_id, references(:providers, on_delete: :nothing, type: :binary_id)
    end

    create unique_index(:episodic_episodes, [:external_id])

    alter table(:genres) do
      add :external_id, :text
    end
  end
end
