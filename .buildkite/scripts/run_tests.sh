#!/usr/bin/env bash

touch .env

base="iYGKSNr0jT7Z7E6z0PpzWbYiepFEPcw+wVZ+5YkpRcwIRG5lyhsOQe+K01h922Wy"
enc="di39k8ByviRM4HHybXbBDZzhUx/RQfzLbJhb5rdQZ2U="

if [[ "${TEST_ENGINE_TOKEN:-}" == "" ]]; then
  echo "The 'TEST_ENGINE_TOKEN' environment variable is required."
  exit 1
fi

# Provision the database, might be the problem
mix ecto.create
echo "Database should now be provisioned."

cat <<CONFIG >.env
export BUILDKITE_ANALYTICS_TOKEN=${TEST_ENGINE_TOKEN}
export ENCRYPTION_KEYS=${enc}
export SECRET_KEY_BASE=${base}
export TEST_ENGINE_TOKEN=${TEST_ENGINE_TOKEN}
CONFIG

if [[ "${MIX_TEST_PARTITION:-0}" = "0" ]]; then
  mix test
else
  mix test --partitions "${MIX_TEST_PARTITIONS:-1}"
fi

sleep 3
