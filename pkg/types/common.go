package types

import (
	"time"

	"github.com/segmentio/ksuid"
)

type AddIntegration struct {
	Key   string `json:"key"`
	Model string `json:"model"`
	Title string `json:"title"`
	Type  string `json:"type"`
}

type Integration struct {
	ID             string `json:"id"`
	Title          string `json:"title"`
	AccessKey      string `json:"access_key"`
	BaseModel      string `json:"base_model"`
	CollectionType string `json:"collection_type"`
}

type Token struct {
	ID            string    `json:"id"`
	IntegrationID string    `json:"integration_id"`
	IsValid       bool      `json:"is_valid"`
	Value         string    `json:"value"`
	DateAdded     time.Time `json:"date_added"`
	DateExpires   time.Time `json:"date_expires"`
}

type TVDBLoginResult struct {
	Data struct {
		Token string `json:"token"`
	} `json:"data"`
	Status string `json:"status"`
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

func (t *TVDBLoginResult) Convert() (*Token, error) {
	k := &Token{
		IntegrationID: "",
		IsValid:       true,
		Value:         t.Data.Token,
		DateAdded:     time.Now(),
		DateExpires:   time.Now().Add(time.Duration(24*29) * time.Hour),
	}

	uid, err := ksuid.NewRandom()
	if err != nil {
		return k, err
	}
	k.ID = uid.String()

	return k, nil
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

func (t *Token) Named() map[string]any {
	d := map[string]any{
		"@id":             t.ID,
		"@integration_id": t.IntegrationID,
		"@date_added":     t.DateAdded.Format(time.RFC3339),
		"@date_expires":   t.DateExpires.Format(time.RFC3339),
		"@value":          t.Value,
	}

	d["@is_valid"] = 0
	if t.IsValid {
		d["@is_valid"] = 1
	}

	return d
}
