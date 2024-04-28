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
		Migrations: allMigrationFiles(migrations),
	}

	conn := d.db.Get(context.Background())
	defer d.db.Put(conn)

	return sqlitemigration.Migrate(context.Background(), conn, schema)
}

func allMigrationFiles() []string {
	f := []string{}

	e, err := fs.ReadDir(f, "migrations")
	if err != nil {
		log.Fatalf("Unable to read migration files, '%s'", err)
	}

	// range f.ReadDir("migrations")
	for _, x := range e {
		content, err := f.ReadFile(x)
		if err != nil {
			log.Fatalf("Unable to open migration file, '%s'", err)
		}
		f = append(f, content)
	}

	return f
}
