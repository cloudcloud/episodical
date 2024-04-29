package server

import (
	"net/http"

	"github.com/cloudcloud/episodical/pkg/data"
	"github.com/cloudcloud/episodical/pkg/types"
	"github.com/gin-gonic/gin"
)

func routeAPI(g *gin.Engine) {
	api := g.Group("/api/v1/")

	api.GET("episodic/:id", getEpisodic)
	api.POST("episodic/create", postEpisodic)
	api.PUT("episodic/update/:id", putEpisodic)
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
