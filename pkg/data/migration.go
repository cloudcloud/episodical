package data

import (
	"database/sql"
	"embed"

	migrate "github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/sqlite"
	"github.com/golang-migrate/migrate/v4/source/iofs"
	_ "modernc.org/sqlite"
)

//go:embed migrations/*sql
var migrations embed.FS

func (d *Base) migrate() error {
	db, err := sql.Open("sqlite", d.conf.DataFile)
	if err != nil {
		return err
	}

	mfs, err := iofs.New(migrations, "migrations")
	if err != nil {
		return err
	}

	data, err := sqlite.WithInstance(db, &sqlite.Config{})
	if err != nil {
		return err
	}

	m, err := migrate.NewWithInstance(
		"iofs",
		mfs,
		"sqlite",
		data,
	)
	if err != nil {
		return err
	}

	err = m.Up()
	if err != nil && err.Error() != "no change" {
		return err
	}

	return nil
}
