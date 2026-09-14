#!/bin/sh

mkdir -p /app/live

# Nginx স্টার্ট
nginx

# পিওর ডিরেক্ট কপি মোড (জিরো সিপিইউ লোড, রিয়েল-টাইম স্পিড)
ffmpeg -re \
  -f concat -safe 0 -protocol_whitelist file,http,https,tcp,tls -stream_loop -1 -i /app/playlist.txt \
  -c copy \
  -f hls -hls_time 3 -hls_list_size 10 -hls_flags delete_segments \
  /app/live/stream.m3u8
