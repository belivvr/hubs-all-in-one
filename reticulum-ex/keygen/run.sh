#!/bin/bash

# RSA 키 쌍 생성
openssl genrsa -out private.pem 1024
openssl rsa -in private.pem -pubout -out public.pem

docker build -t keygen .
docker run --rm -w /app -it -v $(pwd):/app python python keygen.py

# docker run --rm -w /app -it -v $(pwd):/app python sh
