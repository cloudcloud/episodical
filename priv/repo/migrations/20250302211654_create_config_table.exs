defmodule Episodical.Repo.Migrations.CreateConfigTables do
  use Ecto.Migration

  def change do
    create table(:config, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :value, :string
      add :is_active, :boolean

      timestamps(type: :utc_datetime_usec)
    end
  end
end
