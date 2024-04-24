CONFIG_FILE?=./config.json
PROJECT?=file-organization
C = $(shell printf "\=33[35;1m-->\033[0m")
V := $(if $V,,@)
GO := $(shell which go)

binaries: ; $(info $(C) building all binaries)
	$V $(MAKE) binary GOARCH=amd64 GOOS=linux
	$V $(MAKE) binary GOARCH=amd64 GOOS=windows
	$V $(MAKE) binary GOARCH=amd64 GOOS=darwin
	$V $(MAKE) binary GOARCH=arm64 GOOS=linux
	$V $(MAKE) binary GOARCH=arm64 GOOS=darwin

binary: GOARCH?=amd64
binary: GOOS?=linux
binary: ; $(info $(C) building binary $(PROJECT)-$(GOARCH)-$(GOOS))
	$V $(GO) build -o dist/$(PROJECT)-$(GOARCH)-$(GOOS) ./cmd/$(PROJECT)

build-fe: ; $(info $(C) building the frontend assets)
	$V yarn && NODE_OPTIONS=--openssl-legacy-provider yarn build

clean: ; $(info $(C) cleaning assets and dist)
	$V rm -rf ./pkg/server/dist ./c.out ./$(PROJECT) ./cover.html

coverage: ; $(info $(C) running coverage)
	$V $(GO) test -race -covermode=atomic -coverprofile=c.out ./...
	$V $(GO) tool cover -html=c.out -o cover.html

dev-be: install ; $(info $(C) building backend for dev)
	$V CONFIG_FILE=$(CONFIG_FILE) ./$(PROJECT)

dev-fe: ; $(info $(C) building frontend for dev)
	$V NODE_OPTIONS=--openssl-legacy-provider yarn serve

docker: ; $(info $(C) building container image)
	$V docker build -t cloudcloud/$(PROJECT):latest .

docker.push: ; $(info $(C) pushing image to hub)
	$V docker push cloudcloud/$(PROJECT):latest

install: build-fe ; $(info $(C) installing $(PROJECT))
	$V $(GO) build ./cmd/$(PROJECT)/

local: ; $(info $(C) zero-to-hero for local running)
	$V GOOS=$(shell uname) $(MAKE) install
	$V HOSTNAME=http://localhost:8008 CONFIG_FILE=$(shell pwd)/config.json ./$(PROJECT)

test: install ; $(info $(C) running tests)
	$V $(GO) test -v -race ./...

