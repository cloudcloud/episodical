package types

import "time"

// Base contains shared details across the full collection spectrum.
type Base struct {
	ID string `json:"id" db:"id"`

	DateAdded   time.Time `json:"date_added" db:"date_added"`
	DateUpdated time.Time `json:"date_updated" db:"date_updated"`

	LastChecked time.Time `json:"last_checked" db:"last_checked"`
	AutoUpdate  bool      `json:"auto_update" db:"auto_update"`
}

// Collection contains shared attributes across each main collection type.
type Collection struct {
	IntegrationUsed bool `json:"integration_used" db:"integration_used"`

	FileSystem bool   `json:"file_system" db:"file_system"`
	PathID     string `json:"path_id" db:"path_id"`
}

// SubCollection contains shared attributes across the sub-types within a collection.
type SubCollection struct {
	FileEntry             string `json:"file_entry" db:"file_entry"`
	IntegrationIdentifier string `json:"integration_identifier" db:"integration_identifier"`

	DateReleased time.Time `json:"date_released" db:"date_released"`
}

//
