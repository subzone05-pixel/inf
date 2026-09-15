#!/bin/sh

mkdir -p /app/live

# Nginx চালু করা
nginx

# লোগো ওভারলেসহ HLS স্ট্রিম
ffmpeg -re \
  -fflags nobuffer -flags low_delay \
  -f concat -safe 0 -protocol_whitelist file,http,https,tcp,tls -stream_loop -1 -i /app/playlist.txt \
  -i /app/logo.jpg \
  -filter_complex "[1:v]scale=200:-1[logo];[0:v][logo]overlay=W-w-20:20[v_out]" \
  -map "[v_out]" -map 0:a? \
  -c:v libx264 -preset ultrafast -tune zerolatency \
  -c:a copy \
  -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments+append_list \
  /app/live/stream.m3u8
