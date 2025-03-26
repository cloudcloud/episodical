alias Episodical.Repo
alias Episodical.Model.Config

config = [
  %{
    name: "episodical_language",
    value: "eng",
    is_active: true
  },
  %{
    name: "episodic_filename_pattern",
    value: ".+\\.S(\\d+)E(\\d+)\\.([a-z0-9]+)",
    is_active: true
  },
  %{
    name: "episodic_path_layout",
    value: ":upper_word_title/:upper_word_season/:files",
    is_active: true
  }
]

config
|> Enum.each(fn data ->
  Repo.insert!(%Config{name: data[:name], value: data[:value], is_active: data[:is_active]})
end)
