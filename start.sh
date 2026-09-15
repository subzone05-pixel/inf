#!/bin/sh

mkdir -p /app/live

# Nginx চালু করা
nginx

# আনলিমিটেড লুপ: প্রতিটি মুভি একটার পর একটা চলবে এবং সবগুলোতে লোগো থাকবে
while true; do
  while IFS= read -r stream_url || [ -n "$stream_url" ]; do
    # খালি লাইন থাকলে বাদ দেওয়া
    [ -z "$stream_url" ] && continue

    echo "Now Playing: $stream_url"

    ffmpeg -re \
      -fflags nobuffer -flags low_delay \
      -i "$stream_url" \
      -i /app/logo.jpg \
      -filter_complex "[1:v]scale=85:-1[logo];[0:v][logo]overlay=W-w-20:20[v_out]" \
      -map "[v_out]" -map 0:a? \
      -c:v libx264 -preset ultrafast -tune zerolatency \
      -c:a aac -b:a 128k \
      -f hls \
      -hls_time 2 \
      -hls_list_size 3 \
      -hls_flags delete_segments+append_list \
      /app/live/stream.m3u8

    echo "Stream ended. Moving to next movie..."
    sleep 1
  done < /app/playlist.txt
done
