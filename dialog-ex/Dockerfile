# syntax=docker/dockerfile:1
ARG NODE_VERSION=18

FROM node:${NODE_VERSION} AS build
WORKDIR /app
RUN apt-get update
RUN apt-get -y install python3-pip
RUN apt-get install -y jq curl dnsutils net-tools

COPY ./package.json .
# COPY ./dialog/package.json .
# COPY ./dialog/package-lock.json .
# RUN npm ci
RUN npm install
COPY ./dialog .

CMD ["npm","start"]
