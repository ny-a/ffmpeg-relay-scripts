#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
LIVE_SERVER_PORT="${LIVE_SERVER_PORT:-61935}"
FRAMERATE="${FRAMERATE:-60}"

while true; do
  ffplay -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -probesize 32 -analyzeduration 0 \
  -fflags nobuffer \
  -rw_timeout 1000000 \
  -framerate "$FRAMERATE" \
  -f mjpeg \
  "udp://${LIVE_SERVER}:${LIVE_SERVER_PORT}" \
  $@
done
