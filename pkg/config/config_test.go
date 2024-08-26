package config

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestNew(t *testing.T) {
	a := assert.New(t)

	os.Setenv("DATA_FILE", "")
	os.Setenv("DATA_PASSPHRASE", "")
	os.Setenv("HOSTNAME", "")
	os.Setenv("HOST_VIA_API", "")
	os.Setenv("PORT", "")

	a.Panics(func() {
		c := New()
		a.IsType(&Config{}, c, "New() should provide a *Config")
	})

	a.Panics(func() {
		os.Setenv("DATA_FILE", "test_file.json")

		c := New()
		a.IsType(&Config{}, c, "New() should provide a *Config")
	})

	a.NotPanics(func() {
		os.Setenv("DATA_PASSPHRASE", "phrase")

		c := New()
		a.IsType(&Config{}, c, "New() should provide a *Config")
		a.Equal("test_file.json", c.DataFile, "DATA_FILE should determine the value of DataFile")
		a.Equal("phrase", c.DataPassphrase, "DATA_PASSPHRASE should determine the value of DataPassphrase")
		a.Equal("localhost", c.Hostname, "Hostname should be 'localhost' if not provided")
		a.Equal(8118, c.Port, "Port should be '8118' if not provided")
	})

	a.NotPanics(func() {
		os.Setenv("HOSTNAME", "host")

		c := New()
		a.Equal("host", c.Hostname, "HOSTNAME should overwrite the default 'localhost' for Hostname")
		a.Equal("//host:8118/", c.HostViaAPI, "HOST_VIA_API is generated with '//host:port/' if not specified")
	})

	a.NotPanics(func() {
		os.Setenv("HOST_VIA_API", "purple")

		c := New()
		a.Equal("purple", c.HostViaAPI, "HOST_VIA_API should override the generated value for the FE")
	})

	a.NotPanics(func() {
		os.Setenv("PORT", "2345")

		c := New()
		a.Equal(2345, c.Port, "PORT should override the default value for Port")
	})
}
