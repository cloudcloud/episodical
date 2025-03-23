defmodule Episodical.Local.Path do
  use Ecto.Schema
  import Ecto.Changeset

  alias Episodical.Model

  @type t :: %__MODULE__{
    id: binary,
    name: String.t(),
    last_checked_at: DateTime.t(),
    should_auto_check: bool(),
    files: list(Episodical.Local.File.t()),
    episodic: Episodical.Model.Episodic.t(),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "paths" do
    field :name, :string
    field :last_checked_at, :utc_datetime_usec
    field :should_auto_check, :boolean, default: false

    has_many :files, Episodical.Local.File
    has_many :episodic, Episodical.Model.Episodic

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(path, attrs) do
    path
    |> cast(attrs, [:name, :last_checked_at, :should_auto_check])
    |> validate_required([:name, :should_auto_check])
  end

  def use_path_layout(%Model.Config{} = path_config, %Model.Episodic{} = episodic) do
    path_config.value
      |> String.replace(":upper_word_title", episodic.title)
      |> String.replace(":lower_word_title", String.downcase(episodic.title))
      |> String.replace(":upper_snake_word_title", String.replace(episodic.title, " ", "_"))
      |> String.replace(":upper_camel_word_title", String.replace(episodic.title, " ", "-"))
      |> String.replace(":lower_snake_word_title", String.replace(String.downcase(episodic.title), " ", "_"))
      |> String.replace(":lower_camel_word_title", String.replace(String.downcase(episodic.title), " ", "-"))
      |> String.replace(":upper_word_season", "Season \\d+")
      |> String.replace(":numerical_season", "\\d+")
      |> String.replace(":numerical_prefix_season", "\\d+")
      |> String.replace(":files", "(.+)")
      |> Regex.compile
  end

  def find_matching_files(%__MODULE__{} = path, match_path) do
    {:ok, it} = Walker.start_link(path.name, %{matching: match_path})

    trawl_matches(it, match_path)
  end

  defp trawl_matches(it, path, acc \\ []) do
    case Walker.next(it, 1) do
      [file] ->
        trawl_matches(it, path, [file | acc])

      nil ->
        {:ok, acc}
    end
  end
end
