package types

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestConvert(t *testing.T) {
	assert := assert.New(t)

	input := AddEpisodic{
		Title: "Hi",
		Year:  2003,
	}

	expect := &Episodic{
		Title: "Hi",
		Year:  2003,
	}

	out, err := input.Convert()

	assert.Nil(err)
	assert.NotEmpty(out.ID)
	assert.Equal(expect.Title, out.Title)
	assert.Equal(expect.Year, out.Year)
	assert.GreaterOrEqual(time.Now(), out.DateAdded)
}

func TestNamedEpisode(t *testing.T) {
	assert := assert.New(t)

	input := &Episode{
		Title:      "title",
		EpisodicID: "ep_id",
		SeasonID:   2,
	}
	input.ID = "id"

	out := input.Named()

	assert.Equal(input.ID, out["@id"])
	assert.Equal(input.Title, out["@title"])
	assert.Equal(input.EpisodicID, out["@episodic_id"])
	assert.Equal(input.SeasonID, out["@season_id"])
}

func TestNamedEpisodic(t *testing.T) {
	assert := assert.New(t)

	cases := []struct {
		In         *Episodic
		Active     int
		AutoUpdate int
	}{
		{
			In: &Episodic{
				Collection: Collection{
					AutoUpdate: true,
				},
				IsActive: true,
				Title:    "title",
			},
			Active:     1,
			AutoUpdate: 1,
		},
		{
			In: &Episodic{
				Collection: Collection{
					AutoUpdate: false,
				},
				IsActive: false,
				Title:    "alt",
			},
			Active:     0,
			AutoUpdate: 0,
		},
	}

	for _, x := range cases {
		out := x.In.Named()

		assert.Equal(x.AutoUpdate, out["@auto_update"])
		assert.Equal(x.Active, out["@is_active"])
		assert.Equal(x.In.Title, out["@title"])
	}
}

func TestProvisionEpisode(t *testing.T) {
	assert := assert.New(t)

	ep := &Episodic{}
	cases := []struct {
		F     *File
		Count int
		Er    bool
	}{
		{
			F:     &File{},
			Count: 0,
			Er:    false,
		},
		{
			F: &File{
				Path: "/",
				tokens: []map[string]any{
					map[string]any{
						"Season":  1,
						"Episode": 1,
					},
				},
			},
			Count: 1,
			Er:    false,
		},
		{
			F: &File{
				Path: "/",
				tokens: []map[string]any{
					map[string]any{
						"Episode": 1,
					},
				},
			},
			Count: 0,
			Er:    true,
		},
		{
			F: &File{
				Path: "/",
				tokens: []map[string]any{
					map[string]any{
						"Season": 1,
					},
				},
			},
			Count: 0,
			Er:    true,
		},
	}

	for _, x := range cases {
		out, err := ep.ProvisionEpisode(x.F)

		if x.Er {
			assert.NotNil(err)
		} else {
			assert.Nil(err)
		}
		assert.Equal(x.Count, len(out))
	}
}
