#!/usr/bin/bash

set -eu

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
STREAM_KEY="${STREAM_KEY:-screen}"
DISPLAY="${DISPLAY:-:0}"
POSITION="${POSITION:-0,0}"
VIDEO_SIZE="${VIDEO_SIZE:-1920x1080}"
QUALITY="${QUALITY:-3}"

echo $DISPLAY

while true; do
  ffmpeg -hide_banner \
  -s "$VIDEO_SIZE" \
  -f x11grab -i "${DISPLAY}+${POSITION}" \
  -q "$QUALITY" -c:v flv -fflags flush_packets \
  -f fifo -fifo_format flv -map 0:v -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  "${LIVE_SERVER}/${STREAM_KEY}"
done
