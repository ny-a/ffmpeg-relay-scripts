#!/usr/bin/bash

set -eu

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
PREVIEW_STREAM_KEY="${PREVIEW_STREAM_KEY:-sound-1-in}"
AUDIO_INPUT="${AUDIO_INPUT:-pinmic}"
AUDIO_OUTPUT="${AUDIO_OUTPUT:-loopout}"

while true; do
  ffmpeg -hide_banner \
  -f alsa -i $AUDIO_INPUT \
  -f alsa $AUDIO_OUTPUT \
  -c:a libmp3lame -fflags flush_packets \
  -f fifo -fifo_format flv -map 0:a -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  "${LIVE_SERVER}/${PREVIEW_STREAM_KEY}"
done
