#!/usr/bin/bash

set -eu

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
STREAM_KEY="${STREAM_KEY:-screen}"

while true; do
  ffplay -hide_banner \
  -fflags nobuffer \
  -rw_timeout 1000000 \
  -f live_flv "${LIVE_SERVER}/${STREAM_KEY}"
done
