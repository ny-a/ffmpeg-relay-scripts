#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
MAIN_STREAM_KEY="${MAIN_STREAM_KEY:-camera-main}"
BACKUP_V4L2_INPUT="${BACKUP_V4L2_INPUT:-/dev/video0}"
V4L2_OUTPUT="${V4L2_OUTPUT:-/dev/video10}"
FALLBACK_DURATION="${FALLBACK_DURATION:-30}"
PREVIEW_QUALITY="${PREVIEW_QUALITY:-3}"

while true; do
  echo "Start ${MAIN_STREAM_KEY}"

  ffmpeg -hide_banner \
  -fflags nobuffer \
  -rw_timeout 1000000 \
  -f live_flv -i "${LIVE_SERVER}/${MAIN_STREAM_KEY}" \
  -f v4l2 "$V4L2_OUTPUT"

  curl_pid="$(ps auxf | grep 'curl --silent -N' | grep -v grep | awk '{print $2}')"

  if [ "$curl_pid" ]; then
    echo "Restart QX100 LiveView"
    kill "$curl_pid"
  fi

  echo "Fallback to ${BACKUP_V4L2_INPUT}"

  ffmpeg -hide_banner \
  -f v4l2 \
  -i "${BACKUP_V4L2_INPUT}" \
  -t "$FALLBACK_DURATION" \
  -f v4l2 "$V4L2_OUTPUT"
done
