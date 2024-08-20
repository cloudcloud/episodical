package types

// SearchEntry is the data structure used to provide results when searching
// for an integration episodic reference back to the UI.
type SearchEntry struct {
	Title       string `json:"title"`
	ReleaseYear int    `json:"release_year"`
	ID          int    `json:"id"`
}

//
