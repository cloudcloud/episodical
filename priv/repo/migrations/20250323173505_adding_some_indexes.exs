defmodule Episodical.Repo.Migrations.AddingSomeIndexes do
  use Ecto.Migration

  def change do
    create unique_index(:files, [:name])
  end
end
