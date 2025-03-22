defmodule Episodical.Repo.Migrations.UpdateAssociations do
  use Ecto.Migration

  def change do
    alter table(:episodics) do
      add :path_id, references(:paths, on_delete: :nothing, type: :binary_id)
    end

    alter table(:files) do
      add :episode_id, references(:episodic_episodes, on_delete: :nothing, type: :binary_id)
      add :episodic_id, references(:episodics, on_delete: :nothing, type: :binary_id)
    end

    alter table(:episodic_episodes) do
      add :file_id, references(:files, on_delete: :delete_all, type: :binary_id)
    end
  end
end
