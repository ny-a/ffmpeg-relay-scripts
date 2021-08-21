#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
STREAM_KEY="${STREAM_KEY:-sound-out}"
INPUT_CODEC="${INPUT_CODEC:-pcm_s32le}"
AUDIO_INPUT="${AUDIO_INPUT:-loopout0snoop}"
AUDIO_OUTPUT="${AUDIO_OUTPUT:-intoutmix}"

while true; do
  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -c:a "$INPUT_CODEC" -f alsa -i "$AUDIO_INPUT" \
  -f alsa "$AUDIO_OUTPUT" \
  -flags low_delay -strict experimental \
  -c:a aac -fflags flush_packets \
  -f fifo -fifo_format flv -map 0:a -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  $@ \
  "rtmp://${LIVE_SERVER}/live/${STREAM_KEY}"
done
