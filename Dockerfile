FROM docker.n8n.io/n8nio/n8n:2.30.5 AS n8n_official

FROM node:24-alpine3.22

USER root

RUN apk add --no-cache \
      python3 \
      py3-pip \
      ffmpeg \
      curl \
      ca-certificates \
      tini \
    && python3 -m pip install \
      --break-system-packages \
      --no-cache-dir \
      --upgrade yt-dlp

COPY --from=n8n_official \
  /usr/local/lib/node_modules/n8n \
  /usr/local/lib/node_modules/n8n

COPY --from=n8n_official \
  /docker-entrypoint.sh \
  /docker-entrypoint.sh

RUN mkdir -p /usr/local/bin /home/node/.n8n \
    && ln -s /usr/local/lib/node_modules/n8n/bin/n8n /usr/local/bin/n8n \
    && chmod +x /docker-entrypoint.sh \
    && chown -R node:node /home/node

ENV NODE_ENV=production
ENV SHELL=/bin/sh

WORKDIR /home/node

EXPOSE 5678

USER node

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
