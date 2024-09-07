package tvdb

import (
	"net/http"
	"time"

	"github.com/cloudcloud/episodical/pkg/data"
	"github.com/cloudcloud/episodical/pkg/types"
	"go.uber.org/zap"
)

type SearchEntry struct {
	ID           string `json:"tvdb_id"`
	Title        string `json:"name"`
	FirstAirTime string `json:"first_air_time"`
	Overview     string `json:"overview"`
	Status       string `json:"status"`
	Year         string `json:"year"`
	Network      string `json:"network"`
	RemoteIDs    []struct {
		ID     string `json:"id"`
		Type   int    `json:"type"`
		Source string `json:"sourceName"`
	} `json:"remote_ids"`
	Thumbnail string `json:"thumbnail"`

	firstAirTime time.Time `json:"-"`
}

type SearchResult struct {
	Data []SearchEntry `json:"data"`
}

type TVDB struct {
	ID          string
	Integration *types.Integration
	Token       *types.Token

	client *http.Client
	db     *data.Base
	log    *zap.SugaredLogger
}

type Opts struct {
	DB          *data.Base
	ID          string
	Log         *zap.SugaredLogger
	Integration *types.Integration
}

type Show struct {
	Status string `json:"status"`
	Data   Data   `json:"data"`
}

type Data struct {
	ID         int         `json:"id"`
	Name       string      `json:"name"`
	Image      string      `json:"image"`
	FirstAired string      `json:"firstAired"`
	LastAired  string      `json:"lastAired"`
	Overview   string      `json:"overview"`
	Year       string      `json:"year"`
	Status     *Status     `json:"status"`
	Episodes   []*Episode  `json:"episodes"`
	Genres     []*Genre    `json:"genres"`
	RemoteIDs  []*RemoteID `json:"remoteIds"`
}

type Status struct {
	ID         int    `json:"id"`
	Name       string `json:"name"`
	RecordType string `json:"recordType"`
}

type Episode struct {
	ID            int    `json:"id"`
	SeriesID      int    `json:"seriesId"`
	Name          string `json:"name"`
	Aired         string `json:"aired"`
	Overview      string `json:"overview"`
	EpisodeNumber int    `json:"number"`
	SeasonNumber  int    `json:"seasonNumber"`
}

type Genre struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type RemoteID struct {
	ID   string `json:"id"`
	Type int    `json:"type"`
	Name string `json:"sourceName"`
}
