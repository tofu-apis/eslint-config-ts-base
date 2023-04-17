# PROJECT_NAME defaults to name of the current directory.
# should not to be changed if you follow GitOps operating procedures.
PROJECT_NAME = $(notdir $(PWD))

# docker compose source files
DOCKER_COMPOSE_FORMAT_CHECKER_FILE_NAME = docker-compose.format-checker.yml

##
## This makefile is allows for the following commands:
##
##--------------------------------------------------------------------
## DOCKER COMMANDS            | Description
##--------------------------------------------------------------------

.PHONY: build build-test check-docker clean rebuild rebuild-test

# check-docker command should be on any commands with no dependencies on other docker based commands
## check-docker               | Checks that docker is up an running prior to executing a dependent command
check-docker:
	@docker version > /dev/null 2>&1 || { echo "Docker is not running, so cannot execute command. Exiting..."; exit 1; }

## dckr-format-checker        | Runs the format checker
dckr-format-checker : check-docker
	docker compose --file $(DOCKER_COMPOSE_FORMAT_CHECKER_FILE_NAME) build

## dckr-clean                 | Stops all docker containers running
dckr-clean: check-docker
	docker compose \
		--file $(DOCKER_COMPOSE_FORMAT_CHECKER_FILE_NAME) \
	down --remove-orphans --rmi all

##--------------------------------------------------------------------
## LOCAL COMMANDS             | Description
##--------------------------------------------------------------------

## fmt                        | Runs the formatter (forces formatting changes)
fmt:
	yarn run format

## fmt-check                  | Runs the formatter checker
fmt-check:
	yarn run format:check

## help                       | Outputs the possible make commands
help: Makefile
	@sed -n 's/^##//p' $<

## precommit                  | Runs necessary build/tests before committing (intentionally not running e2e tests due to local slowness)
precommit: fmt-check

##--------------------------------------------------------------------
## LOCAL WATCH COMMANDS       | Description
##--------------------------------------------------------------------

## watch-fmt                  | Watch runs the formatter (forces formatting changes)
watch-fmt:
	yarn run format:watch
