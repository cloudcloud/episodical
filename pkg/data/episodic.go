package data

import (
	"context"

	"github.com/cloudcloud/episodical/pkg/types"
	"zombiezen.com/go/sqlite"
	"zombiezen.com/go/sqlite/sqlitex"
)

const (
	sqlAddEpisodic = `INSERT INTO episodic
(id, title, year, date_added, date_updated, integration_used, file_system, path_id, is_active, genre, public_db_id, last_checked, auto_update)
VALUES
(@id, @title, @year, @date_added, @date_updated, @integration_used, @file_system, @path_id, @is_active, @genre, @public_db_id, @last_checked, @auto_update);`
	sqlRemoveEpisodic = `DELETE FROM episodic
WHERE episodic.id = ?;`
	sqlGetEpisodicByID = `SELECT * FROM episodic
WHERE episodic.id = ?;`
	sqlUpdateEpisodic = `UPDATE episodic
SET title = :title
WHERE id = :id;`
)

func (d *Base) AddEpisodic(ctx context.Context, ep types.AddEpisodic) (*types.Episodic, error) {
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
	return []*types.Episodic{}, nil
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
				return nil
			},
		},
	)

	eps, err := d.GetEpisodicEpisodesByID(ctx, u)
	if err != nil {
		return nil, err
	}

	ep.Episodes = eps
	return ep, nil
}

func (d *Base) GetEpisodicEpisodesByID(ctx context.Context, u string) ([]*types.Episode, error) {
	return []*types.Episode{}, nil
}

func (d *Base) RemoveEpisodic(ctx context.Context, ep types.Episodic) error {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	return sqlitex.Execute(conn, sqlRemoveEpisodic, &sqlitex.ExecOptions{Args: []interface{}{ep.ID}})
}

func (d *Base) UpdateEpisodic(ctx context.Context, ep types.AddEpisodic) (*types.Episodic, error) {
	return nil, nil
}
