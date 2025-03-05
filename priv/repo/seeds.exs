alias Episodical.Repo
alias Episodical.Model.Config

config = [
  %{
    name: "episodical_language",
    value: "eng",
    is_active: true
  }
]

config
|> Enum.each(fn data ->
  Repo.insert!(%Config{name: data[:name], value: data[:value], is_active: data[:is_active]})
end)
