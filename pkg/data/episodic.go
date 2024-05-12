package data

import (
	"context"
	"fmt"

	"github.com/cloudcloud/episodical/pkg/types"
	"zombiezen.com/go/sqlite"
	"zombiezen.com/go/sqlite/sqlitex"
)

const (
	sqlAddEpisodic = `INSERT INTO episodic
(id, title, year, date_added, date_updated, integration_id, filesystem_id, path, is_active, genre, public_db_id, last_checked, auto_update)
VALUES
(@id, @title, @year, @date_added, @date_updated, @integration_id, @filesystem_id, @path, @is_active, @genre, @public_db_id, @last_checked, @auto_update);`
	sqlGetEpisodicByID = `SELECT * FROM episodic
WHERE episodic.id = ?;`
	sqlGetEpisodics = `SELECT * FROM episodic
`
	sqlGetEpisodesByEpisodic = `SELECT * FROM episodic_episode
WHERE episodic_episode.episodic_id = ?;`
	sqlRemoveEpisodic = `DELETE FROM episodic
WHERE episodic.id = ?;`
	sqlUpdateEpisodic = `UPDATE episodic
SET title = @title, year = @year, date_added = @date_added, integration_id = @integration_id, filesystem_id = @filesystem_id, path = @path, genre = @genre, public_db_id = @public_db_id, date_updated = @date_updated, last_checked = @last_checked, is_active = @is_active, auto_update = @auto_update
WHERE id = @id;`
)

func (d *Base) AddEpisodic(ctx context.Context, ep *types.AddEpisodic) (*types.Episodic, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	// create the Episodic from AddEpisodic
	n, err := ep.Convert()
	if err != nil {
		return nil, err
	}

	return n, sqlitex.Execute(conn, sqlAddEpisodic, &sqlitex.ExecOptions{Named: n.Named()})
}

func (d *Base) GetEpisodics(ctx context.Context) ([]*types.Episodic, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	eps := []*types.Episodic{}
	err := sqlitex.Execute(
		conn,
		sqlGetEpisodics,
		&sqlitex.ExecOptions{
			ResultFunc: func(stmt *sqlite.Stmt) error {
				e, err := loadEpisodic(stmt)
				if err == nil {
					eps = append(eps, e)
				}

				return err
			},
		},
	)

	return eps, err
}

func (d *Base) GetEpisodicByID(ctx context.Context, u string) (*types.Episodic, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	ep := &types.Episodic{}
	err := sqlitex.Execute(
		conn,
		sqlGetEpisodicByID,
		&sqlitex.ExecOptions{
			Args: []interface{}{u},
			ResultFunc: func(stmt *sqlite.Stmt) error {
				e, err := loadEpisodic(stmt)
				ep = e

				return err
			},
		},
	)
	if err != nil {
		return nil, err
	}
	if ep.ID != u {
		return nil, fmt.Errorf("Unable to find Episodic with ID '%s'", u)
	}

	eps, err := d.GetEpisodicEpisodesByID(ctx, u)
	if err != nil {
		return nil, err
	}

	ep.Episodes = eps
	return ep, nil
}

func (d *Base) GetEpisodicEpisodesByID(ctx context.Context, u string) ([]*types.Episode, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	ep := []*types.Episode{}
	err := sqlitex.Execute(
		conn,
		sqlGetEpisodesByEpisodic,
		&sqlitex.ExecOptions{
			Args: []interface{}{u},
			ResultFunc: func(stmt *sqlite.Stmt) error {
				e, err := loadEpisode(stmt)
				ep = append(ep, e)

				return err
			},
		},
	)

	return ep, err
}

func (d *Base) DeleteEpisodic(ctx context.Context, id string) error {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	return sqlitex.Execute(conn, sqlRemoveEpisodic, &sqlitex.ExecOptions{Args: []interface{}{id}})
}

func (d *Base) GetEpisodeSearch(ctx context.Context, ep *types.Episode) (*types.Episode, error) {
	return nil, nil
}

func (d *Base) StoreEpisode(ctx context.Context, ep *types.Episode) error {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	return nil
}

func (d *Base) UpdateEpisode(ctx context.Context, orig, ep *types.Episode) error {
	return nil
}

func (d *Base) UpdateEpisodic(ctx context.Context, id string, ep *types.AddEpisodic) (*types.Episodic, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	episodic := &types.Episodic{}
	e, err := ep.Convert()
	if err != nil {
		return nil, err
	}

	named := e.Named()
	named["@id"] = id

	err = sqlitex.Execute(
		conn,
		sqlUpdateEpisodic,
		&sqlitex.ExecOptions{
			Named: named,
			ResultFunc: func(stmt *sqlite.Stmt) error {
				episodic, err = loadEpisodic(stmt)

				return err
			},
		},
	)

	return episodic, err
}
