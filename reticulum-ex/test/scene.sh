#!/bin/bash
set -ex

echo '-------------------------------------------------'
echo 'Scene Test Start'
echo '-------------------------------------------------'

HOST="https://stage.xrcloud.app:4000"

# 1. 조건에 맞는 씬 리스트를 페이지로 조회한다.
SCENE_PAGE=$(curl -X GET "$HOST/api/v1/belivvr/media/search?source=scenes&user=1517040754050990082&cursor=1&page_size=2" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJyZXQiLCJleHAiOjE2OTM4MDg5OTEsImlhdCI6MTY4NjU1MTM5MSwiaXNzIjoicmV0IiwianRpIjoiMTRlNWM0NjctMjhiMi00YzdkLTk2ZWQtMWEwMTJkOTdhZjllIiwibmJmIjoxNjg2NTUxMzkwLCJzdWIiOiIxNTE3MDQwNzU0MDUwOTkwMDgyIiwidHlwIjoiYWNjZXNzIn0.XhI_0c0jMkUCZNX9JC5SAYotnKs9G2Tq_yE9VTl-4uPc1CFIDlvYnNd4t7rdOXV9_pu01ZWupHSwOLKGD8GMQA")

echo -e '\nResponse:\n' "$SCENE_PAGE"
# RES 200
# {
#     "meta": {
#         "source": "scenes",
#         "next_cursor": null
#     },
#     "entries": [
#         {
#             "attributions": {
#                 "content": [],
#                 "creator": ""
#             },
#             "description": null,
#             "id": "BNpr7vR",
#             "images": {
#                 "preview": {
#                     "url": "https://stage.xrcloud.app:4000/files/5f02436c-b50c-413a-96d2-f12315884195.jpg"
#                 }
#             },
#             "name": "Crater44",
#             "project_id": "Jz3ro6D",
#             "type": "scene",
#             "url": "https://stage.xrcloud.app:4000/scenes/BNpr7vR/crater44"
#         },
#         {
#             "attributions": {
#                 "content": [],
#                 "creator": ""
#             },
#             "description": null,
#             "id": "Pf4TD9H",
#             "images": {
#                 "preview": {
#                     "url": "https://stage.xrcloud.app:4000/files/0d6cf1b3-cff7-4ffc-a6e9-3d6e82c08969.jpg"
#                 }
#             },
#             "name": "Crater",
#             "project_id": "criY4Jf",
#             "type": "scene",
#             "url": "https://stage.xrcloud.app:4000/scenes/Pf4TD9H/crater"
#         }
#     ],
#     "suggestions": null
# }
#
# modify_url의 경우 project_id를 조합하고 쿼리스트링으로 토큰을 붙여 접속한다.
# ex) https://stage.xrcloud.app:4000/spoke/projects/${project_id}?token=
# 만약 권한이 없을경우(자신의 프로젝트가 아닐경우) 찾을수 없어서 404 에러가 반환된다.
#
# 새로운 씬을 만들경우 특정 url에 쿼리스트링으로 토큰을 붙여 접속한다.
# ex)https://stage.xrcloud.app:4000/spoke/projects/new?token=
