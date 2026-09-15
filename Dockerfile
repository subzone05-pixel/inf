FROM alpine:3.19

RUN apk add --no-cache ffmpeg nginx curl bash

RUN mkdir -p /app/live /run/nginx

RUN curl -o /app/logo.jpg "https://image.winudf.com/v2/image1/Y29tLm1heHR2Lm1heHR2aXB0dmJveF9zY3JlZW5fN18xNTUzNDQzMTczXzA0NQ/screen-7.jpg?fakeurl=1&type=.jpg"

COPY nginx.conf /etc/nginx/nginx.conf
COPY playlist.txt /app/playlist.txt
COPY start.sh /app/start.sh

RUN chmod +x /app/start.sh

EXPOSE 80

CMD ["/app/start.sh"]
