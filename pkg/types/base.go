package types

import "time"

// Base contains shared details across the full collection spectrum.
type Base struct {
	ID string `json:"id" db:"id"`

	DateAdded   time.Time `json:"date_added" db:"date_added"`
	DateUpdated time.Time `json:"date_updated" db:"date_updated"`
}

// Collection contains shared attributes across each main collection type.
type Collection struct {
	IntegrationUsed string `json:"integration_used" db:"integration_used"`

	FileSystemID string `json:"file_system_id" db:"file_system_id"`
	PathID       string `json:"path_id" db:"path_id"`

	LastChecked time.Time `json:"last_checked" db:"last_checked"`
	AutoUpdate  bool      `json:"auto_update" db:"auto_update"`
}

// SubCollection contains shared attributes across the sub-types within a collection.
type SubCollection struct {
	FileEntry             string `json:"file_entry" db:"file_entry"`
	IntegrationIdentifier string `json:"integration_identifier" db:"integration_identifier"`

	DateReleased time.Time `json:"date_released" db:"date_released"`
}

//
