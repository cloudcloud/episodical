package types

import (
	"fmt"
	"strings"
	"time"

	"github.com/cloudcloud/episodical/pkg/integrations/tvmaze"
	"github.com/segmentio/ksuid"
)

type AddEpisodic struct {
	Title string `json:"title"`
	Year  int    `json:"year"`

	Integration   string `json:"integration,omitempty"`
	FilesystemID  string `json:"filesystem,omitempty"`
	Path          string `json:"path,omitempty"`
	IntegrationID string `json:"integration_id,omitempty"`
}

type Episodic struct {
	Base
	Collection

	Title string `json:"title" db:"title"`
	Year  int    `json:"year" db:"year"`

	IsActive   bool   `json:"is_active" db:"is_active"`
	Genre      string `json:"genre" db:"genre"`
	PublicDBID string `json:"public_db_id" db:"public_db_id"`

	Episodes []*Episode    `json:"episodes" db:"-"`
	Meta     *EpisodicMeta `json:"meta"`
}

type EpisodicMeta struct {
	HasSpecials          bool      `json:"has_specials"`           // has_specials
	NextEpisodeDate      time.Time `json:"next_episode_date"`      // next_episode_date
	Seasons              string    `json:"seasons"`                // seasons
	TotalEpisodeFiles    int       `json:"total_episode_files"`    // total_episode_files
	TotalEpisodes        int       `json:"total_episodes"`         // total_episode_count
	TotalEpisodesWatched int       `json:"total_episodes_watched"` // total_episodes_watched
	TotalSpecialsCount   int       `json:"total_specials_count"`   // total_specials_count
}

type Episode struct {
	Base
	SubCollection

	EpisodicID string `json:"episodic_id" db:"episodic_id"`
	Title      string `json:"title" db:"title"`

	SeasonID      int `json:"season_id" db:"season_id"`
	EpisodeNumber int `json:"episode_number" db:"episode_number"`

	IsWatched   bool      `json:"is_watched" db:"is_watched"`
	DateWatched time.Time `json:"date_watched" db:"date_watched"`

	Overview string `json:"overview" db:"overview"`
}

type EpisodicAssociateIntegration struct {
	ExternalID string `json:"external"`
}

type Artistic struct {
	Base
	Collection

	Name          string `json:"name" db:"name"`
	OriginCountry string `json:"origin_country" db:"origin_country"`
}

type Album struct {
	Base
	SubCollection

	Title string `json:"title" db:"title"`
}

type Song struct {
	Base
	SubCollection

	Name string `json:"name" db:"name"`

	AlbumID       string `json:"album_id" db:"album_id"`
	AlbumPosition int    `json:"album_position" db:"album_position"`

	SongLength string `json:"song_length" db:"song_length"`
}

func (a AddEpisodic) Convert() (*Episodic, error) {
	e := &Episodic{}

	// generate uuid
	uid, err := ksuid.NewRandom()
	if err != nil {
		return e, err
	}
	e.ID = uid.String()
	e.DateAdded = time.Now()
	e.IntegrationID = a.Integration
	e.FilesystemID = a.FilesystemID
	e.Title = a.Title
	e.Year = a.Year
	e.Path = a.Path
	e.PublicDBID = a.IntegrationID

	return e, nil
}

func (e *Episode) Named() map[string]any {
	d := map[string]any{
		"@id":                     e.ID,
		"@episodic_id":            e.EpisodicID,
		"@title":                  e.Title,
		"@season_id":              e.SeasonID,
		"@episode_number":         e.EpisodeNumber,
		"@date_added":             e.DateAdded.Format(time.RFC3339),
		"@date_updated":           e.DateUpdated.Format(time.RFC3339),
		"@is_watched":             e.IsWatched,
		"@date_watched":           e.DateWatched.Format(time.RFC3339),
		"@file_entry":             e.FileEntry,
		"@integration_identifier": e.IntegrationIdentifier,
		"@date_first_aired":       e.DateReleased.Format(time.RFC3339),
		"@overview":               e.Overview,
	}

	return d
}

func (e *Episodic) Named() map[string]any {
	d := map[string]any{
		"@id":             e.ID,
		"@title":          e.Title,
		"@year":           e.Year,
		"@date_added":     e.DateAdded.Format(time.RFC3339),
		"@integration_id": e.IntegrationID,
		"@filesystem_id":  e.FilesystemID,
		"@path":           e.Path,
		"@genre":          e.Genre,
		"@public_db_id":   e.PublicDBID,
		"@date_updated":   e.DateUpdated.Format(time.RFC3339),
		"@last_checked":   e.LastChecked,
	}

	if e.IsActive {
		d["@is_active"] = 1
	} else {
		d["@is_active"] = 0
	}
	if e.AutoUpdate {
		d["@auto_update"] = 1
	} else {
		d["@auto_update"] = 0
	}

	return d
}

func (e *Episodic) ProvisionEpisode(f *File) ([]*Episode, error) {
	eps := []*Episode{}
	for x := 0; x < f.FoundCount(); x++ {
		ep := &Episode{}

		uid, err := ksuid.NewRandom()
		if err != nil {
			return nil, err
		}
		ep.ID = uid.String()

		ep.DateAdded = time.Now()
		ep.EpisodicID = e.ID
		ep.FileEntry = f.Path

		n, err := f.GetToken(x, "Season")
		if err != nil {
			return nil, err
		}
		ep.SeasonID = n.(int)
		n, err = f.GetToken(x, "Episode")
		if err != nil {
			return nil, err
		}
		ep.EpisodeNumber = n.(int)

		eps = append(eps, ep)
	}

	return eps, nil
}

func (e *Episodic) ProvisionFromTVMaze(s tvmaze.Episode) (*Episode, error) {
	ep := &Episode{}

	uid, err := ksuid.NewRandom()
	if err != nil {
		return nil, err
	}
	ep.ID = uid.String()
	ep.DateAdded = time.Now()
	ep.EpisodicID = e.ID

	ep.SeasonID = s.Season
	ep.EpisodeNumber = s.Number
	ep.Title = s.Name
	ep.Overview = s.Summary
	ep.IntegrationIdentifier = fmt.Sprintf("%d", s.ID)

	t, _ := time.Parse("2006-01-02T15:04:05", strings.TrimSuffix(s.AirStamp, "+00:00"))
	ep.DateReleased = t

	return ep, nil
}
