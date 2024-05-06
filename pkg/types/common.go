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
