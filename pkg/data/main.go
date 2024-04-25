package data

import (
	"github.com/cloudcloud/episodical/pkg/config"
	"github.com/jmoiron/sqlx"

	_ "modernc.org/sqlite"
)

type Base struct {
	Errors []error

	conf *config.Config
	conn *sqlx.DB
}

func Open(c *config.Config) (*Base, error) {
	db, err := sqlx.Open("sqlite", c.DataFile)
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
