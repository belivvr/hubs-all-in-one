FROM buildpack-deps:bullseye-curl

WORKDIR /app
RUN apt-get update; apt-get install -y libpq-dev xz-utils;\
wget https://github.com/PostgREST/postgrest/releases/download/v9.0.0/postgrest-v9.0.0-linux-static-x64.tar.xz;\
tar -xf postgrest-v9.0.0-linux-static-x64.tar.xz;\
rm postgrest-v9.0.0-linux-static-x64.tar.xz

# 이거 실행 안 하는데?
CMD ["./postgrest", "/app/reticulum.conf"]
