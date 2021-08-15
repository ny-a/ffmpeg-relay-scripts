#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
STREAM_KEY="${STREAM_KEY:-screen}"
DISPLAY="${DISPLAY:-:0}"
POSITION="${POSITION:-0,0}"
VIDEO_SIZE="${VIDEO_SIZE:-1920x1080}"
BITRATE="${BITRATE:-12M}"

echo $DISPLAY

while true; do
  ffmpeg -hide_banner \
  -s "$VIDEO_SIZE" \
  -f x11grab -i "${DISPLAY}+${POSITION}" \
  -c:v flv -b:v "$BITRATE" -fflags flush_packets \
  -pix_fmt yuv420p -g 60 -preset ultrafast -tune zerolatency \
  -f fifo -fifo_format flv -map 0:v -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  "${LIVE_SERVER}/${STREAM_KEY}"
done
