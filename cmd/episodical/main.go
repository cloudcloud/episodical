// Package main builds the primary Episodical binary, inclusive of any assets.
package main

import (
	"github.com/cloudcloud/episodical/pkg/config"
	"github.com/cloudcloud/episodical/pkg/process"
	"github.com/cloudcloud/episodical/pkg/server"
	"github.com/cloudcloud/episodical/pkg/sock"
)

func main() {
	// Start the background manager.
	go process.Background()

	server.New(config.New(), sock.New()).Start()
}
