#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
PREVIEW_STREAM_KEY="${PREVIEW_STREAM_KEY:-sound-1-in}"
AUDIO_INPUT="${AUDIO_INPUT:-pinmic}"
AUDIO_OUTPUT="${AUDIO_OUTPUT:-loopout}"

while true; do
  ffmpeg -hide_banner \
  -f alsa -i $AUDIO_INPUT \
  -af 'aresample=async=1:min_hard_comp=0.100000:first_pts=0' \
  -f alsa $AUDIO_OUTPUT \
  -af 'aresample=async=1:min_hard_comp=0.100000:first_pts=0' \
  -c:a aac -fflags flush_packets \
  -f fifo -fifo_format flv -map 0:a -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  "${LIVE_SERVER}/${PREVIEW_STREAM_KEY}"
done
