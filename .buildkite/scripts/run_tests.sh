#!/usr/bin/env bash

touch .env

if [[ "${TEST_ENGINE_TOKEN:-}" == "" ]]; then
  echo "The 'TEST_ENGINE_TOKEN' environment variable is required."
  exit 1
fi

cat <<CONFIG >>.env
export BUILDKITE_ANALYTICS_TOKEN=${TEST_ENGINE_TOKEN}
CONFIG

if [[ "${MIX_TEST_PARTITION:-0}" = "0" ]]; then
  mix test --cover --export-coverage default
else
  mix test --cover --export-coverage default --partitions "${MIX_TEST_PARTITIONS:-1}"
fi

mix test.coverage

sleep 3
