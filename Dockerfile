# Build front end
FROM node:alpine as front-end-build-env

MAINTAINER Jan Soendermann <jan.soendermann+git@gmail.com>

WORKDIR /front-end-src

COPY ./front-end/package.json .
RUN npm install

COPY ./front-end .
RUN npm run build


# Build pfeife binary
FROM golang:alpine as pfeife-build-env

WORKDIR /pfeife-src
COPY . .

RUN go build -o pfeife .


# Put everything together
FROM docker

WORKDIR /pfeife

COPY --from=front-end-build-env /front-end-src/build ./front-end/
COPY --from=pfeife-build-env /pfeife-src/pfeife .

EXPOSE 8080

ENTRYPOINT ["/pfeife/pfeife"]
# CMD ["-help"]