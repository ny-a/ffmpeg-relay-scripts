#!/usr/bin/bash

set -eu

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
MAIN_STREAM_KEY="${MAIN_STREAM_KEY:-camera-main}"
BACKUP_STREAM_KEY="${BACKUP_STREAM_KEY:-camera-backup}"
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

  echo "Fallback to ${BACKUP_STREAM_KEY}"

  ffmpeg -hide_banner \
  -fflags nobuffer \
  -f live_flv \
  -i "${LIVE_SERVER}/${BACKUP_STREAM_KEY}" \
  -t "$FALLBACK_DURATION" \
  -f v4l2 "$V4L2_OUTPUT"
done
