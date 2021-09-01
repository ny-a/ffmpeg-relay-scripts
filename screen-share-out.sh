#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
STREAM_KEY="${STREAM_KEY:-screen}"
DISPLAY="${DISPLAY:-:0}"
POSITION="${POSITION:-0,0}"
VIDEO_SIZE="${VIDEO_SIZE:-1920x1080}"
FRAMERATE="${FRAMERATE:-30}"
GOP="${GOP:-$(( $FRAMERATE * 2 ))}"
BITRATE="${BITRATE:-1M}"
MAXRATE="${MAXRATE:-5M}"
BUFSIZE="${BUFSIZE:-10M}"
INPUT_OPTION="${INPUT_OPTION:-}"
OUTPUT_OPTION="${OUTPUT_OPTION:-}"
V4L2_OUTPUT="${V4L2_OUTPUT:-/dev/video11}"

while true; do
  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -s "$VIDEO_SIZE" -framerate "$FRAMERATE" \
  $INPUT_OPTION \
  -f x11grab -i "${DISPLAY}+${POSITION}" \
  $OUTPUT_OPTION \
  -f v4l2 "$V4L2_OUTPUT" \
  -c:v flv -b:v "$BITRATE" -maxrate "$MAXRATE" -bufsize "$BUFSIZE" -fflags flush_packets \
  -strict experimental \
  -pix_fmt yuv420p -r "$FRAMERATE" -g "$GOP" -vsync 1 \
  -f fifo -fifo_format flv -map 0:v -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  -format_opts flvflags=no_duration_filesize \
  $@ \
  "rtmp://${LIVE_SERVER}/live/${STREAM_KEY}"
done
