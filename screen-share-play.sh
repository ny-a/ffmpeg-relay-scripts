#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
STREAM_KEY="${STREAM_KEY:-screen}"

while true; do
  ffplay -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -probesize 32 -analyzeduration 0 \
  -fflags nobuffer \
  -rw_timeout 1000000 \
  -f live_flv \
  "rtmp://${LIVE_SERVER}/live/${STREAM_KEY}" \
  $@
done
