package types

import (
	"fmt"
	"regexp"
	"strconv"
	"time"

	"github.com/segmentio/ksuid"
)

type AddFilesystem struct {
	Check bool   `json:"check,omitempty"`
	Path  string `json:"path"`
	Title string `json:"title"`
}

type AddIntegration struct {
	Key   string `json:"key"`
	Model string `json:"model"`
	Title string `json:"title"`
	Type  string `json:"type"`
}

type Filesystem struct {
	ID          string    `json:"id"`
	Title       string    `json:"title"`
	BasePath    string    `json:"base_path"`
	AutoUpdate  bool      `json:"auto_update"`
	LastChecked time.Time `json:"last_checked"`
}

type File struct {
	Type string
	Path string

	tokens []map[string]any
}

type Integration struct {
	ID             string `json:"id"`
	Title          string `json:"title"`
	AccessKey      string `json:"access_key"`
	BaseModel      string `json:"base_model"`
	CollectionType string `json:"collection_type"`
}

func (f *AddFilesystem) Convert() (*Filesystem, error) {
	n := &Filesystem{
		Title:      f.Title,
		BasePath:   f.Path,
		AutoUpdate: f.Check,
	}

	uid, err := ksuid.NewRandom()
	if err != nil {
		return n, err
	}
	n.ID = uid.String()

	return n, nil
}

func (f *Filesystem) Named() map[string]any {
	d := map[string]any{
		"@id":           f.ID,
		"@title":        f.Title,
		"@base_path":    f.BasePath,
		"@last_checked": f.LastChecked,
	}

	if f.AutoUpdate {
		d["@auto_update"] = 1
	} else {
		d["@auto_update"] = 0
	}

	return d
}

func (i *AddIntegration) Convert() (*Integration, error) {
	n := &Integration{
		Title:          i.Title,
		AccessKey:      i.Key,
		BaseModel:      i.Model,
		CollectionType: i.Type,
	}

	uid, err := ksuid.NewRandom()
	if err != nil {
		return n, err
	}
	n.ID = uid.String()

	return n, nil
}

func (i *Integration) Named() map[string]any {
	d := map[string]any{
		"@id":              i.ID,
		"@title":           i.Title,
		"@access_key":      i.AccessKey,
		"@base_model":      i.BaseModel,
		"@collection_type": i.CollectionType,
	}

	return d
}

var (
	matchesPatternSlim    = regexp.MustCompile(`.*S\d+E\d+.*\.[a-zA-Z0-9]+$`)
	pullPatternSlim       = regexp.MustCompile(`\d*E(\d+)`)
	pullPatternSlimShared = regexp.MustCompile(`.*S(\d+)E\d+.*\.([a-zA-Z0-9]+)$`)
)

func TokeniseEpisodical(s string) (*File, error) {
	f := &File{Type: "episodical", Path: s, tokens: make([]map[string]any, 0)}

	// TODO: Support other formats as required.
	if matchesPatternSlim.MatchString(s) {
		matches := pullPatternSlimShared.FindAllStringSubmatch(s, -1)
		if len(matches) < 1 || len(matches[0]) != 3 {
			return nil, fmt.Errorf("Could not find a Episodical match for '%s'", s)
		}
		season, _ := strconv.Atoi(matches[0][1])
		format := matches[0][2]

		// now pull out the episodes
		matched := pullPatternSlim.FindAllStringSubmatch(s, -1)
		for _, x := range matched {
			ep, _ := strconv.Atoi(x[1])

			f.tokens = append(f.tokens, map[string]any{
				"Season":  season,
				"Episode": ep,
				"Format":  format,
			})
		}
	}

	return f, nil
}

func (f *File) FoundCount() int {
	return len(f.tokens)
}

func (f *File) GetToken(idx int, n string) (any, error) {
	if idx >= f.FoundCount() {
		return nil, fmt.Errorf("idx out of range of episode numbers found")
	}
	if _, ok := f.tokens[idx][n]; !ok {
		return nil, fmt.Errorf("Unable to find token '%s'", n)
	}

	return f.tokens[idx][n], nil
}
