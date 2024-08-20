package types

import (
	"fmt"
	"regexp"
	"strconv"
	"time"

	"github.com/segmentio/ksuid"
)

var (
	matchesPatternSlim    = regexp.MustCompile(`.*S\d+E\d+.*\.[a-zA-Z0-9]+$`)
	pullPatternSlim       = regexp.MustCompile(`\d*E(\d+)`)
	pullPatternSlimShared = regexp.MustCompile(`.*S(\d+)E\d+.*\.([a-zA-Z0-9]+)$`)

	matchesPatternSpaced    = regexp.MustCompile(`.*\s+\d+x\d+\s+.*\.[a-zA-Z0-9]+$`)
	pullPatternSpaced       = regexp.MustCompile(`\s+\d+x(\d+)\s+`)
	pullPatternSpacedShared = regexp.MustCompile(`.*\s+(\d+)x\d+\s+.*\.([a-zA-Z0-9]+)$`)

	matchesPatternDots    = regexp.MustCompile(`.*\.\d+x\d+\.?.*\.[a-zA-Z0-9]+$`)
	pullPatternDots       = regexp.MustCompile(`[^.]x(\d+)|-(\d+)`)
	pullPatternDotsShared = regexp.MustCompile(`.*\.(\d+)x\d+\.?.*\.([a-zA-Z0-9]+)$`)
)

type AddFilesystem struct {
	Check bool   `json:"check,omitempty"`
	Path  string `json:"path"`
	Title string `json:"title"`
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

func TokeniseEpisodical(s string) (*File, error) {
	f := &File{Type: "episodical", Path: s, tokens: make([]map[string]any, 0)}

	var err error
	if matchesPatternSlim.MatchString(s) {
		err = f.findMatches(s, pullPatternSlimShared, pullPatternSlim)
	} else if matchesPatternSpaced.MatchString(s) {
		err = f.findMatches(s, pullPatternSpacedShared, pullPatternSpaced)
	} else if matchesPatternDots.MatchString(s) {
		err = f.findMatches(s, pullPatternDotsShared, pullPatternDots)
	}

	return f, err
}

func (f *File) findMatches(s string, common, episode *regexp.Regexp) error {
	matches := common.FindAllStringSubmatch(s, -1)

	season, _ := strconv.Atoi(matches[0][1])
	format := matches[0][2]

	matched := episode.FindAllStringSubmatch(s, -1)
	for _, x := range matched {
		ep, _ := strconv.Atoi(x[1])
		if ep == 0 && len(x) > 1 {
			ep, _ = strconv.Atoi(x[2])
		}

		f.tokens = append(f.tokens, map[string]any{
			"Season":  season,
			"Episode": ep,
			"Format":  format,
		})
	}

	return nil
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
