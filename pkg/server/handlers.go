package server

import (
	"net/http"

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

	api.GET("search/episodic/:title", getSearchEpisodic)
}

func getEpisodicRefresh(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		process.Push(process.BackgroundEpisodicProcess, ctx.Copy())

		return good(gin.H{"enqueued": true})
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

		res, err := db.GetEpisodics(ctx)
		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(res)
	})
}

func getEpisodic(c *gin.Context) {
	wrap(c, func(ctx *gin.Context) (interface{}, []string, int) {
		db := ctx.MustGet("db").(*data.Base)
		id := ctx.Param("id")

		res, err := db.GetEpisodicByID(ctx, id)

		if err != nil {
			return gin.H{}, []string{err.Error()}, http.StatusInternalServerError
		}
		return good(res)
	})
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
