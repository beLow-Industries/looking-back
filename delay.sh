#!/bin/bash

set -e

DELAY=30

rm -rf /tmp/delay_stream*

ffmpeg -f v4l2 -framerate 25 -video_size 640x480 -i /dev/video0 \
  -vf scale=720:576 \
  -vcodec libx264 -preset ultrafast -tune zerolatency \
  -f hls -hls_time 1 -hls_list_size $((DELAY + 5)) -hls_flags delete_segments \
  /tmp/delay_stream.m3u8 &
FFMPEG_PID=$!

start=`date +%s`

until [ -f /tmp/delay_stream.m3u8 ]; do sleep 0.1; done

end=`date +%s`

sleep $((DELAY - end + start))

ffplay /tmp/delay_stream.m3u8

kill $FFMPEG_PID $HTTP_PID
