defmodule Episodical.Repo.Migrations.AddServiceType do
  use Ecto.Migration

  def change do
    alter table(:providers) do
      add :service_type, :string
    end
  end
end
