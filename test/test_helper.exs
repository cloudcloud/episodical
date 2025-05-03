ExUnit.configure(formatters: [BuildkiteTestCollector.Formatter, ExUnit.CLIFormatter])

RequestStub.start_link(%{})

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Episodical.Repo, :manual)
