defmodule Episodical.Local.File do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "files" do
    field :name, :string
    field :last_checked_at, :utc_datetime_usec

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:name, :last_checked_at])
    |> validate_required([:name, :last_checked_at])
  end

  # parse the config values
  #
  # :files
  #   Files are matched from this location.
  # :upper_word_title
  #   "The Boys"
  # :upper_word_season
  #   "Season 2"
  # :upper_snake_word_title
  #   "The_Boys"
  # :upper_camel_word_title
  #   "The-Boys"
  # :lower_snake_word_title
  #   "the_boys"
  # :lower_camel_word_title
  #   "the-boys"
  # :numerical_season
  #   "1"
  # :numerical_prefix_season
  #   "001"
end
