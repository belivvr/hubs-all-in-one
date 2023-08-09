# syntax=docker/dockerfile:1
ARG NODE_VERSION=18

FROM node:${NODE_VERSION} AS build
WORKDIR /app
RUN apt-get update > /dev/null && apt-get -y install python3-pip > /dev/null
# RUN mkdir certs && openssl req -x509 -newkey rsa:2048 -sha256 -days 36500 -nodes -keyout certs/privkey.pem -out certs/fullchain.pem -subj '/CN=dialog'
# COPY package.json .
# COPY package-lock.json .
# RUN npm ci
# COPY . .
# FROM node:lts-slim
# WORKDIR /app
# COPY --from=build /app /app
# RUN apt-get update > /dev/null && apt-get install -y jq curl dnsutils netcat > /dev/null
# COPY scripts/docker/run.sh /run.sh
# CMD bash /run.sh

RUN apt-get install -y jq curl dnsutils net-tools

# WORKDIR /app

COPY ./dialog .
# COPY config.js ./dialog/config.js
RUN npm ci

CMD ["npm","start"]
