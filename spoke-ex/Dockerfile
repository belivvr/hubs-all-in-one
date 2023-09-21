FROM node:16 AS build

WORKDIR /app

COPY Spoke/package.json ./Spoke/
COPY Spoke/yarn.lock ./Spoke/

WORKDIR /app/Spoke
run yarn add react-i18next i18next
run yarn install

WORKDIR /app
COPY ./Spoke ./Spoke

WORKDIR /app/Spoke
RUN npm run build

FROM nginx:stable-alpine
WORKDIR /app
COPY --from=build /app/Spoke/dist /usr/share/nginx/html

EXPOSE 9090
CMD ["nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf"]
