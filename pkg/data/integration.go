package data

import (
	"context"
	"fmt"

	"github.com/cloudcloud/episodical/pkg/types"
	"zombiezen.com/go/sqlite"
	"zombiezen.com/go/sqlite/sqlitex"
)

const (
	sqlAddIntegration = `INSERT INTO integrations
(id, title, access_key, base_model, collection_type)
VALUES
(@id, @title, @access_key, @base_model, @collection_type);`
	sqlDeleteIntegration             = `DELETE FROM integrations WHERE id = ?;`
	sqlExpireOldTokens               = `UPDATE tokens SET is_valid = false WHERE integration_id = ?;`
	sqlGetIntegrations               = `SELECT * FROM integrations;`
	sqlGetIntegrationByID            = `SELECT * FROM integrations WHERE id = ?;`
	sqlGetLatestTokenByIntegrationID = `SELECT * FROM tokens WHERE integration_id = ? AND is_valid = 1 ORDER BY date_expires DESC LIMIT 1;`
	sqlStoreLatestToken              = `INSERT INTO tokens
(id, integration_id, is_valid, value, date_added, date_expires)
VALUES
(@id, @integration_id, @is_valid, @value, @date_added, @date_expires);`
	sqlUpdateIntegration = `UPDATE integrations
SET title = @title, access_key = @access_key, base_model = @base_model, collection_type = @collection_type
WHERE id = @id;`
)

func (d *Base) AddIntegration(ctx context.Context, a *types.AddIntegration) (*types.Integration, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	i, err := a.Convert()
	if err != nil {
		return nil, err
	}

	return i, sqlitex.Execute(conn, sqlAddIntegration, &sqlitex.ExecOptions{Named: i.Named()})
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

func (d *Base) GetLatestToken(ctx context.Context, id string) (*types.Token, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	tok := &types.Token{}
	err := sqlitex.Execute(
		conn,
		sqlGetLatestTokenByIntegrationID,
		&sqlitex.ExecOptions{
			Args: []interface{}{id},
			ResultFunc: func(stmt *sqlite.Stmt) error {
				t, err := loadToken(stmt)
				tok = &t

				return err
			},
		},
	)

	return tok, err
}

func (d *Base) StoreLatestToken(ctx context.Context, t *types.Token) (*types.Token, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	f, err := sqlitex.ImmediateTransaction(conn)
	if err != nil {
		return nil, err
	}
	f(&err)

	err = sqlitex.Execute(
		conn,
		sqlExpireOldTokens,
		&sqlitex.ExecOptions{
			Args: []any{t.IntegrationID},
		},
	)

	tok := &types.Token{}
	err = sqlitex.Execute(
		conn,
		sqlStoreLatestToken,
		&sqlitex.ExecOptions{
			Named: t.Named(),
			ResultFunc: func(stmt *sqlite.Stmt) error {
				t, err := loadToken(stmt)
				tok = &t

				return err
			},
		},
	)

	return tok, err
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
