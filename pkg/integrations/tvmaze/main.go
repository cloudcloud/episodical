package tvmaze

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/cloudcloud/episodical/pkg/config"
)

const (
	urlBase = "https://api.tvmaze.com/"

	urlSearch   = "search/shows?q=%s"
	urlShow     = "shows/%s"
	urlEpisodes = "shows/%s/episodes?specials=1"
)

var (
	client *http.Client = nil
)

type QueryParams interface {
}

func Query(url string) ([]byte, error) {
	req, err := http.NewRequest(http.MethodGet, url, nil)
	if err != nil {
		log.Println(err.Error())
		return []byte{}, err
	}
	req.Header.Add("X-Client", fmt.Sprintf("cloudcloud/episodical %s", config.Version))

	if client == nil {
		client = http.DefaultClient
	}

	resp, err := client.Do(req)
	if err != nil {
		return []byte{}, err
	}

	return ioutil.ReadAll(resp.Body)
}
