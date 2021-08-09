#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
STREAM_KEY="${PREVIEW_STREAM_KEY:-camera}"
V4L2_INPUT="${V4L2_INPUT:-/dev/video10}"
BITRATE="${BITRATE:-1M}"

while true; do
  ffmpeg -hide_banner \
  -fflags nobuffer \
  -f v4l2 -i "$V4L2_INPUT" \
  -c:v flv -b:v "$BITRATE" \
  -fflags flush_packets \
  -f fifo -fifo_format flv -map 0:v -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  "${LIVE_SERVER}/${STREAM_KEY}"
done
