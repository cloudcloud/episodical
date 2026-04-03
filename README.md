# Episodical

A self-hosted, self-contained web application for tracking episodic content, artists, and authors. Built with [Elixir](https://elixir-lang.org) and [Phoenix](https://www.phoenixframework.org), using Phoenix LiveView for a real-time UI and an encrypted SQLite database for storage.

## Requirements

- Elixir ~> 1.18
- Erlang/OTP 27
- Node.js (for asset compilation during development)

Or, if running via Docker, none of the above — see [Docker](#docker) below.

## Configuration

Episodical is configured entirely through environment variables.

| Variable | Description |
|---|---|
| `HOSTNAME` | The hostname the service is served under (e.g. `localhost`) |
| `PORT` | The port to listen on (e.g. `4000`) |
| `DATA_FILE` | Full path to the SQLite database file (e.g. `/var/episodical/episodical.db`) |
| `DATA_PASSPHRASE` | Passphrase used to encrypt the SQLite database |
| `ENCRYPTION_KEYS` | Base64-encoded 32-byte key(s) used for data encryption at rest |
| `SECRET_KEY_BASE` | Phoenix secret key base — required in production |

To generate a suitable `ENCRYPTION_KEYS` value from an IEx session:

```elixir
:crypto.strong_rand_bytes(32) |> :base64.encode()
```

## Development

Clone the repo and install dependencies:

```bash
git clone https://github.com/cloudcloud/episodical.git
cd episodical
mix setup
```

Start an interactive development server:

```bash
make start
```

This runs `iex -S mix phx.server` with a default `ENCRYPTION_KEYS` value suitable for local development. The app will be available at `http://localhost:4000`.

Other useful `make` targets:

| Target | Description |
|---|---|
| `make start` | Start the dev server in an IEx session |
| `make test` | Run the test suite |
| `make coverage` | Run tests with coverage output |
| `make reset` | Drop and recreate the development database |
| `make clean` | Remove compiled assets |

## Docker

Build the image locally:

```bash
make build-image
```

Or pull the latest published image:

```bash
docker pull cloudcloud/episodical:latest
```

Run a container, mounting a local directory for the database file:

```bash
docker run -d \
  -e HOSTNAME=localhost \
  -e PORT=4000 \
  -e DATA_FILE=/data/episodical.db \
  -e DATA_PASSPHRASE=your-passphrase \
  -e ENCRYPTION_KEYS=your-base64-key \
  -e SECRET_KEY_BASE=your-secret-key-base \
  -p 4000:4000 \
  -v /path/to/local/data:/data \
  cloudcloud/episodical:latest
```

## Building a release

To produce a production OTP release binary:

```bash
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod mix release
```

The release is written to `_build/prod/rel/episodical/`. Start it with:

```bash
_build/prod/rel/episodical/bin/server
```

All four environment variables listed above must be set before starting the release.

## Integrations

Episodical supports external metadata integrations for each tracked content type. Integrations are configured from within the UI after the app is running; credentials and settings are stored in the encrypted database.

## Testing

```bash
make test
```

The test suite uses a separate database and will create and migrate it automatically. For coverage:

```bash
make coverage
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the contribution workflow. The short version: fork, branch, test, format (`mix format`), pull request.

## License

[Apache 2.0](LICENSE)
