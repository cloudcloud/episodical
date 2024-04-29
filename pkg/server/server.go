package server

import (
	"log"
	"time"

	"github.com/cloudcloud/episodical/pkg/config"
	"github.com/cloudcloud/episodical/pkg/data"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

var (
	skip = map[string]struct{}{
		"/health": struct{}{},
	}
)

type Server struct {
	conf *config.Config
	db   *data.Base
	g    *gin.Engine
}

func New(c *config.Config) *Server {
	db, err := data.Open(c)
	if err != nil {
		log.Fatalf(err.Error())
	}

	s := &Server{conf: c, db: db}

	g := gin.New()
	g.Use(
		cors.New(cors.Config{
			AllowOrigins: []string{c.Hostname},
			AllowMethods: []string{"GET", "POST", "PUT", "OPTIONS", "HEAD", "DELETE"},
			AllowHeaders: []string{"Origin", "X-Client", "Content-Type"},
		}),
		s.logger(),
		s.data(),
	)

	s.g = g
	return s
}

func (s *Server) Start() {
	s.g.Run(s.conf.Hostname)
}

func (s *Server) data() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		ctx.Set("conf", s.conf)
		ctx.Set("db", s.db)

		ctx.Next()
	}
}

func (s *Server) logger() gin.HandlerFunc {
	z, _ := zap.NewProduction()
	l := z.Sugar().With("app", "episodical")

	return func(ctx *gin.Context) {
		start := time.Now()

		log := l.With("client_ip", ctx.ClientIP(), "method", ctx.Request.Method, "start", start)

		p := ctx.Request.URL.Path
		raw := ctx.Request.URL.RawQuery
		if raw != "" {
			p = p + "?" + raw
		}
		log = log.With("path", p)

		ctx.Set("log", log)
		ctx.Next()

		if _, ok := skip[p]; !ok {
			e := time.Now()
			log.With("size", ctx.Writer.Size(), "end", e, "latency", e.Sub(start), "status", ctx.Writer.Status()).Info("access_log")
		}
	}
}
