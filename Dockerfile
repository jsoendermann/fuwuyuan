FROM alpine:latest

MAINTAINER Jan Soendermann <jan.soendermann+git@gmail.com>

RUN apk add --no-cache nmap-ncat bash
RUN rm -rf /var/cache/apk/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY pfeife.sh .

EXPOSE 8080

ENTRYPOINT ["/bin/bash", "pfeife.sh"]