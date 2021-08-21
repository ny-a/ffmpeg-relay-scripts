#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
STREAM_KEY="${STREAM_KEY:-camera-main}"
VIDEO_SIZE="${VIDEO_SIZE:-640:360}"
BITRATE="${BITRATE:-1M}"
FRAMERATE="${FRAMERATE:-30}"
QX100_URL="http://10.0.0.1:60152/liveview.JPG?%211234%21http%2dget%3a%2a%3aimage%2fjpeg%3a%2a%21%21%21%21%21"

while true; do
  curl --silent -N "$QX100_URL" | \
  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -fflags nobuffer \
  -rw_timeout 1000000 \
  -framerate "$FRAMERATE" \
  -f mjpeg -i - \
  -flags low_delay -strict experimental \
  -vf "crop=${VIDEO_SIZE}" \
  -b:v "$BITRATE" -c:v flv -pix_fmt yuv420p \
  -fflags flush_packets \
  -f fifo -fifo_format flv -map 0:v -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  $@ \
  "rtmp://${LIVE_SERVER}/live/${STREAM_KEY}"
done
