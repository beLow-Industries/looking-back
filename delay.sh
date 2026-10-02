#!/bin/bash

set -e

DELAY=${1:-30}
INPUT=${2:-/dev/video0}
INPUT_FORMAT=${3:-640x480}
INPUT_FPS=${4:-25}
OUTPUT_FORMAT=${5:-720x576}

echo -e "\n\n\n\n        delay=$DELAY"

rm -rf /tmp/delay_stream*

ffmpeg -hide_banner -loglevel error \
    -f v4l2 -input_format mjpeg -framerate $INPUT_FPS -video_size $INPUT_FORMAT -i $INPUT \
    -an -vf yadif=0,scale=$(echo $OUTPUT_FORMAT|sed 's|x|:|g') \
    -vcodec libx264 -crf 21 -preset ultrafast -tune zerolatency -sc_threshold 0 \
    -f hls -hls_time $DELAY -hls_list_size 2 -hls_flags delete_segments \
    /tmp/delay_stream.m3u8 &
FFMPEG_PID=$!

until [ -f /tmp/delay_stream.m3u8 ]; do sleep 0.01; done

ffplay -hide_banner -loglevel error /tmp/delay_stream.m3u8

kill $FFMPEG_PID || true
