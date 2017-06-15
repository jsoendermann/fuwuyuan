FROM node:alpine

MAINTAINER Jan Soendermann <jan.soendermann+git@gmail.com>

RUN apk add --no-cache nmap-ncat bash
RUN rm -rf /var/cache/apk/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY pfeife.sh .
COPY http-server.js .

EXPOSE 8080

ENTRYPOINT ["node", "http-server.js"]