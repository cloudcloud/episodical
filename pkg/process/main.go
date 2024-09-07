package process

import (
	"time"

	"github.com/gammazero/workerpool"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

var (
	wp = &workerpool.WorkerPool{}
)

// Proc is a process to be handled in the background, allowing for various
// components of episodical to request some sort of updating asynchronously.
// Essentially this is an internal queueing mechanism.
type Proc func(*gin.Context)

// Background will run as a goroutine to continually update internal references
// across the configured sets, pulling data from their specified locations.
func Background() {
	wp = workerpool.New(10)
}

// Push will take a Proc and push it onto the queue, awaiting the Background
// to give it to a worker to execute.
func Push(p Proc, ctx *gin.Context) {
	log := ctx.MustGet("log").(*zap.SugaredLogger)
	s := make(chan time.Time, 2)
	wp.Submit(jobSubmission(p, ctx, s))

	// push a goroutine to get the timing without blocking the main routine
	go captureJob(log, s)
}

func jobSubmission(p Proc, ctx *gin.Context, s chan time.Time) func() {
	return func() {
		s <- time.Now()
		p(ctx)
		s <- time.Now()
	}
}

func captureJob(log *zap.SugaredLogger, s chan time.Time) {
	start := <-s
	stop := <-s

	log.With("time_taken", stop.Sub(start)).Info("background_process_complete")
}
