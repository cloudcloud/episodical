package data

import (
	"time"

	"github.com/cloudcloud/episodical/pkg/types"
)

func loadEpisode(stmt types.Stmt) (*types.Episode, error) {
	ep := &types.Episode{}

	da, _ := time.Parse(time.RFC3339, stmt.GetText("date_added"))
	du, _ := time.Parse(time.RFC3339, stmt.GetText("date_updated"))
	dr, _ := time.Parse(time.RFC3339, stmt.GetText("date_first_aired"))
	dw, _ := time.Parse(time.RFC3339, stmt.GetText("date_watched"))

	ep.ID = stmt.GetText("id")
	ep.DateAdded = da
	ep.DateUpdated = du

	ep.FileEntry = stmt.GetText("file_entry")
	ep.IntegrationIdentifier = stmt.GetText("integration_identifier")
	ep.DateReleased = dr

	ep.EpisodicID = stmt.GetText("episodic_id")
	ep.Title = stmt.GetText("title")
	ep.SeasonID = int(stmt.GetInt64("season_id"))
	ep.EpisodeNumber = int(stmt.GetInt64("episode_number"))
	ep.IsWatched = stmt.GetBool("is_watched")
	ep.DateWatched = dw
	ep.Overview = stmt.GetText("overview")

	return ep, nil
}

func loadEpisodic(stmt types.Stmt) (*types.Episodic, error) {
	ep := &types.Episodic{
		Episodes: []*types.Episode{},
	}

	da, _ := time.Parse(time.RFC3339, stmt.GetText("date_added"))
	du, _ := time.Parse(time.RFC3339, stmt.GetText("date_updated"))
	dc, _ := time.Parse(time.RFC3339, stmt.GetText("last_checked"))

	ep.ID = stmt.GetText("id")
	ep.DateAdded = da
	ep.DateUpdated = du

	ep.IntegrationID = stmt.GetText("integration_id")
	ep.FilesystemID = stmt.GetText("filesystem_id")
	ep.Path = stmt.GetText("path")
	ep.LastChecked = dc
	ep.AutoUpdate = stmt.GetBool("auto_update")

	ep.Title = stmt.GetText("title")
	ep.Year = int(stmt.GetInt64("year"))
	ep.IsActive = stmt.GetBool("is_active")
	ep.Genre = stmt.GetText("genre")
	ep.PublicDBID = stmt.GetText("public_db_id")

	return ep, nil
}

func loadEpisodicMeta(stmt types.Stmt) *types.EpisodicMeta {
	dn, _ := time.Parse(time.RFC3339, stmt.GetText("next_episode_date"))

	return &types.EpisodicMeta{
		HasSpecials:          stmt.GetBool("has_specials"),
		NextEpisodeDate:      dn,
		Seasons:              stmt.GetText("seasons"),
		TotalEpisodeFiles:    int(stmt.GetInt64("total_episode_files")),
		TotalEpisodes:        int(stmt.GetInt64("total_episode_count")),
		TotalEpisodesWatched: int(stmt.GetInt64("total_episodes_watched")),
		TotalSpecialsCount:   int(stmt.GetInt64("total_specials_count")),
	}
}

func loadFilesystem(stmt types.Stmt) (types.Filesystem, error) {
	lc, _ := time.Parse(time.RFC3339, stmt.GetText("last_checked"))

	return types.Filesystem{
		ID:          stmt.GetText("id"),
		Title:       stmt.GetText("title"),
		BasePath:    stmt.GetText("base_path"),
		AutoUpdate:  stmt.GetBool("auto_update"),
		LastChecked: lc,
	}, nil
}

func loadIntegration(stmt types.Stmt) (types.Integration, error) {
	return types.Integration{
		ID:             stmt.GetText("id"),
		Title:          stmt.GetText("title"),
		AccessKey:      stmt.GetText("access_key"),
		BaseModel:      stmt.GetText("base_model"),
		CollectionType: stmt.GetText("collection_type"),
	}, nil
}

func loadToken(stmt types.Stmt) (types.Token, error) {
	da, _ := time.Parse(time.RFC3339, stmt.GetText("date_added"))
	de, _ := time.Parse(time.RFC3339, stmt.GetText("date_expires"))

	return types.Token{
		ID:            stmt.GetText("id"),
		IntegrationID: stmt.GetText("integration_id"),
		IsValid:       stmt.GetBool("is_valid"),
		DateAdded:     da,
		DateExpires:   de,
	}, nil
}
