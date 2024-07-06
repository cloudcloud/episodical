package config

import (
	"fmt"
	"log"
	"os"
	"strconv"
)

const (
	Version = "v0.0.0_alpha"
)

type Config struct {
	DataFile       string
	DataPassphrase string
	Hostname       string
	HostViaAPI     string
	Port           int
}

func New() *Config {
	return &Config{
		DataFile:       findDataFile(),
		DataPassphrase: findDataPassphrase(),
		Hostname:       findHostname(),
		HostViaAPI:     findHostViaAPI(),
		Port:           findPort(),
	}
}

func findDataFile() string {
	file := os.Getenv("DATA_FILE")
	if len(file) < 1 || file == "" {
		log.Fatal("DATA_FILE is required for episodical to function!")
	}
	return file
}

func findDataPassphrase() string {
	pass := os.Getenv("DATA_PASSPHRASE")
	if len(pass) < 1 || pass == "" {
		log.Fatal("DATA_PASSPHRASE is required for episodical to function!")
	}
	return pass
}

func findHostname() string {
	host := os.Getenv("HOSTNAME")
	if len(host) < 1 || host == "" {
		host = "localhost"
	}
	return host
}

func findHostViaAPI() string {
	host := os.Getenv("HOST_VIA_API")
	if host == "" {
		return fmt.Sprintf("//%s:%d/", findHostname(), findPort())
	}
	return host
}

func findPort() int {
	port, _ := strconv.Atoi(os.Getenv("PORT"))
	if port < 10 {
		return 8118
	}
	return port
}
