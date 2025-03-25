#!/usr/bin/env bash

# This should be "/app"
pwd
ls -la ./test/

# Remove the warning, it's just noise
touch .env

if [[ "${MIX_TEST_PARTITION:-0}" = "0" ]]; then
    mix test
else
    MIX_TEST_PARTITION=${MIX_TEST_PARTITION} mix test --partitions ${MIX_TEST_PARTITIONS:-1}
fi
