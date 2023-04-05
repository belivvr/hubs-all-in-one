#!/bin/bash

# RSA 키 쌍 생성
openssl genrsa -out private.pem 1024
openssl rsa -in private.pem -pubout -out public.pem

pip install --no-cache-dir cryptography jwcrypto
python generate.py
