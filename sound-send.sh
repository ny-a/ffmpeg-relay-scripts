#!/usr/bin/bash

set -eu

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
STREAM_KEY="${STREAM_KEY:-sound-2-out}"
AUDIO_INPUT="${AUDIO_INPUT:-loopout}"

while true; do
  ffmpeg -hide_banner \
  -f alsa $AUDIO_INPUT
  -c:a libmp3lame -fflags flush_packets \
  -f fifo -fifo_format flv -map 0:a -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  "${LIVE_SERVER}/${STREAM_KEY}"
done
