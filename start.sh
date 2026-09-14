#!/bin/sh

mkdir -p /app/live

# Nginx ওয়েব সার্ভার ব্যাকগ্রাউন্ডে চালু করা
nginx

# পিওর স্মুথ লাইভ স্ট্রিমিং কনফিগারেশন (জিরো বাফারিং)
ffmpeg -re \
  -f concat -safe 0 -protocol_whitelist file,http,https,tcp,tls -stream_loop -1 -i /app/playlist.txt \
  -vf "scale=1280:720,fps=25" \
  -c:v libx264 -preset ultrafast -tune zerolatency -crf 28 -g 50 -keyint_min 50 -sc_threshold 0 -threads 2 \
  -c:a aac -b:a 96k -ar 44100 \
  -f hls -hls_time 3 -hls_list_size 10 -hls_flags delete_segments \
  /app/live/stream.m3u8
