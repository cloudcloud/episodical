# Episodical

A self-contained full web application to manage and track Episodical, Artistic, and Document based entities.

## Usage

There are 4 configuration requirements for Episodical, provided via environment variables.

- `HOSTNAME` defines the hostname the service is made available under.
- `PORT` is the local port that Episodical will listen on for requests.
- `DATA_FILE` contains the full path filename of where the _sqlite3_ database will be stored.
- `DATA_PASSPHRASE` is the private phrase used to encrypt the _sqlite3_ content.

The provided `docker-compose.yml` file can be used to bring up the service (with the predefined defaults of the above configuration), to run the docker containerised version. This pulls the image from `hub.docker.com`.

Releases of the binary can also be found on the releases page for the specific version requested (and the operating system + architecture combination).

## Integrations

There are several integrations available to utilise within Episodical to bring additional metadata for the different Episodical data types. Each of these integrations have their own configurations, which are each able to be configured from within the UI once Episodical is running. The configuration data for these is then stored within the encrypted _sqlite3_ database.

## Building

To build from source, `make install` will do everything that's necessary.
