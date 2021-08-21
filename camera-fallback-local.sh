#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
MAIN_STREAM_KEY="${MAIN_STREAM_KEY:-camera-main}"
BACKUP_V4L2_INPUT="${BACKUP_V4L2_INPUT:-/dev/video0}"
V4L2_OUTPUT="${V4L2_OUTPUT:-/dev/video10}"
FALLBACK_DURATION="${FALLBACK_DURATION:-60}"
RESTART_TARGET="${RESTART_TARGET:-http://10.0.0.1:60152/liveview.JPG}"
RESTART_SIGNAL="${RESTART_SIGNAL:-TERM}"

while true; do
  echo "Start ${MAIN_STREAM_KEY}"

  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -probesize 32 -analyzeduration 0 \
  -fflags nobuffer \
  -rw_timeout 1000000 \
  -f live_flv -i "rtmp://${LIVE_SERVER}/live/${MAIN_STREAM_KEY}" \
  -strict experimental \
  $@ \
  -f v4l2 "$V4L2_OUTPUT"

  restart_pid="$(ps auxf | grep '${RESTART_TARGET}' | grep -v grep | awk '{print $2}')"

  if [ "$restart_pid" ]; then
    echo "Sending ${RESTART_SIGNAL} signal to target process ${restart_pid}..."
    kill "-${RESTART_SIGNAL}" "$restart_pid"
  fi

  echo "Fallback to ${BACKUP_V4L2_INPUT}"

  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -fflags nobuffer \
  -f v4l2 -i "${BACKUP_V4L2_INPUT}" \
  -strict experimental \
  -t "$FALLBACK_DURATION" -pix_fmt yuv420p \
  $@ \
  -f v4l2 "$V4L2_OUTPUT"
done
