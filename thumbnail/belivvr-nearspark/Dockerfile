FROM node:20.10.0
WORKDIR /app
COPY package.turkey.json /app/package.json
RUN npm install
COPY app.js index.js /app/
EXPOSE 5000
CMD node app.js
