package data

import (
	"context"
	"fmt"

	"github.com/cloudcloud/episodical/pkg/types"
	"zombiezen.com/go/sqlite"
	"zombiezen.com/go/sqlite/sqlitex"
)

const (
	sqlAddFilesystem = `INSERT INTO filesystem
(id, title, base_path, auto_update, last_checked)
VALUES
(@id, @title, @base_path, @auto_update, @last_checked);`
	sqlDeleteFilesystem  = `DELETE FROM filesystem WHERE id = ?;`
	sqlGetFilesystems    = `SELECT * FROM filesystem;`
	sqlGetFilesystemByID = `SELECT * FROM filesystem WHERE id = ?;`
	sqlUpdateFilesystem  = `UPDATE filesystem
SET title = @title, base_path = @base_path, auto_update = @auto_update
WHERE id = @id;`

	sqlAddIntegration = `INSERT INTO integrations
(id, title, access_key, base_model, collection_type)
VALUES
(@id, @title, @access_key, @base_model, @collection_type);`
	sqlDeleteIntegration  = `DELETE FROM integrations WHERE id = ?;`
	sqlGetIntegrations    = `SELECT * FROM integrations;`
	sqlGetIntegrationByID = `SELECT * FROM integrations WHERE id = ?;`
	sqlUpdateIntegration  = `UPDATE integrations
SET title = @title, access_key = @access_key, base_model = @base_model, collection_type = @collection_type
WHERE id = @id;`
)

func (d *Base) AddFilesystem(ctx context.Context, f *types.AddFilesystem) (*types.Filesystem, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	n, err := f.Convert()
	if err != nil {
		return nil, err
	}

	return n, sqlitex.Execute(conn, sqlAddFilesystem, &sqlitex.ExecOptions{Named: n.Named()})
}

func (d *Base) AddIntegration(ctx context.Context, a *types.AddIntegration) (*types.Integration, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	i, err := a.Convert()
	if err != nil {
		return nil, err
	}

	return i, sqlitex.Execute(conn, sqlAddIntegration, &sqlitex.ExecOptions{Named: i.Named()})
}

func (d *Base) DeleteFilesystem(ctx context.Context, id string) error {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	e := error(nil)
	err := sqlitex.Execute(
		conn,
		sqlDeleteFilesystem,
		&sqlitex.ExecOptions{
			Args: []interface{}{id},
			ResultFunc: func(stmt *sqlite.Stmt) error {
				e = stmt.Finalize()
				return e
			},
		},
	)
	if e != nil {
		return e
	}
	return err
}

func (d *Base) DeleteIntegration(ctx context.Context, id string) error {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	e := error(nil)
	err := sqlitex.Execute(
		conn,
		sqlDeleteIntegration,
		&sqlitex.ExecOptions{
			Args: []interface{}{id},
			ResultFunc: func(stmt *sqlite.Stmt) error {
				e = stmt.Finalize()
				return e
			},
		},
	)
	if e != nil {
		return e
	}
	return err
}

func (d *Base) GetFilesystems(ctx context.Context) ([]types.Filesystem, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	fs := []types.Filesystem{}
	err := sqlitex.Execute(
		conn,
		sqlGetFilesystems,
		&sqlitex.ExecOptions{
			ResultFunc: func(stmt *sqlite.Stmt) error {
				f, err := loadFilesystem(stmt)
				if err == nil {
					fs = append(fs, f)
				}

				return err
			},
		},
	)

	return fs, err
}

func (d *Base) GetIntegrations(ctx context.Context) ([]types.Integration, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	is := []types.Integration{}
	err := sqlitex.Execute(
		conn,
		sqlGetIntegrations,
		&sqlitex.ExecOptions{
			ResultFunc: func(stmt *sqlite.Stmt) error {
				i, err := loadIntegration(stmt)
				if err == nil {
					is = append(is, i)
				}

				return err
			},
		},
	)

	return is, err
}

func (d *Base) GetFilesystemByID(ctx context.Context, u string) (*types.Filesystem, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	fs := &types.Filesystem{}
	err := sqlitex.Execute(
		conn,
		sqlGetFilesystemByID,
		&sqlitex.ExecOptions{
			Args: []interface{}{u},
			ResultFunc: func(stmt *sqlite.Stmt) error {
				f, err := loadFilesystem(stmt)
				fs = &f

				return err
			},
		},
	)
	if err != nil {
		return nil, err
	}
	if fs.ID != u {
		return nil, fmt.Errorf("Unable to find Filesystem with ID '%s'", u)
	}

	return fs, err
}

func (d *Base) GetIntegrationByID(ctx context.Context, u string) (*types.Integration, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	is := &types.Integration{}
	err := sqlitex.Execute(
		conn,
		sqlGetIntegrationByID,
		&sqlitex.ExecOptions{
			Args: []interface{}{u},
			ResultFunc: func(stmt *sqlite.Stmt) error {
				i, err := loadIntegration(stmt)
				is = &i

				return err
			},
		},
	)
	if err != nil {
		return nil, err
	}
	if is.ID != u {
		return nil, fmt.Errorf("Unable to find Integration with ID '%s'", u)
	}

	return is, err
}

func (d *Base) UpdateFilesystem(ctx context.Context, id string, n *types.AddFilesystem) (*types.Filesystem, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	f, err := n.Convert()
	if err != nil {
		return nil, err
	}

	named := f.Named()
	named["@id"] = id
	delete(named, "@last_checked")

	return f, sqlitex.Execute(conn, sqlUpdateFilesystem, &sqlitex.ExecOptions{Named: named})
}

func (d *Base) UpdateIntegration(ctx context.Context, id string, n *types.AddIntegration) (*types.Integration, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	i, err := n.Convert()
	if err != nil {
		return nil, err
	}

	named := i.Named()
	named["@id"] = id

	return i, sqlitex.Execute(conn, sqlUpdateIntegration, &sqlitex.ExecOptions{Named: named})
}
