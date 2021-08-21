#!/usr/bin/bash

set -u

INPUT_CODEC="${INPUT_CODEC:-pcm_s16le}"
AUDIO_INPUT="${AUDIO_INPUT:-loopout0snoop}"
AUDIO_OUTPUT="${AUDIO_OUTPUT:-intoutmix}"

while true; do
  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -c:a "$INPUT_CODEC" -f alsa -i "$AUDIO_INPUT" \
  $@ \
  -f alsa "$AUDIO_OUTPUT"

  sleep 1
done
