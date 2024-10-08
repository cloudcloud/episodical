package data

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/cloudcloud/episodical/pkg/types"
	"zombiezen.com/go/sqlite"
	"zombiezen.com/go/sqlite/sqlitex"
)

const (
	sqlAddEpisodic               = `INSERT INTO episodic (id, title, year, date_added, date_updated, integration_id, filesystem_id, path, is_active, genre, public_db_id, last_checked, auto_update) VALUES (@id, @title, @year, @date_added, @date_updated, @integration_id, @filesystem_id, @path, @is_active, @genre, @public_db_id, @last_checked, @auto_update);`
	sqlEpisodicMeta              = `SELECT id, (SELECT COUNT(id) FROM episodic_episode ee WHERE ee.episodic_id = e.id AND datetime(ee.date_first_aired) <= datetime('now') AND ee.season_id != 0) AS total_episode_count, (SELECT COUNT(id) FROM episodic_episode ee WHERE ee.episodic_id = e.id AND ee.file_entry != '' AND ee.season_id != 0) AS total_episode_files, (SELECT COUNT(id) FROM episodic_episode ee WHERE ee.episodic_id = e.id AND ee.season_id = 0) AS total_specials_count, (SELECT MIN(date_first_aired) FROM episodic_episode ee WHERE ee.episodic_id = e.id AND datetime(ee.date_first_aired) > datetime('now')) AS next_episode_date, (SELECT GROUP_CONCAT(DISTINCT(ee.season_id)) FROM episodic_episode ee WHERE ee.episodic_id = e.id AND ee.season_id != 0) AS seasons, (SELECT COUNT(id) FROM episodic_episode ee WHERE ee.episodic_id = e.id AND ee.is_watched = 1) AS total_episodes_watched, (SELECT COUNT(id) > 0 FROM episodic_episode ee WHERE ee.episodic_id = e.id AND ee.season_id = 0) AS has_specials FROM episodic e WHERE id IN ('%s');`
	sqlGetEpisodicByID           = `SELECT * FROM episodic WHERE episodic.id = ?;`
	sqlGetEpisodics              = `SELECT * FROM episodic;`
	sqlGetEpisodesByEpisodic     = `SELECT * FROM episodic_episode WHERE episodic_episode.episodic_id = ?;`
	sqlInsertEpisode             = `INSERT INTO episodic_episode (id, episodic_id, title, season_id, episode_number, date_added, date_updated, is_watched, date_watched, file_entry, integration_identifier, date_first_aired, overview) VALUES (@id, @episodic_id, @title, @season_id, @episode_number, @date_added, @date_updated, @is_watched, @date_watched, @file_entry, @integration_identifier, @date_first_aired, @overview);`
	sqlMarkEpisodeWatched        = `UPDATE episodic_episode SET is_watched = ((is_watched - 1) * (-1)) WHERE id = ? AND episodic_id = ?;`
	sqlMarkEpisodicSeasonWatched = `UPDATE episodic_episode SET is_watched = 1 WHERE season_id = ? AND episodic_id = ?;`
	sqlRemoveAllEpisodes         = `DELETE FROM episodic_episode WHERE episodic_id = ?;`
	sqlRemoveEpisodic            = `DELETE FROM episodic WHERE episodic.id = ?;`
	sqlUpdateEpisode             = `UPDATE episodic_episode SET title = @title, season_id = @season_id, episode_number = @episode_number, date_updated = @date_updated, is_watched = @is_watched, date_watched = @date_watched, file_entry = @file_entry, integration_identifier = @integration_identifier, date_first_aired = @date_first_aired, overview = @overview WHERE id = @id;`
	sqlUpdateEpisodic            = `UPDATE episodic SET title = @title, year = @year, date_added = @date_added, integration_id = @integration_id, filesystem_id = @filesystem_id, path = @path, genre = @genre, public_db_id = @public_db_id, date_updated = @date_updated, last_checked = @last_checked, is_active = @is_active, auto_update = @auto_update WHERE id = @id;`
	sqlUpdateEpisodicIntegration = `UPDATE episodic SET public_db_id = ? WHERE id = ?;`
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

	ids, eps, ret := []string{}, make(map[string]*types.Episodic, 0), []*types.Episodic{}

	err := sqlitex.Execute(
		conn,
		sqlGetEpisodics,
		&sqlitex.ExecOptions{
			ResultFunc: func(stmt *sqlite.Stmt) error {
				e, err := loadEpisodic(stmt)
				if err == nil {
					ids = append(ids, e.ID)
					eps[e.ID] = e
					ret = append(ret, e)
				}

				return err
			},
		},
	)

	mp, err := d.GetEpisodicsMeta(ctx, ids)
	if err != nil {
		return nil, err
	}

	for id, x := range mp {
		eps[id].Meta = x
	}

	return ret, err
}

func (d *Base) GetEpisodicsMeta(ctx context.Context, i []string) (map[string]*types.EpisodicMeta, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	eps := make(map[string]*types.EpisodicMeta, 0)
	err := sqlitex.Execute(
		conn,
		fmt.Sprintf(sqlEpisodicMeta, strings.Join(i, "', '")),
		&sqlitex.ExecOptions{
			ResultFunc: func(stmt *sqlite.Stmt) error {
				e := loadEpisodicMeta(stmt)
				id := stmt.GetText("id")

				eps[id] = e
				return nil
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

	res, err := d.GetEpisodicsMeta(ctx, []string{u})
	if err != nil {
		return nil, err
	}

	ep.Meta = res[ep.ID]
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

	sqlitex.Execute(
		conn,
		sqlRemoveAllEpisodes,
		&sqlitex.ExecOptions{
			Args: []interface{}{id},
		},
	)

	return sqlitex.Execute(conn, sqlRemoveEpisodic, &sqlitex.ExecOptions{Args: []interface{}{id}})
}

func (d *Base) GetEpisodeSearch(ctx context.Context, ep *types.Episode) (*types.Episode, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	sql := "SELECT * FROM episodic_episode WHERE "
	args, where := []any{ep.EpisodicID}, []string{"episodic_id = ?"}
	if ep.SeasonID >= 0 {
		args = append(args, ep.SeasonID)
		where = append(where, "season_id = ?")
	}
	if ep.EpisodeNumber != 0 {
		args = append(args, ep.EpisodeNumber)
		where = append(where, "episode_number = ?")
	}

	if len(args) != len(where) || len(args) != 3 {
		return nil, fmt.Errorf("Unable to determine episode details")
	}

	episode := &types.Episode{}
	err := sqlitex.Execute(
		conn,
		sql+strings.Join(where, " AND "),
		&sqlitex.ExecOptions{
			Args: args,
			ResultFunc: func(stmt *sqlite.Stmt) error {
				e, err := loadEpisode(stmt)
				episode = e
				return err
			},
		},
	)

	if episode.ID == "" {
		return nil, err
	}
	return episode, err
}

func (d *Base) MarkEpisodeWatched(ctx context.Context, id, episodeID string) error {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	return sqlitex.Execute(
		conn,
		sqlMarkEpisodeWatched,
		&sqlitex.ExecOptions{
			Args: []any{episodeID, id},
		},
	)
}

func (d *Base) MarkEpisodicSeasonWatched(ctx context.Context, id, season string) error {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	return sqlitex.Execute(
		conn,
		sqlMarkEpisodicSeasonWatched,
		&sqlitex.ExecOptions{
			Args: []any{season, id},
		},
	)
}

func (d *Base) StoreEpisode(ctx context.Context, ep *types.Episode) error {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	return sqlitex.Execute(
		conn,
		sqlInsertEpisode,
		&sqlitex.ExecOptions{
			Named: ep.Named(),
		},
	)
}

func (d *Base) UpdateEpisode(ctx context.Context, ep *types.Episode) error {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	named := ep.Named()
	delete(named, "@date_added")
	delete(named, "@episodic_id")

	var err error
	err = sqlitex.Execute(
		conn,
		sqlUpdateEpisode,
		&sqlitex.ExecOptions{
			Named: named,
			ResultFunc: func(stmt *sqlite.Stmt) error {
				_, er := loadEpisode(stmt)
				if er != nil {
					err = er
				}

				return er
			},
		},
	)

	return err
}

func (d *Base) UpdateEpisodicByID(ctx context.Context, ep *types.Episodic) error {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	var err error
	err = sqlitex.Execute(
		conn,
		sqlUpdateEpisodic,
		&sqlitex.ExecOptions{
			Named: ep.Named(),
			ResultFunc: func(stmt *sqlite.Stmt) error {
				_, er := loadEpisodic(stmt)
				if er != nil {
					err = er
				}

				return er
			},
		},
	)

	return err
}

func (d *Base) UpdateEpisodic(ctx context.Context, id string, ep *types.AddEpisodic) (*types.Episodic, error) {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	e, err := ep.Convert()
	if err != nil {
		return nil, err
	}

	episodic, err := d.GetEpisodicByID(ctx, id)
	if err != nil {
		d.log.With("error", err, "episodic_id", id, "episodic", episodic).Info("Unable to load Episodic")
	}

	named := e.Named()
	named["@id"] = id
	named["@date_added"] = episodic.DateAdded
	named["@date_updated"] = time.Now()
	if named["@title"] == "" {
		named["@title"] = episodic.Title
	}
	if named["@year"] == "" {
		named["@year"] = episodic.Year
	}
	if named["@genre"] == "" {
		named["@genre"] = episodic.Genre
	}
	if named["@public_db_id"] == "" {
		named["@public_db_id"] = episodic.PublicDBID
	}
	named["@is_active"] = episodic.IsActive

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

	mp, err := d.GetEpisodicsMeta(ctx, []string{id})
	if err != nil {
		return nil, err
	}

	episodic.Meta = mp[id]
	return episodic, err
}

func (d *Base) UpdateEpisodicIntegration(ctx context.Context, id, external string) error {
	conn := d.conn.Get(ctx)
	defer d.conn.Put(conn)

	err := sqlitex.Execute(
		conn,
		sqlUpdateEpisodicIntegration,
		&sqlitex.ExecOptions{
			Args: []interface{}{external, id},
			ResultFunc: func(stmt *sqlite.Stmt) error {
				return nil
			},
		},
	)

	return err
}
