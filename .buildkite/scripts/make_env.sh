#!/usr/bin/env bash

touch .env

# Running mix during the build is proving to be a pain
base="iYGKSNr0jT7Z7E6z0PpzWbYiepFEPcw+wVZ+5YkpRcwIRG5lyhsOQe+K01h922Wy"
enc="$(elixir --eval "IO.inspect :crypto.strong_rand_bytes(32) |> :base64.encode")"

echo "$(pwd) is where this is running from"

cat << VARS > .env
export ENCRYPTION_KEYS=${enc}
export SECRET_KEY_BASE=${base}
VARS

echo ".env content is:"
cat .env
echo
