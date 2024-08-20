package tvdb

import (
	"context"
	"strconv"
	"strings"
	"time"

	"github.com/cloudcloud/episodical/pkg/types"
	"github.com/segmentio/ksuid"
)

func (t *TVDB) generateEpisodic(r *Show, ep *types.Episodic) (*types.Episodic, error) {
	// go through and update the ep attributes
	ep.Title = r.Data.Name
	y, err := strconv.Atoi(r.Data.Year)
	if err != nil {
		return ep, err
	}
	ep.Year = y

	if r.Data.Status.Name == "Ended" {
		ep.IsActive = false
	}

	genres := []string{}
	for _, x := range r.Data.Genres {
		genres = append(genres, x.Name)
	}
	ep.Genre = strings.Join(genres, ", ")
	ep.DateUpdated = time.Now()

	return ep, nil
}

func (t *TVDB) generateEpisode(e *Episode) (*types.Episode, error) {
	ep := &types.Episode{
		Title:         e.Name,
		SeasonID:      e.SeasonNumber,
		EpisodeNumber: e.EpisodeNumber,
		IsWatched:     false,
		Overview:      e.Overview,
	}

	uid, err := ksuid.NewRandom()
	if err != nil {
		return nil, err
	}

	ep.ID = uid.String()
	ep.DateAdded = time.Now()
	ep.DateUpdated = ep.DateAdded

	return ep, nil
}

func (t *TVDB) TakeSeriesDetails(ctx context.Context, ep *types.Episodic, show *Show) (*types.Episodic, error) {
	var err error
	ep, err = t.generateEpisodic(show, ep)
	if err != nil {
		return ep, err
	}

	// push ep into db
	err = t.db.UpdateEpisodicByID(ctx, ep)
	if err != nil {
		return ep, err
	}

	for _, x := range show.Data.Episodes {
		e, err := t.generateEpisode(x)
		if err != nil {
			return nil, err
		}

		e.EpisodicID = ep.ID
		search, err := t.db.GetEpisodeSearch(ctx, e)
		if err != nil {
			return ep, err
		}

		if search != nil {
			e.ID = search.ID
			e.DateAdded = search.DateAdded
			e.DateUpdated = time.Now()
			e.IsWatched = search.IsWatched
			e.DateWatched = search.DateWatched
			e.FileEntry = search.FileEntry

			err = t.db.UpdateEpisode(ctx, e)
		} else {
			err = t.db.StoreEpisode(ctx, e)
		}

		if err != nil {
			return ep, err
		}
	}

	return ep, nil
}
