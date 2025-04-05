#!/usr/bin/env bash

# Get the deps
mix deps.get

# Prep the build
./.buildkite/scripts/build.sh
# Compile the deps
mix deps.compile

# Prep the assets
mix assets.setup
# Build the assets
mix assets.build
# Compile episodical
mix compile
