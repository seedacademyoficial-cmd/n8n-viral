FROM docker.n8n.io/n8nio/n8n:2.30.5

USER root

RUN apk add --no-cache \
      python3 \
      py3-pip \
      ffmpeg \
      curl \
      ca-certificates \
    && python3 -m pip install \
      --break-system-packages \
      --no-cache-dir \
      --upgrade yt-dlp \
    && yt-dlp --version \
    && ffmpeg -version | head -n 1

USER node
