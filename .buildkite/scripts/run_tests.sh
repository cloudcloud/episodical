#!/usr/bin/env bash

touch .env
export CI="true"

if [[ "${TEST_ENGINE_TOKEN:-}" == "" ]]; then
    echo "The 'BUILDKITE_ANALYTICS_TOKEN' environment variable is required."
fi

if [[ "${TEST_ENGINE_TOKEN:-}" == *"ENGINE"* ]]; then
    echo "Variable was not expanded!"
fi

echo "${AL_TOKEN:-not found}"

if [[ "${MIX_TEST_PARTITION:-0}" = "0" ]]; then
    BUILDKITE_ANALYTICS_TOKEN="${TEST_ENGINE_TOKEN}" mix test
else
    BUILDKITE_ANALYTICS_TOKEN="${TEST_ENGINE_TOKEN}" MIX_TEST_PARTITION="${MIX_TEST_PARTITION}" mix test --partitions "${MIX_TEST_PARTITIONS:-1}"
fi
