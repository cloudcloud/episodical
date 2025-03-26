#!/usr/bin/env bash

touch .env
export CI="true"

base="$(mix phx.gen.secret 32)"
echo "Generated '${base}' for Phoenix."

enc="$(elixir --eval "IO.inspect :crypto.strong_rand_bytes(32) |> :base64.encode")"
echo "Generated '${enc}' for Encryption."

if [[ "${TEST_ENGINE_TOKEN:-}" == "" ]]; then
    echo "The 'TEST_ENGINE_TOKEN' environment variable is required."
    exit 1
fi

cat << VARS > .env
export ENCRYPTION_KEYS=${enc}
export SECRET_KEY_BASE=${base}
export TEST_ENGINE_TOKEN=${TEST_ENGINE_TOKEN}
VARS

if [[ "${MIX_TEST_PARTITION:-0}" = "0" ]]; then
    mix test
else
    MIX_TEST_PARTITION="${MIX_TEST_PARTITION}" mix test --partitions "${MIX_TEST_PARTITIONS:-1}"
fi
