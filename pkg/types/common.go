package types

import (
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
