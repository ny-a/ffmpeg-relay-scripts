#!/usr/bin/bash

set -eu

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
STREAM_KEY="${STREAM_KEY:-camera-main}"
QUALITY="${QUALITY:-3}"
QX100_URL="http://10.0.0.1:60152/liveview.JPG?%211234%21http%2dget%3a%2a%3aimage%2fjpeg%3a%2a%21%21%21%21%21"

while true; do
  curl --silent -N "$QX100_URL" | \
  ffmpeg -hide_banner \
  -fflags nobuffer \
  -rw_timeout 1000000 \
  -framerate 30 \
  -f mjpeg -i - \
  -q "$QUALITY" -c:v flv -pix_fmt yuv420p \
  -fflags flush_packets \
  -f fifo -fifo_format flv -map 0:v -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  "${LIVE_SERVER}/${STREAM_KEY}"
done
