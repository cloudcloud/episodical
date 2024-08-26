package data

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"
)

func TestLoadEpisode(t *testing.T) {
	a := assert.New(t)
	ctrl := gomock.NewController(t)
	stmt := NewMockStmt(ctrl)

	i := map[string]string{
		"date_added":             time.RFC3339,
		"date_updated":           time.RFC3339,
		"date_first_aired":       time.RFC3339,
		"date_watched":           time.RFC3339,
		"id":                     "id",
		"file_entry":             "",
		"integration_identifier": "",
		"episodic_id":            "",
		"title":                  "title",
		"overview":               "overview",
	}
	for key, val := range i {
		stmt.EXPECT().GetText(gomock.Eq(key)).Return(val).Times(1)
	}

	stmt.EXPECT().GetInt64(gomock.Eq("season_id")).Return(int64(1)).Times(1)
	stmt.EXPECT().GetInt64(gomock.Eq("episode_number")).Return(int64(1)).Times(1)
	stmt.EXPECT().GetBool(gomock.Eq("is_watched")).Return(true).Times(1)

	a.NotPanics(func() {
		ep, err := loadEpisode(stmt)

		a.Nil(err, "No error should be generated from basic stmt")
		a.Equal(ep.Title, "title", "Title should match the returned value")
		a.Equal(ep.IsWatched, true, "IsWatched should be the returned value")
		a.Equal(ep.EpisodeNumber, 1, "EpisodeNumber should be the int of the returned value")
	})
}

func TestLoadEpisodic(t *testing.T) {
	a := assert.New(t)
	ctrl := gomock.NewController(t)
	stmt := NewMockStmt(ctrl)

	i := map[string]string{
		"date_added":     time.RFC3339,
		"date_updated":   time.RFC3339,
		"last_checked":   time.RFC3339,
		"id":             "id",
		"integration_id": "integration",
		"filesystem_id":  "filesystem",
		"path":           "",
		"title":          "title",
		"genre":          "horror",
		"public_db_id":   "id",
	}
	for key, val := range i {
		stmt.EXPECT().GetText(gomock.Eq(key)).Return(val).Times(1)
	}

	stmt.EXPECT().GetBool(gomock.Eq("auto_update")).Return(true).Times(1)
	stmt.EXPECT().GetBool(gomock.Eq("is_active")).Return(true).Times(1)
	stmt.EXPECT().GetInt64(gomock.Eq("year")).Return(int64(2000)).Times(1)

	a.NotPanics(func() {
		ep, err := loadEpisodic(stmt)

		a.Nil(err, "No error should be generated from loadEpisodic()")
		a.Equal(ep.ID, "id", "ID should match the returned value")
	})
}

func TestLoadEpisodicMeta(t *testing.T) {
	a := assert.New(t)
	ctrl := gomock.NewController(t)
	stmt := NewMockStmt(ctrl)

	stmt.EXPECT().GetText(gomock.Eq("next_episode_date")).Return(time.RFC3339).Times(1)
	stmt.EXPECT().GetBool(gomock.Eq("has_specials")).Return(true).Times(1)
	stmt.EXPECT().GetText(gomock.Eq("seasons")).Return("").Times(1)
	stmt.EXPECT().GetInt64(gomock.Eq("total_episode_files")).Return(int64(1)).Times(1)
	stmt.EXPECT().GetInt64(gomock.Eq("total_episode_count")).Return(int64(1)).Times(1)
	stmt.EXPECT().GetInt64(gomock.Eq("total_episodes_watched")).Return(int64(1)).Times(1)
	stmt.EXPECT().GetInt64(gomock.Eq("total_specials_count")).Return(int64(3)).Times(1)

	a.NotPanics(func() {
		ep := loadEpisodicMeta(stmt)

		a.Equal(ep.HasSpecials, true, "HasSpecials should return the surfaced value")
		a.Equal(ep.TotalSpecialsCount, 3, "TotalSpecialsCount should provide the returned value")
	})
}

func TestLoadFilesystem(t *testing.T) {
	a := assert.New(t)
	ctrl := gomock.NewController(t)
	stmt := NewMockStmt(ctrl)

	stmt.EXPECT().GetText(gomock.Eq("last_checked")).Return(time.RFC3339).Times(1)
	stmt.EXPECT().GetText(gomock.Eq("id")).Return("id").Times(1)
	stmt.EXPECT().GetText(gomock.Eq("title")).Return("title").Times(1)
	stmt.EXPECT().GetText(gomock.Eq("base_path")).Return("").Times(1)
	stmt.EXPECT().GetBool(gomock.Eq("auto_update")).Return(true).Times(1)

	a.NotPanics(func() {
		ep, err := loadFilesystem(stmt)

		a.Nil(err, "No error should be generated from loadFilesystem()")
		a.Equal(ep.ID, "id", "ID should provide the returned value")
		a.Equal(ep.AutoUpdate, true, "AutoUpdate should provide the returned value")
	})
}

func TestLoadIntegration(t *testing.T) {
	a := assert.New(t)
	ctrl := gomock.NewController(t)
	stmt := NewMockStmt(ctrl)

	stmt.EXPECT().GetText(gomock.Eq("id")).Return("id").Times(1)
	stmt.EXPECT().GetText(gomock.Eq("title")).Return("title").Times(1)
	stmt.EXPECT().GetText(gomock.Eq("access_key")).Return("key").Times(1)
	stmt.EXPECT().GetText(gomock.Eq("base_model")).Return("").Times(1)
	stmt.EXPECT().GetText(gomock.Eq("collection_type")).Return("").Times(1)

	a.NotPanics(func() {
		ep, err := loadIntegration(stmt)

		a.Nil(err, "No error should be generated from loadIntegration()")
		a.Equal(ep.ID, "id", "ID should provide the returned value")
		a.Equal(ep.AccessKey, "key", "AccessKey should provide the returned value")
	})
}
