#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
LIVE_SERVER_PORT="${LIVE_SERVER_PORT:-61935}"
INPUT_OPTION="${INPUT_OPTION:-}"
V4L2_OUTPUT="${V4L2_OUTPUT:-/dev/video11}"

while true; do
  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -probesize 32 -analyzeduration 0 \
  -fflags nobuffer \
  -rw_timeout 1000000 \
  $INPUT_OPTION \
  -f mjpeg -i "udp://${LIVE_SERVER}:${LIVE_SERVER_PORT}" \
  -pix_fmt yuv420p \
  $@ \
  -f v4l2 "$V4L2_OUTPUT"
done
