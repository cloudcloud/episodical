package types

import "time"

type AddFilesystem struct {
	Check bool   `json:"check"`
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
