#!/usr/bin/bash

set -u

LIVE_SERVER="${LIVE_SERVER:-localhost}"
INPUT_VIDEO_STREAM_KEY="${INPUT_VIDEO_STREAM_KEY:-screen}"
INPUT_AUDIO_STREAM_KEY="${INPUT_AUDIO_STREAM_KEY:-sound-out}"
# OUTPUT_STREAM_KEY="${OUTPUT_STREAM_KEY:-}"
VIDEO_CODEC="${VIDEO_CODEC:-copy}"
AUDIO_CODEC="${AUDIO_CODEC:-copy}"
INPUT_VIDEO_OPTION="${INPUT_VIDEO_OPTION:-}"
INPUT_AUDIO_OPTION="${INPUT_AUDIO_OPTION:-}"

while true; do
  ffmpeg -hide_banner -probesize 32 -analyzeduration 0 \
  -rw_timeout 1000000 \
  -fflags nobuffer+flush_packets+genpts \
  $INPUT_VIDEO_OPTION \
  -f live_flv -i "rtmp://${LIVE_SERVER}/live/${INPUT_VIDEO_STREAM_KEY}" \
  -probesize 32 -analyzeduration 0 \
  -rw_timeout 1000000 \
  $INPUT_AUDIO_OPTION \
  -f live_flv -i "rtmp://${LIVE_SERVER}/live/${INPUT_AUDIO_STREAM_KEY}" \
  -c:v "$VIDEO_CODEC" -c:a "$AUDIO_CODEC" -async 1 \
  -map 0:v -map 1:a -flags +global_header -f tee \
  $@ \
  "[use_fifo=1:f=fifo:fifo_format=flv:drop_pkts_on_overflow=1:attempt_recovery=1:recovery_wait_time=1]rtmps://a.rtmps.youtube.com/live2/${OUTPUT_STREAM_KEY}|\
  [use_fifo=1:f=fifo:fifo_format=flv:drop_pkts_on_overflow=1:attempt_recovery=1:recovery_wait_time=1]rtmps://b.rtmps.youtube.com/live2/${OUTPUT_STREAM_KEY}"
done
