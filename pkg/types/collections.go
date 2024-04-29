package types

import "time"

type AddEpisodic struct {
	Title string `json:"title"`
	Year  int    `json:"year"`

	UseIntegration bool   `json:"use_integration"`
	IntegrationID  string `json:"integration_id,omitempty"`

	UseFileSystem bool   `json:"use_file_system"`
	FileSystemID  string `json:"file_system_id,omitempty"`
}

type Episodic struct {
	Base
	Collection

	Title string `json:"title" db:"title"`
	Year  int    `json:"year" db:"year"`

	IsActive   bool   `json:"is_active" db:"is_active"`
	Genre      string `json:"genre" db:"genre"`
	PublicDBID string `json:"public_db_id" db:"public_db_id"`

	Episodes []*Episode `json:"episode" db:"-"`
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

	return e, nil
}

func (e *Episodic) Named() map[string]any {
	return map[string]any{}
}
