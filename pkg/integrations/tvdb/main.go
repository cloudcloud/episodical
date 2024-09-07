package tvdb

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"strconv"

	"github.com/cloudcloud/episodical/pkg/config"
	"github.com/cloudcloud/episodical/pkg/types"
)

const (
	urlBase = "https://api4.thetvdb.com/v4/"
)

func New(o Opts, ctx context.Context) (*TVDB, error) {
	tv := &TVDB{db: o.DB, log: o.Log, client: http.DefaultClient}
	if o.Integration != nil {
		tv.ID = o.Integration.ID
		tv.Integration = o.Integration
	} else {
		// get the integration detail from the DB
		i, err := tv.db.GetIntegrationByID(context.Background(), o.ID)
		if err != nil {
			return nil, err
		}
		tv.Integration = i
	}

	// check for an existing valid token
	tok, err := tv.withValidToken(ctx)
	if err != nil && tok == nil {
		return tv, err
	}

	if tok == nil || !tok.IsValid {
		// login and store the token
		tok, err = tv.login(ctx)
		if err != nil {
			return nil, err
		}
	}
	tv.Token = tok

	return tv, nil
}

func (t *TVDB) Search(ep *types.Episodic) ([]types.SearchEntry, error) {
	query := fmt.Sprintf("search?type=series&query=%s&year=%d", url.QueryEscape(ep.Title), ep.Year)

	res, err := t.queryGet(query, true)
	if err != nil {
		return nil, err
	}

	s := &SearchResult{}
	err = json.Unmarshal(res, s)
	if err != nil {
		return nil, err
	}

	entries := []types.SearchEntry{}
	for _, x := range s.Data {
		year, _ := strconv.Atoi(x.Year)
		id, _ := strconv.Atoi(x.ID)
		entries = append(entries, types.SearchEntry{Title: x.Title, ReleaseYear: year, ID: id})
	}

	return entries, nil
}

func (t *TVDB) GetShow(id int) (*Show, error) {
	query := fmt.Sprintf("series/%d/extended?meta=episodes&short=true", id)

	res, err := t.queryGet(query, true)
	if err != nil {
		return nil, err
	}

	s := &Show{}
	err = json.Unmarshal(res, s)
	return s, err
}

func (t *TVDB) withValidToken(ctx context.Context) (*types.Token, error) {
	tok, err := t.db.GetLatestToken(ctx, t.Integration.ID)
	if err != nil {
		return nil, err
	}

	if tok != nil && tok.IsValid {
		t.Token = tok
		return tok, nil
	}

	return tok, err
}

func (t *TVDB) login(ctx context.Context) (*types.Token, error) {
	b := bytes.NewBuffer([]byte(fmt.Sprintf(`{"apikey":"%s"}`, t.Integration.AccessKey)))

	res, err := t.queryPost("login", b, false)
	if err != nil {
		return nil, err
	}

	tok := &types.TVDBLoginResult{}
	err = json.Unmarshal(res, tok)
	if err != nil {
		return nil, err
	}

	token, err := tok.Convert()
	if err != nil {
		return nil, err
	}
	token.IntegrationID = t.Integration.ID

	// store the token
	token, err = t.db.StoreLatestToken(ctx, token)
	return token, err
}

func (t *TVDB) queryPost(url string, data *bytes.Buffer, useAuth bool) ([]byte, error) {
	return t.q(http.MethodPost, fmt.Sprintf("%s%s", urlBase, url), data, useAuth)
}

func (t *TVDB) queryGet(url string, useAuth bool) ([]byte, error) {
	return t.q(http.MethodGet, fmt.Sprintf("%s%s", urlBase, url), nil, useAuth)
}

func (t *TVDB) q(method, url string, data *bytes.Buffer, useAuth bool) ([]byte, error) {
	var err error
	req := &http.Request{}
	if data == nil {
		req, err = http.NewRequest(method, url, nil)
	} else {
		req, err = http.NewRequest(method, url, data)
	}

	if err != nil {
		return []byte{}, err
	}

	req.Header.Add("X-Client", fmt.Sprintf("cloudcloud/episodical %s", config.Version))
	req.Header.Add("Accept", "application/json")
	if useAuth {
		req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", t.Token.Value))
	}
	if data != nil {
		req.Header.Add("Content-Type", "application/json")
	}

	resp, err := t.client.Do(req)
	if err != nil {
		return []byte{}, err
	}

	return ioutil.ReadAll(resp.Body)
}
