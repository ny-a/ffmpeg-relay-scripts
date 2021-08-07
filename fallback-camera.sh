#!/usr/bin/bash

set -eu

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
MAIN_STREAM_KEY="${MAIN_STREAM_KEY:-camera-main}"
BACKUP_STREAM_KEY="${BACKUP_STREAM_KEY:-camera-backup}"
PREVIEW_STREAM_KEY="${PREVIEW_STREAM_KEY:-camera-preview}"
V4L2_OUTPUT="${V4L2_OUTPUT:-/dev/video10}"
VIDEO_SIZE="${VIDEO_SIZE:-640x360}"
FALLBACK_DURATION="${FALLBACK_DURATION:-30}"
PREVIEW_QUALITY="${PREVIEW_QUALITY:-3}"

while true; do
  echo "Start ${MAIN_STREAM_KEY}"

  ffmpeg -hide_banner \
  -fflags nobuffer \
  -rw_timeout 1000000 \
  -f live_flv -i "${LIVE_SERVER}/${MAIN_STREAM_KEY}" \
  -vf "crop=${VIDEO_SIZE}" \
  -f v4l2 "$V4L2_OUTPUT" \
  -q "$PREVIEW_QUALITY" \
  -c:v flv -fflags flush_packets \
  -f fifo -fifo_format flv -map 0:v -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  "${LIVE_SERVER}/${PREVIEW_STREAM_KEY}"

  echo "Restart QX100 LiveView"

  kill $(ps auxf | grep 'curl --silent -N' | grep -v grep | awk '{print $2}')

  echo "Fallback to ${BACKUP_STREAM_KEY}"

  ffmpeg -hide_banner \
  -fflags nobuffer \
  -f live_flv \
  -i "${LIVE_SERVER}/${BACKUP_STREAM_KEY}" \
  -t "$FALLBACK_DURATION" \
  -f v4l2 "$V4L2_OUTPUT" \
  -q "$PREVIEW_QUALITY" -t "$FALLBACK_DURATION" \
  -c:v flv -fflags flush_packets \
  -f fifo -fifo_format flv -map 0:v -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  "${LIVE_SERVER}/${PREVIEW_STREAM_KEY}"
done
