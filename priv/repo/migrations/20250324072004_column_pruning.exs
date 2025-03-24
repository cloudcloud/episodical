defmodule Episodical.Repo.Migrations.ColumnPruning do
  use Ecto.Migration

  def change do
    alter table(:episodic_episodes) do
      remove :file_id
    end
  end
end
