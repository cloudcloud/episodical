#!/usr/bin/env bash

export MIX_ENV="test"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"
export LC_ALL="en_US.UTF-8"

apt-get update -y
apt-get install -y build-essential git libstdc++6 openssl libncurses5 locales ca-certificates

sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
locale-gen

mix local.hex --force
mix local.rebar --force

mix deps.get
mkdir config

./.buildkite/scripts/build.sh
mix deps.compile

mix assets.setup
mix assets.build
mix compile
