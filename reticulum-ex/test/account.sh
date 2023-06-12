#!/bin/bash
set -e

echo '-------------------------------------------------'
echo 'Account Test Start'
echo '-------------------------------------------------'

HOST="https://stage.xrcloud.app:4000"

# 1. 회원가입
CREATE_ACCOUNT=$(curl -X POST \
  --silent \
  --verbose \
  $HOST/api/v1/belivvr/account \
  -H 'Content-Type: application/json' \
  -d '{"email_id": "test@test.com"}')

echo -e '\nResponse:\n' "$CREATE_ACCOUNT"

# RES 200
# {
#    "account_id":"1517112251599814707",
#    "status":"ok",
#    "token":"eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJyZXQiLCJleHAiOjE2OTM4MjYyNTAsImlhdCI6MTY4NjU2ODY1MCwiaXNzIjoicmV0IiwianRpIjoiYjEzNWQ1NmEtNTRlZi00NDk3LWJlMzUtNjFkYjgzZTdmNjVjIiwibmJmIjoxNjg2NTY4NjQ5LCJzdWIiOiIxNTE3MTEyMjUxNTk5ODE0NzA3IiwidHlwIjoiYWNjZXNzIn0.NupGrdqqOb3nbKNE3gPleOa-thTj7vCD5pCLab6NhRy1o8u3MCMn4m0wteK47fizcX04k4FEe4D8lDUOuFaCqg"
# }
