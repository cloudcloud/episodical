package server

import (
	"bytes"
	"embed"
	"net/http"
	"path"
	"strings"

	"github.com/cloudcloud/episodical/pkg/config"
	"github.com/gin-gonic/gin"
)

//go:embed dist/assets/* dist/index.html
var dist embed.FS

func routeEmbeds(g *gin.Engine) {
	g.GET("/", index)
	g.GET("/assets/*filepath", func(c *gin.Context) {
		c.FileFromFS(path.Join("dist", c.Request.URL.Path), http.FS(dist))
	})
}

func index(c *gin.Context) {
	f, err := dist.ReadFile("dist/index.html")
	if err != nil {
		panic(err)
	}

	s := strings.Replace(
		string(f),
		"[EP_BASE_URL]",
		c.MustGet("conf").(*config.Config).Hostname,
		1,
	)

	r := bytes.NewReader([]byte(s))
	c.DataFromReader(
		http.StatusOK,
		int64(len(s)),
		"text/html",
		r,
		map[string]string{},
	)
}
