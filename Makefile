C		:= $(shell printf "\033[35;1m-->\033[0m")
PROJECT := episodical
V 		:= $(if $v,,@)
ENC     := ${ENCRYPTION_KEYS:-"GKDb00WP3YjH7YwEwkLZZjVHNhQU6lDSx58TZBJAG+Y="}

.PHONY: start
start: ; $(info $(C) starting the dev interactive server...)
	$V ENCRYPTION_KEYS=${ENC} iex -S mix phx.server

.PHONY: test
test: ; $(info $(C) running tests...)
	$V mix test

.PHONY: coverage
coverage: ; $(info $(C) generating test coverage...)
	$V mix test --cover

.PHONY: reset
reset: ; $(info $(C) resetting database...)
	$V mix ecto.reset

.PHONY: build-image
build-image: clean ; $(info $(C) building container image...)
	$V docker build -t cloudcloud/$(PROJECT):latest .

.PHONY: push
push: ; $(info $(C) pushing image to hub)
	$V docker push cloudcloud/$(PROJECT):latest

.PHONY: clean
clean: ; $(info $(C) cleaning previously built assets...)
	$V mix phx.digest.clean --all
