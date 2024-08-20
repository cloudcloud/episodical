package tvmaze

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/cloudcloud/episodical/pkg/types"
	"github.com/segmentio/ksuid"
)

type Externals struct {
	IMDB    string `json:"imdb"`
	TheTVDB int    `json:"thetvdb"`
}

type Network struct {
	Name string `json:"name"`
}

type Schedule struct {
	Time string   `json:"time"`
	Days []string `json:"days"`
}

type SearchResult struct {
	Show Show `json:"show"`
}

type Show struct {
	ShowID         int       `json:"id"`
	URL            string    `json:"url"`
	Name           string    `json:"name"`
	Genres         []string  `json:"genres"`
	Status         string    `json:"status"`
	DateFirstAired string    `json:"premiered"`
	Schedule       Schedule  `json:"schedule"`
	Network        Network   `json:"network"`
	Externals      Externals `json:"externals"`
	Summary        string    `json:"summary"`
}

type Episode struct {
	ID       int    `json:"id"`
	Name     string `json:"name"`
	Season   int    `json:"season"`
	Number   int    `json:"number"`
	AirStamp string `json:"airstamp"`
	Summary  string `json:"summary"`
}

func ProvisionEpisode(e Episode) (*types.Episode, error) {
	ep := &types.Episode{}

	uid, err := ksuid.NewRandom()
	if err != nil {
		return nil, err
	}
	ep.ID = uid.String()
	ep.DateAdded = time.Now()
	ep.EpisodicID = fmt.Sprintf("%d", e.ID)

	ep.SeasonID = e.Season
	ep.EpisodeNumber = e.Number
	ep.Title = e.Name
	ep.Overview = e.Summary
	ep.IntegrationIdentifier = fmt.Sprintf("%d", e.ID)

	t, _ := time.Parse("2006-01-02T15:04:05", strings.TrimSuffix(e.AirStamp, "+00:00"))
	ep.DateReleased = t

	return ep, nil
}

func Search(t string) ([]types.SearchEntry, error) {
	s := []SearchResult{}
	body, err := Query(urlBase + fmt.Sprintf(urlSearch, t))
	if err != nil {
		return nil, err
	}

	err = json.Unmarshal(body, &s)
	if err != nil {
		return nil, err
	}

	res := []types.SearchEntry{}
	for _, x := range s {
		year, _ := strconv.Atoi(strings.Split(x.Show.DateFirstAired, "-")[0])
		res = append(res, types.SearchEntry{Title: x.Show.Name, ReleaseYear: year, ID: x.Show.ShowID})
	}
	return res, err
}

func GetShow(id string) (Show, error) {
	s := Show{}
	body, err := Query(urlBase + fmt.Sprintf(urlShow, id))
	if err != nil {
		return s, err
	}

	err = json.Unmarshal(body, &s)
	return s, err
}

func GetShowEpisodes(id string) ([]Episode, error) {
	e := []Episode{}
	body, err := Query(urlBase + fmt.Sprintf(urlEpisodes, id))
	if err != nil {
		return e, err
	}

	err = json.Unmarshal(body, &e)
	return e, err
}
