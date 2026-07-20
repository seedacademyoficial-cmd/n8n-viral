FROM node:24.15.0-alpine3.22

ARG N8N_VERSION=2.30.5

USER root

RUN apk add --no-cache \
      python3 \
      py3-pip \
      ffmpeg \
      curl \
      ca-certificates \
      tini \
      make \
      g++ \
      libc6-compat \
    && npm install --global "n8n@${N8N_VERSION}" \
    && python3 -m pip install \
      --break-system-packages \
      --no-cache-dir \
      --upgrade yt-dlp \
    && apk del make g++ \
    && npm cache clean --force \
    && rm -rf /root/.cache /root/.npm /tmp/*

RUN mkdir -p /home/node/.n8n \
    && chown -R node:node /home/node

# Marcador para confirmar que Easypanel ejecuta esta imagen
RUN echo "n8n-viral-custom-2026-07-20" > /etc/viral-image-build

# La construcción fallará si falta alguna herramienta
RUN echo "CUSTOM_IMAGE_OK" \
    && n8n --version \
    && python3 --version \
    && yt-dlp --version \
    && ffmpeg -version | head -n 1 \
    && curl --version | head -n 1

ENV NODE_ENV=production
ENV N8N_PORT=5678
ENV N8N_LISTEN_ADDRESS=0.0.0.0
ENV VIRAL_IMAGE_BUILD=n8n-viral-custom-2026-07-20
ENV SHELL=/bin/sh

WORKDIR /home/node

EXPOSE 5678

USER node

ENTRYPOINT ["tini", "--"]
CMD ["n8n"]
