#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
STREAM_KEY="${STREAM_KEY:-sound-out}"
INPUT_CODEC="${INPUT_CODEC:-pcm_s32le}"
OUTPUT_CODEC="${OUTPUT_CODEC:-pcm_s16le}"
INPUT_OPTION="${INPUT_OPTION:-}"
OUTPUT_OPTION="${OUTPUT_OPTION:-}"
AUDIO_INPUT="${AUDIO_INPUT:-loopout0snoop}"
AUDIO_OUTPUT="${AUDIO_OUTPUT:-intoutmix}"

while true; do
  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  $INPUT_OPTION \
  -c:a "$INPUT_CODEC" -f alsa -i "$AUDIO_INPUT" \
  $OUTPUT_OPTION \
  -c:a "$OUTPUT_CODEC" -f alsa "$AUDIO_OUTPUT" \
  -strict experimental \
  -c:a aac -fflags flush_packets \
  -f fifo -fifo_format flv -map 0:a -drop_pkts_on_overflow 1 \
  -attempt_recovery 1 -recovery_wait_time 1 \
  $@ \
  "rtmp://${LIVE_SERVER}/live/${STREAM_KEY}"
done
