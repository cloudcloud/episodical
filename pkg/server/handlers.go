package server

import (
	"net/http"
	"time"

	"github.com/cloudcloud/episodical/pkg/data"
	"github.com/cloudcloud/episodical/pkg/integrations/tvmaze"
	"github.com/cloudcloud/episodical/pkg/process"
	"github.com/cloudcloud/episodical/pkg/types"
	"github.com/gin-gonic/gin"
)

func routeAPI(g *gin.Engine) {
	api := g.Group("/api/v1/")

	api.GET("filesystems", getFilesystems)
	api.POST("filesystem/add", postFilesystemsAdd)
	api.PUT("filesystem/update/:id", putFilesystem)
	api.DELETE("filesystem/remove/:id", deleteFilesystem)

	api.GET("integrations", getIntegrations)
	api.POST("integrations/add", postIntegrationsAdd)
	api.PUT("integration/update/:id", putIntegration)
	api.DELETE("integration/remove/:id", deleteIntegration)

	api.GET("episodics", getEpisodics)
	api.POST("episodics/add", postEpisodic)

	api.GET("episodic/:id", getEpisodic)
	api.PUT("episodic/update/:id", putEpisodic)
	api.DELETE("episodic/delete/:id", deleteEpisodic)
	api.GET("episodic/refresh/:id", getEpisodicRefresh)
	api.POST("episodic/integration/:id", postEpisodicIntegration)
	api.GET("episodic/:id/watched/:episode", getEpisodicWatched)

	api.GET("search/episodic/:title", getSearchEpisodic)
}

func getEpisodicRefresh(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		process.Push(process.BackgroundEpisodicProcess, ctx.Copy())

		return good(gin.H{"enqueued": true})
	})
}

func getEpisodicWatched(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)
		id := ctx.Param("id")
		episodeID := ctx.Param("episode")

		err := db.MarkEpisodeWatched(ctx, id, episodeID)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(gin.H{"mark_watched": true})
	})
}

func getFilesystems(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)

		res, err := db.GetFilesystems(ctx)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(res)
	})
}

func getIntegrations(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)

		res, err := db.GetIntegrations(ctx)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(res)
	})
}

func getSearchEpisodic(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		title := ctx.Param("title")

		res, err := tvmaze.Search(title)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(res)
	})
}

func postEpisodicIntegration(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)
		id := ctx.Param("id")

		body := &types.EpisodicAssociateIntegration{}
		err := ctx.BindJSON(body)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}

		err = db.UpdateEpisodicIntegration(ctx, id, body.ExternalID)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(gin.H{"success": true})
	})
}

func postFilesystemsAdd(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)

		body := &types.AddFilesystem{}
		err := ctx.BindJSON(body)

		res, err := db.AddFilesystem(ctx, body)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(res)
	})
}

func postIntegrationsAdd(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)

		body := &types.AddIntegration{}
		err := ctx.BindJSON(body)

		res, err := db.AddIntegration(ctx, body)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(res)
	})
}

func putFilesystem(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)
		id := ctx.Param("id")

		body := &types.AddFilesystem{}
		err := ctx.BindJSON(body)

		res, err := db.UpdateFilesystem(ctx, id, body)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(res)
	})
}

func putIntegration(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)
		id := ctx.Param("id")

		body := &types.AddIntegration{}
		err := ctx.BindJSON(body)

		res, err := db.UpdateIntegration(ctx, id, body)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(res)
	})
}

func deleteFilesystem(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)
		id := ctx.Param("id")

		err := db.DeleteFilesystem(ctx, id)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(gin.H{})
	})
}

func deleteIntegration(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)
		id := ctx.Param("id")

		err := db.DeleteIntegration(ctx, id)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(gin.H{})
	})
}

func deleteEpisodic(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)
		id := ctx.Param("id")

		err := db.DeleteEpisodic(ctx, id)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(gin.H{})
	})
}

func getEpisodics(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)

		meta := gin.H{}
		res, err := db.GetEpisodics(ctx)
		for _, x := range res {
			meta[x.ID] = generateMetaFromEpisodes(x.Episodes)
		}

		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(gin.H{"episodics": res, "meta": meta})
	})
}

func getEpisodic(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)
		id := ctx.Param("id")

		res, err := db.GetEpisodicByID(ctx, id)
		meta := generateMetaFromEpisodes(res.Episodes)

		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(gin.H{"episodic": res, "meta": meta})
	})
}

func generateMetaFromEpisodes(eps []*types.Episode) gin.H {
	hs, sc, te, we, h, hn := false, 0, 0, 0, 0, false
	next, _ := time.Parse("2006-01-02", "2050-01-01")

	for _, x := range eps {
		if x.SeasonID == 0 {
			hs = true
		}
		if x.SeasonID > sc {
			sc = x.SeasonID
		}

		if x.DateReleased.Before(time.Now()) {
			te++
			if x.IsWatched {
				we++
			}
		}

		if x.FileEntry != "" {
			h++
		}
		if x.DateReleased.Before(next) && x.DateReleased.After(time.Now()) {
			hn = true
			next = x.DateReleased
		}
	}

	if h > te {
		te = h
	}

	nx := ""
	if hn {
		nx = next.Format("2006-01-02")
	}
	return gin.H{
		"has_specials":       hs,
		"season_count":       sc,
		"total_episodes":     te,
		"watched_episodes":   we,
		"have_episode_files": h,
		"next_episode_date":  nx,
	}
}

func postEpisodic(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)

		body := &types.AddEpisodic{}
		ctx.BindJSON(body)
		res, err := db.AddEpisodic(ctx, body)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(res)
	})
}

func putEpisodic(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)
		id := ctx.Param("id")

		body := &types.AddEpisodic{}
		ctx.BindJSON(body)
		res, err := db.UpdateEpisodic(ctx, id, body)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(res)
	})
}
