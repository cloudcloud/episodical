#!/usr/bin/env bash

buildkite-agent oidc request-token \
    --audience "https://packages.buildkite.com/cloudcloud/episodical" \
    --lifetime 300 \
  | docker login \
    packages.buildkite.com/cloudcloud/episodical \
    --username buildkite \
    --password-stdin

build="${BUILDKITE_BUILD_NUMBER}"

tag=""
if [[ "${BUILDKITE_PULL_REQUEST:-false}" == "true" ]]; then
    tag="pr-${build}"
elif [[ "${BUILDKITE_BRANCH:-}" != "main" ]]; then
    tag="build-${build}"
else
    tag="latest"
fi

# Prime the cache!
docker pull packages.buildkite.com/cloudcloud/episodical/episodical:latest

# Build and push!
docker build --push -t packages.buildkite.com/cloudcloud/episodical/episodical:${tag} -f Dockerfile .
