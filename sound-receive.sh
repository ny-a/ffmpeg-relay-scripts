#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
STREAM_KEY="${STREAM_KEY:-sound-out}"
AUDIO_OUTPUT="${AUDIO_OUTPUT:-intoutmix}"

while true; do
  ffmpeg -hide_banner \
  -use_wallclock_as_timestamps 1 \
  -probesize 32 -analyzeduration 0 \
  -fflags nobuffer \
  -f live_flv -i "rtmp://${LIVE_SERVER}/live/${STREAM_KEY}" \
  $@ \
  -f alsa $AUDIO_OUTPUT
done
