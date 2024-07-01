package process

import (
	"strings"
	"time"

	"github.com/cloudcloud/episodical/pkg/data"
	"github.com/cloudcloud/episodical/pkg/filesystem"
	"github.com/cloudcloud/episodical/pkg/integrations/tvmaze"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func BackgroundEpisodicProcess(ctx *gin.Context) {
	db := ctx.MustGet("db").(*data.Base)
	id := ctx.Param("id")
	log := ctx.MustGet("log").(*zap.SugaredLogger)

	ep, err := db.GetEpisodicByID(ctx, id)
	if err != nil {
		log.With("error", err).Info("Unable to retrieve Episodic for processing")
		return
	}

	// pull in the filesystem details
	if ep.FilesystemID != "" {
		f, err := db.GetFilesystemByID(ctx, ep.FilesystemID)
		if err != nil {
			log.With("error", err).Error("Unable to retrieve the filesystem associated with the Episodic")
			return
		}

		fs := filesystem.Load(f, db, log)
		_, err = fs.Gather(ep, "episodical")
		if err != nil {
			log.With("error", err).Error("Failed to Gather from the filesystem")
		}
	}

	// pull in the integration details
	if ep.PublicDBID != "" {
		integ, err := db.GetIntegrationByID(ctx, ep.IntegrationID)
		if err != nil {
			log.With("error", err).Error("Unable to retrieve the integration associated with the Episodic")
			return
		}

		switch integ.BaseModel {
		case "tvmaze":
			// get the show itself and update what's needed
			show, err := tvmaze.GetShow(ep.PublicDBID)
			if err != nil {
				log.With("error", err, "id", ep.ID, "show", show, "public_db_id", ep.PublicDBID).Error("Unable to get Show details from tvmaze")
				return
			}

			t, err := time.Parse("2006-01-02", show.DateFirstAired)
			if err == nil {
				ep.Year = t.Year()
			}
			ep.IsActive = (show.Status != "Ended")
			ep.Genre = strings.Join(show.Genres, ", ")
			ep.LastChecked = time.Now()

			err = db.UpdateEpisodicByID(ctx, ep)
			if err != nil {
				log.With("error", err, "id", ep.ID).Error("Unable to update Episodic with Show details")
				return
			}

			// get the episodes and store them
			episodes, err := tvmaze.GetShowEpisodes(ep.PublicDBID)
			if err != nil {
				log.With("error", err, "id", ep.ID, "public_db_id", ep.PublicDBID).Error("Unable to load Episodes for Show from tvmaze")
				return
			}

			for _, e := range episodes {
				episode, err := ep.ProvisionFromTVMaze(e)
				if err != nil {
					log.With("error", err).Error("Couldn't provision from TVMaze")
					continue
				}

				orig, err := db.GetEpisodeSearch(ctx, episode)
				if err != nil {
					log.With("error", err).Error("Error when searching for Episode")
				}

				if orig != nil {
					episode.ID = orig.ID
					episode.DateAdded = orig.DateAdded
					episode.DateUpdated = time.Now()
					episode.IsWatched = orig.IsWatched
					episode.DateWatched = orig.DateWatched
					episode.FileEntry = orig.FileEntry

					err = db.UpdateEpisode(ctx, episode)
				} else {
					err = db.StoreEpisode(ctx, episode)
				}

				if err != nil {
					log.With("error", err, "episodic_id", episode.EpisodicID).Error("Unable to store Episode")
				}
			}

		case "thetvdb":

		}
	}

	log.With("episodic_id", ep.ID).Info("Completed background process!")
}
