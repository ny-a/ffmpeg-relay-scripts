#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
STREAM_KEY="${STREAM_KEY:-screen}"
DISPLAY="${DISPLAY:-:0}"
POSITION="${POSITION:-0,0}"
VIDEO_SIZE="${VIDEO_SIZE:-1920x1080}"
BITRATE="${BITRATE:-12M}"
V4L2_OUTPUT="${V4L2_OUTPUT:-/dev/video11}"

while true; do
  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -s "$VIDEO_SIZE" \
  -f x11grab -i "${DISPLAY}+${POSITION}" \
  -f v4l2 "$V4L2_OUTPUT" \
  -c:v flv -b:v "$BITRATE" -fflags flush_packets \
  -flags low_delay -strict experimental \
  -pix_fmt yuv420p -g 60 -preset ultrafast -tune zerolatency \
  -f fifo -fifo_format flv -map 0:v -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  $@ \
  "rtmp://${LIVE_SERVER}/live/${STREAM_KEY}"
done
