#!/usr/bin/bash

set -eu

LIVE_SERVER="${LIVE_SERVER:-rtmp://localhost/live}"
STREAM_KEY="${STREAM_KEY:-sound-2-out}"
AUDIO_OUTPUT="${AUDIO_OUTPUT:-headphone}"

while true; do
  ffmpeg -hide_banner \
  -fflags nobuffer \
  -f live_flv -i "${LIVE_SERVER}/${STREAM_KEY}" \
  -f alsa $AUDIO_OUTPUT
done
