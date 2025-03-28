#!/usr/bin/env bash

touch .env

if [[ "${TEST_ENGINE_TOKEN:-}" == "" ]]; then
    echo "The 'TEST_ENGINE_TOKEN' environment variable is required."
    exit 1
fi

enc="$(elixir --eval "IO.puts :crypto.strong_rand_bytes(32) |> :base64.encode")"
cat << VARS >> .env
export ENCRYPTION_KEYS=${enc}
export SECRET_KEY_BASE=iYGKSNr0jT7Z7E6z0PpzWbYiepFEPcw+wVZ+5YkpRcwIRG5lyhsOQe+K01h922Wy
export BUILDKITE_ANALYTICS_TOKEN=${TEST_ENGINE_TOKEN}
VARS

echo "Currently in '$(pwd)' for running tests..."

if [[ "${MIX_TEST_PARTITION:-0}" = "0" ]]; then
    mix test
else
    mix test --partitions "${MIX_TEST_PARTITIONS:-1}"
fi

echo -n "Sleep"
for i in {1..8}; do
    sleep 1
    echo -n "."
done
echo " Done!"
