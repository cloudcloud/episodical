#!/usr/bin/env bash

touch .env

base="iYGKSNr0jT7Z7E6z0PpzWbYiepFEPcw+wVZ+5YkpRcwIRG5lyhsOQe+K01h922Wy"
enc="RPjCgzeIfm8L2l70HIvcj5kPBhVcCN2SRWSPYR/h7oE="

cat <<CONFIG >.env
export ENCRYPTION_KEYS=${enc}
export SECRET_KEY_BASE=${base}
CONFIG
