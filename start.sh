#!/bin/sh

mkdir -p /app/live

# Nginx স্টার্ট
nginx

# রিয়েল-টাইম লাইভ মোড উইথ জিরো বাফারিং
ffmpeg -re \
  -fflags nobuffer -flags low_delay \
  -f concat -safe 0 -protocol_whitelist file,http,https,tcp,tls -stream_loop -1 -i /app/playlist.txt \
  -c copy \
  -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments+append_list \
  /app/live/stream.m3u8
