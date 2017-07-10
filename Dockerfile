# Build front end
FROM node:alpine as front-end-build-env

MAINTAINER Jan Soendermann <jan.soendermann+git@gmail.com>

RUN mkdir /front-end
WORKDIR /front-end
COPY ./front-end .

RUN npm install
RUN npm run build


# Build pfeife binary
FROM golang:alpine as pfeife-build-env

RUN mkdir /pfeife-src
WORKDIR /pfeife-src
COPY . .

RUN go build -o pfeife .


# Put everything together
FROM docker

RUN mkdir -p /pfeife/front-end
WORKDIR /pfeife

COPY --from=front-end-build-env /front-end/build ./front-end/
COPY --from=pfeife-build-env /pfeife-src/pfeife .

ENTRYPOINT ["/pfeife/pfeife"]
# CMD ["-help"]