package data

import (
	"time"

	"github.com/cloudcloud/episodical/pkg/types"
	"zombiezen.com/go/sqlite"
)

func loadEpisode(stmt *sqlite.Stmt) (*types.Episode, error) {
	ep := &types.Episode{}

	da, _ := time.Parse(time.RFC3339, stmt.ColumnText(5))
	du, _ := time.Parse(time.RFC3339, stmt.ColumnText(6))
	dr, _ := time.Parse(time.RFC3339, stmt.ColumnText(11))
	dw, _ := time.Parse(time.RFC3339, stmt.ColumnText(8))

	ep.ID = stmt.ColumnText(0)
	ep.DateAdded = da
	ep.DateUpdated = du

	ep.FileEntry = stmt.ColumnText(9)
	ep.IntegrationIdentifier = stmt.ColumnText(10)
	ep.DateReleased = dr

	ep.EpisodicID = stmt.ColumnText(1)
	ep.Title = stmt.ColumnText(2)
	ep.SeasonID = stmt.ColumnInt(3)
	ep.EpisodeNumber = stmt.ColumnInt(4)
	ep.IsWatched = (stmt.ColumnInt(7) == 1)
	ep.DateWatched = dw
	ep.Overview = stmt.ColumnText(12)

	return ep, nil
}

func loadEpisodic(stmt *sqlite.Stmt) (*types.Episodic, error) {
	ep := &types.Episodic{
		Episodes: []*types.Episode{},
	}

	da, _ := time.Parse(time.RFC3339, stmt.ColumnText(3))
	du, _ := time.Parse(time.RFC3339, stmt.ColumnText(4))
	dc, _ := time.Parse(time.RFC3339, stmt.ColumnText(11))

	ep.ID = stmt.ColumnText(0)
	ep.DateAdded = da
	ep.DateUpdated = du

	ep.IntegrationUsed = stmt.ColumnText(5)
	ep.FileSystemID = stmt.ColumnText(6)
	ep.PathID = stmt.ColumnText(7)
	ep.LastChecked = dc
	ep.AutoUpdate = (stmt.ColumnInt(12) == 1)

	ep.Title = stmt.ColumnText(1)
	ep.Year = stmt.ColumnInt(2)
	ep.IsActive = (stmt.ColumnInt(8) == 1)
	ep.Genre = stmt.ColumnText(9)
	ep.PublicDBID = stmt.ColumnText(10)

	return ep, nil
}
