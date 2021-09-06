#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
LIVE_SERVER_PORT="${LIVE_SERVER_PORT:-61935}"
INPUT_OPTION="${INPUT_OPTION:-}"
V4L2_INPUT="${V4L2_INPUT:-/dev/video0}"
VIDEO_SIZE="${VIDEO_SIZE:-640x360}"
FRAMERATE="${FRAMERATE:-30}"

while true; do
  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -fflags nobuffer \
  -vcodec mjpeg \
  -video_size "$VIDEO_SIZE" \
  -framerate "$FRAMERATE" \
  $INPUT_OPTION \
  -f v4l2 -i "$V4L2_INPUT" \
  -strict experimental \
  -c:v copy \
  -fflags flush_packets \
  -f fifo -fifo_format mjpeg -map 0:v -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  "udp://${LIVE_SERVER}:${LIVE_SERVER_PORT}"
done