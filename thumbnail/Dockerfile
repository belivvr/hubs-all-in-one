FROM node:12.13.0
WORKDIR /app
COPY package.json .
COPY package-lock.json .
COPY app.js index.js .
RUN npm ci
EXPOSE 5000
CMD node app.js
