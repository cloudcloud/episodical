#!/usr/bin/env bash

touch .env

base="$(mix phx.gen.secret 64)"
enc="$(elixir --eval "IO.puts :crypto.strong_rand_bytes(32) |> :base64.encode")"

if [[ "${TEST_ENGINE_TOKEN:-}" == "" ]]; then
    echo "The 'TEST_ENGINE_TOKEN' environment variable is required."
    exit 1
fi

cat << VARS > .env
export ENCRYPTION_KEYS=${enc}
export SECRET_KEY_BASE=${base}
export TEST_ENGINE_TOKEN=${TEST_ENGINE_TOKEN}
export BUILDKITE_ANALYTICS_TOKEN=${TEST_ENGINE_TOKEN}
VARS

echo "Currently in '$(pwd)' for running tests..."

if [[ "${MIX_TEST_PARTITION:-0}" = "0" ]]; then
    mix test
else
    mix test --partitions "${MIX_TEST_PARTITIONS:-1}"
fi
