package data

import (
	"context"
	"embed"
	"io/fs"
	"log"

	"zombiezen.com/go/sqlite/sqlitemigration"
)

//go:embed migrations/*sql
var migrations embed.FS

func (d *Base) migrate() error {
	schema := sqlitemigration.Schema{
		AppID:      0x00060606,
		Migrations: allMigrationFiles(),
	}

	conn := d.conn.Get(context.Background())
	defer d.conn.Put(conn)

	return sqlitemigration.Migrate(context.Background(), conn, schema)
}

func allMigrationFiles() []string {
	f := []string{}

	e, err := fs.ReadDir(migrations, "migrations")
	if err != nil {
		log.Fatalf("Unable to read migration files, '%s'", err.Error())
	}

	for _, x := range e {
		content, err := migrations.ReadFile("migrations/" + x.Name())
		if err != nil {
			log.Fatalf("Unable to open migration file, '%s'", err.Error())
		}
		f = append(f, string(content))
	}

	return f
}
