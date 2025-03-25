ExUnit.configure formatters: [BuildkiteTestCollector.Formatter, ExUnit.CLIFormatter]

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Episodical.Repo, :manual)
