#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
STREAM_KEY="${STREAM_KEY:-screen}"
DISPLAY="${DISPLAY:-:0}"
POSITION="${POSITION:-0,0}"
VIDEO_SIZE="${VIDEO_SIZE:-1920x1080}"
BITRATE="${BITRATE:-10M}"

while true; do
  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -s "$VIDEO_SIZE" \
  -f x11grab -i "${DISPLAY}+${POSITION}" \
  -c:v flv -b:v "$BITRATE" -fflags flush_packets \
  -strict experimental \
  -pix_fmt yuv420p \
  -f fifo -fifo_format flv -map 0:v -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  -format_opts flvflags=no_duration_filesize \
  $@ \
  "rtmp://${LIVE_SERVER}/live/${STREAM_KEY}"
done
