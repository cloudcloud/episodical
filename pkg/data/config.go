package data

import (
	"context"

	"github.com/cloudcloud/episodical/pkg/types"
)

func (d *Base) AddFilesystem(ctx context.Context, f *types.AddFilesystem) (*types.Filesystem, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	// convert to filesystem, store
	//n, err := f.Convert()
	//if err != nil {
	//	return nil, err
	//}

	//return n, sqlitex.Execute(conn, sqlAddFilesystem, &sqlitex.ExecOptions{Named: n.Named()})
	return nil, nil
}
