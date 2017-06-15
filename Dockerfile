FROM node:alpine

MAINTAINER Jan Soendermann <jan.soendermann+git@gmail.com>

RUN apk add --no-cache nmap-ncat bash curl jq git
RUN rm -rf /var/cache/apk/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY startup.sh .
COPY http-server.js .
COPY handle-push.sh .

EXPOSE 8080

ENTRYPOINT ["bash", "startup.sh"]