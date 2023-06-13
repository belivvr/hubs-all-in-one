#!/bin/bash
set -e

echo '-------------------------------------------------'
echo 'Room Test Start'
echo '-------------------------------------------------'

HOST="https://stage.xrcloud.app:4000"

#1.조건에 맞는 룸 리스트를 페이지로 조회한다.
ROOM_PAGE=$(curl -X GET "$HOST/api/v1/belivvr/media/search?source=rooms&cursor=0&page_size=10&scene_sid=Pf4TD9H" \
     -H "Content-Type: application/json")

echo -e '\nResponse:\n' "$ROOM_PAGE"

# RES 200
# {
#     "meta": {
#         "source": "rooms",
#         "next_cursor": 1
#     },
#     "entries": [
#         {
#             "description": null,
#             "id": "7UizZDL",
#             "images": {
#                 "preview": {
#                     "url": "https://stage.xrcloud.app:4000/files/0d6cf1b3-cff7-4ffc-a6e9-3d6e82c08969.jpg"
#                 }
#             },
#             "lobby_count": 0,
#             "member_count": 1,
#             "name": "Funny Elaborate Plane",
#             "room_size": 24,
#             "scene_id": "Pf4TD9H",
#             "type": "room",
#             "url": "https://stage.xrcloud.app:4000/7UizZDL/funny-elaborate-plane",
#             "user_data": null
#         },
#         {
#             "description": null,
#             "id": "dwuKQ5s",
#             "images": {
#                 "preview": {
#                     "url": "https://stage.xrcloud.app:4000/files/0d6cf1b3-cff7-4ffc-a6e9-3d6e82c08969.jpg"
#                 }
#             },
#             "lobby_count": 0,
#             "member_count": 0,
#             "name": "Emotional Adored Meetup",
#             "room_size": 24,
#             "scene_id": "Pf4TD9H",
#             "type": "room",
#             "url": "https://stage.xrcloud.app:4000/dwuKQ5s/emotional-adored-meetup",
#             "user_data": null
#         }
#     ],
#     "suggestions": null
# }

#2.scene_id와 이름을 지정하여 룸을 생성한다.
CREATE_ROOM=$(curl -X POST "https://stage.xrcloud.app:4000/api/v1/hubs" \
     -H "Content-Type: application/json" \
     -d "{
            \"hub\": {
            \"scene_id\": \"Pf4TD9H\",
            \"name\": \"테스트룸 1\"
            }
        }")

echo -e '\nResponse:\n' "$CREATE_ROOM"

# RES 200
# {
#    "creator_assignment_token":"f78b790236aef35605dc81de6c890938",
#    "embed_token":"fe5dd5f95bc97894ba20521a97c1583b",
#    "hub_id":"PBxfPki",
#    "status":"ok",
#    "url":"https://stage.xrcloud.app:4000/PBxfPki/테스트룸-1"
# }
