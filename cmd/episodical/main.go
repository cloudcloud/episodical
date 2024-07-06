// Package main builds the primary Episodical binary, inclusive of any assets.
package main

import (
	"github.com/cloudcloud/episodical/pkg/config"
	"github.com/cloudcloud/episodical/pkg/process"
	"github.com/cloudcloud/episodical/pkg/server"
)

func main() {
	// Start the background manager.
	go process.Background()

	server.New(config.New()).Start()
}
