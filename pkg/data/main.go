package data

import (
	"github.com/cloudcloud/episodical/pkg/config"
	"zombiezen.com/go/sqlite"
	"zombiezen.com/go/sqlite/sqlitex"
)

type Base struct {
	Errors []error

	conf *config.Config
	conn *sqlitex.Pool
}

func Open(c *config.Config) (*Base, error) {
	db, err := sqlitex.Open(
		c.DataFile,
		sqlite.OpenCreate|sqlite.OpenReadWrite|sqlite.OpenWAL|sqlite.OpenNoMutex,
		10,
	)
	if err != nil {
		return nil, err
	}

	d := &Base{Errors: []error{}, conn: db}
	err = d.migrate()
	if err != nil {
		return nil, err
	}

	return d, nil
}
