import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :episodical, Episodical.Repo,
  username: System.get_env("PGUSER") || "postgres",
  password: "postgres",
  hostname: System.get_env("PGHOST") || "localhost",
  database: "episodical_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :episodical, EpisodicalWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  server: false

# In test we don't send emails
config :episodical, Episodical.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Using the test collector for great power
config :buildkite_test_collector,
  api_key: System.get_env("BUILDKITE_ANALYTICS_TOKEN"),
  activate_debug: false

# Use the Request module by default for HTTP calls
config :episodical, http_adapter: RequestStub

config :episodical, Episodical.Encryption,
  keys:
    System.get_env("ENCRYPTION_KEYS")
    |> String.replace("'", "")
    |> String.split(",")
    |> Enum.map(fn key -> :base64.decode(key) end)
