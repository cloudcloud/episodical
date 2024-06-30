package tvmaze

import (
	"encoding/json"
	"fmt"
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

func Search(t string) ([]SearchResult, error) {
	s := []SearchResult{}
	body, err := Query(urlBase + fmt.Sprintf(urlSearch, t))
	if err != nil {
		return s, err
	}

	err = json.Unmarshal(body, &s)
	return s, err
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
