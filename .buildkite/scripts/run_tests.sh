#!/usr/bin/env bash

touch .env
export CI="true"

base="$(mix phx.gen.secret 32)"
echo "Generated '${base}' for Phoenix."

secret_key_base="export SECRET_KEY_BASE=${base}" >> .env

if [[ "${TEST_ENGINE_TOKEN:-}" == "" ]]; then
    echo "The 'TEST_ENGINE_TOKEN' environment variable is required."
fi

if [[ "${MIX_TEST_PARTITION:-0}" = "0" ]]; then
    mix test
else
    MIX_TEST_PARTITION="${MIX_TEST_PARTITION}" mix test --partitions "${MIX_TEST_PARTITIONS:-1}"
fi
