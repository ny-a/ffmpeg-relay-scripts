#!/usr/bin/bash

set -eu

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
STREAM_KEY="${PREVIEW_STREAM_KEY:-camera-backup}"
V4L2_INPUT="${V4L2_INPUT:-/dev/video0}"
VIDEO_SIZE="${VIDEO_SIZE:-640x360}"
FRAMERATE="${FRAMERATE:-30}"

while true; do
  ffmpeg -hide_banner \
  -fflags nobuffer \
  -input_format h264 \
  -video_size "$VIDEO_SIZE" \
  -framerate "$FRAMERATE" \
  -f v4l2 -i "$V4L2_INPUT" \
  -c:v copy \
  -fflags flush_packets \
  -f fifo -fifo_format flv -map 0:v -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  "${LIVE_SERVER}/${STREAM_KEY}"
done
