#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
STREAM_KEY="${STREAM_KEY:-screen}"
V4L2_OUTPUT="${V4L2_OUTPUT:-/dev/video11}"

while true; do
  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -probesize 32 -analyzeduration 0 \
  -fflags nobuffer \
  -rw_timeout 1000000 \
  -f live_flv -i "rtmp://${LIVE_SERVER}/live/${STREAM_KEY}" \
  $@ \
  -f v4l2 "$V4L2_OUTPUT"
done
