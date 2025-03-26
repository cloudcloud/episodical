defmodule Episodical.Repo.Migrations.CreateEpisodics do
  use Ecto.Migration

  def change do
    create table(:providers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :base_url, :string
      add :model_type, :string
      add :access_key, :binary

      timestamps(type: :utc_datetime_usec)
    end

    create table(:episodics, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :release_year, :integer
      add :status, :string
      add :last_checked_at, :utc_datetime_usec, null: true
      add :should_auto_check, :boolean, default: false, null: false

      add :external_id, :string, null: true
      add :provider_id, references(:providers, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create table(:artists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :formed_year, :integer
      add :base_location, :string
      add :last_checked_at, :utc_datetime_usec, null: true
      add :should_auto_check, :boolean, default: false, null: false

      add :external_id, :string, null: true
      add :provider_id, references(:providers, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create table(:documents, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :author, :string
      add :released_at, :utc_datetime
      add :is_read, :boolean, default: false, null: false
      add :read_at, :utc_datetime, null: true
      add :last_checked_at, :utc_datetime_usec, null: true
      add :should_auto_check, :boolean, default: false, null: false

      add :external_id, :string, null: true
      add :provider_id, references(:providers, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create table(:genres, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :genre, :string

      add :external_id, :string, null: true
      add :provider_id, references(:providers, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create table(:tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :value, :binary
      add :is_valid, :boolean, default: false, null: false
      add :expires_at, :utc_datetime_usec

      add :provider_id, references(:providers, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create table(:episodic_episodes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :index, :integer
      add :title, :string
      add :season, :integer
      add :released_at, :utc_datetime
      add :is_watched, :boolean, default: false, null: false
      add :watched_at, :utc_datetime, null: true
      add :overview, :string

      add :external_id, :string, null: true
      add :episodic_id, references(:episodics, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create table(:artist_albums, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :released_at, :utc_datetime
      add :song_count, :integer

      add :external_id, :string, null: true
      add :artist_id, references(:artists, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create table(:artist_songs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :length_seconds, :integer
      add :track_index, :integer

      add :external_id, :string, null: true
      add :artist_album_id, references(:artist_albums, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create table(:paths, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :last_checked_at, :utc_datetime_usec, null: true
      add :should_auto_check, :boolean, default: false, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create table(:files, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :last_checked_at, :utc_datetime_usec, null: true

      add :path_id, references(:paths, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create table(:logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :action_taken, :string
      add :entity_id, :binary
      add :entity_type, :string
      add :was_success, :boolean, default: false, null: false
      add :debug, :string

      timestamps(type: :utc_datetime_usec)
    end

    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :action_taken, :string
      add :entity_id, :binary
      add :entity_type, :string
      add :was_manual, :boolean, default: false, null: false
      add :debug, :string

      timestamps(type: :utc_datetime_usec)
    end
  end
end
