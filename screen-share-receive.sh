#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
STREAM_KEY="${STREAM_KEY:-screen}"
V4L2_OUTPUT="${V4L2_OUTPUT:-/dev/video11}"

while true; do
  ffmpeg -hide_banner \
  -fflags nobuffer \
  -rw_timeout 1000000 \
  -f live_flv -i "${LIVE_SERVER}/${STREAM_KEY}" \
  -f v4l2 "$V4L2_OUTPUT"
done
