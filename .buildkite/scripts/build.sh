#!/usr/bin/env bash

touch .env

base="iYGKSNr0jT7Z7E6z0PpzWbYiepFEPcw+wVZ+5YkpRcwIRG5lyhsOQe+K01h922Wy"
enc="$(elixir --eval "IO.inspect :crypto.strong_rand_bytes(32) |> :base64.encode")"

cat <<CONFIG >.env
export ENCRYPTION_KEYS=${enc}
export SECRET_KEY_BASE=${base}
CONFIG
