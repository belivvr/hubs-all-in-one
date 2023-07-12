# hubs-ex
## 폴더 구조
```
# root: hubs
.
├── habitat
├── scripts

# 위의 두 폴더는 모두 허브 클라우드 (AWS) 배포에 사용되는 스크립트 이다.
```
```
# root: hubs/src
.
├── aframe-to-bit-components.js
├── agora-dialog-adapter.js
├── app.ts
├── assets
    # asset들의 모음집 이다.(jpg, png, svg...)
├── avatar.html
├── avatar.js
├── belivvr
    # 커스텀한 항목 적용을 위한 폴더로 현재는 화면공유 관련 함수파일만 존재한다.
├── bit-components.js
├── bitecs-debug-helpers.ts
├── bit-systems
    # ThreeJS 관련된 파일들로 방 안에서의 pdf 업로드, 오디오제어, 비디오, 미디어 업로드 재생 애니메이션 등등의 파일들을 모아놓았다.
├── camera-layers.ts
├── change-hub.js
├── cloud.html
├── cloud.js
├── components
    # Aframe 컴포넌트들을 모아놓은 폴더이다. 
    # Aframe 사용법은 [공식문서](https://aframe.io/) 를 참고하면 된다. (간단한 원리는 Component 들을 등록하고 `hub.html` Entity에 속성을 부여하면 해당 컴포넌트가 동작되는 원리이다.)
├── constants.ts
├── discord.html
├── discord.js
├── effects.ts
├── emitter.js
├── freeze.js
├── gltf-component-mappings.js
├── hub.html
    # Aframe 컴포넌트로 등록한 애들을 모아놓은 html 파일.
    # 컴포넌트로 등록한 후 hub.html에 엔티티 등을 추가해야 해당 컴포넌트가 트리거 되는 것 같다.
├── hub.js
    # 등록한 Aframe 컴포넌트들을 모두 import해서 실제로 읽는 파일. 즉 해당 hub.js 파일과 hub.html 이 세트로 묶여있다고 생각하면 된다.
├── hub.service.js
├── index.html
├── index.js
├── inflators
    # 빛, 가속력, 충돌감지, 오디오 등등 ThreeJS 관련 함수 모음 폴더이다.
├── link.html
├── link.js
├── loaders
    # 허브 공간 내에서 WebGL 텍스쳐 생성시 최적화 관련 폴더이다.
├── load-media-on-paste-or-drop.ts
├── message-dispatch.js
├── naf-dialog-adapter.js
├── network-schemas.js
├── objects
├── object-types.js
├── phoenix-adapter.js
├── prefabs
├── react-components
    # 허브 내에 사용되는 리액트 컴포넌트들의 모음집이다.
    # 이모지, 채팅 등등의 각 버튼,사이드바, 아이콘 등등 ThreeJS가 아닌 2d로 인터렉션 하는 것들은 리액트 컴포넌트로 이루어져 있다.
    # 또한 해당 컴포넌트를 클릭시에 호출되는 hook(함수) 도 해당 폴더에 속해 있다.
    # 자주 수정하는 파일로는 하단부의 각 버튼이 모여있는 `ui-root` 와 사이드바인 `UserProfileSidebarContainer` 가 있다.
├── scene-entry-manager.js
├── scene.html
├── scene.js
├── schema.toml
├── signin.html
├── signin.js
├── storage
    # 각종 캐싱 및 로컬스토리지 등을 담당하는 폴더이다.
    # `media-search-store` 에서는 허브 내에서 사용 가능한 오브젝트인 sketchfab 을 담당하고 있다.
    # `store.js` 에서는 레티큘럼에서 내려주는 토큰을 분석해 유저 닉네임과 기존에 선택한 아바타 등을 디폴트 값으로 가져온다. 전남대 닉네임 및 아바타 가져오는 로직도 여기에 들어있다.
├── subscriptions.js
├── support.js
├── systems
    # 모바일인지 PC인지 XR 환경인지 2D 환경인지 등을 파악하고 각 환경 및 기기에 맞게 동작하도록 하는 파일들의 모음집이다.
├── telemetry.js
├── textures
    # 비디오 재생 텍스쳐를 다루는 폴더이다.
├── tokens.html
├── tokens.js
├── transport-for-channel.js
├── update-audio-settings.js
├── update-slice9-geometry.js
├── utils
    # 유틸 함수들을 모아놓은 폴더이다.
    # 모바일인지 사파리인지 미디어 업로드하는게 pdf 인지 오디오인지 등등 다른 파일에서 사용될 수 있는 유틸 함수들을 모아놓은 폴더이다.
├── vendor
├── verify.html
├── verify.js
├── webxr-polyfill.js
├── whats-new.html
├── whats-new.js
└── workers
```
## funcs
`?funcs=full-body,mainpage,3rd-view,share-screen,mute,freeze`
```
전신아바타(아바타 변경X): full-body
전남대 메인페이지: mainpage
3인칭: 3rd-view
<관리자> 참가인원 화면공유 버튼 on/off: share-screen
<관리자> 참가인원 음소거 버튼 on/off: mute
<관리자> 참가인원 움직임 제어 버튼 on/off: freeze
```
## 3인칭
기본 모질라 허브의 박스 캐릭터는 상관 없으나
전남대 및 외부 전신 적용시 1인칭일 경우 카메라 위치가 눈 안쪽 (머리 안)에 위치해 있어서 움직일때 나의 머리가 보이는 현상이 발생하였다.   
이를 해결하고자 1인칭 시에는 머리 크기를 없애는 작업을 진행 하였더니
셀카 촬영시 머리가 없는 형태로 촬영이 되는 현상이 발생하였다.   
이를 해결하고자 1인칭, 3인칭시에 카메라와 아바타 위치 동기화 하는 코드를 작성하여 매번 동기화를 실행하며 1인칭시에는 카메라 위치를 앞으로 캐릭터 앞으로 살짝 당겨 내부가 보이는 현상을 해결하였다.   
다만, VR 모드에서는 애초에 머리가 없는 형태여야 하므로 머리 크기를 0으로 만들어 없는것과 동일하게 만들었다.   
관련파일: `three-utils.js`, `camera-system.js`
## 전신아바타
이전 작업자가 작업해놓고 갔으며 추후 발생했던 문제로는 남자 캐릭터의 손 오므라져 있는 현상과 여자 캐릭터가 땅으로 박히는 현상이 있었다.   
남자 캐릭터의 경우 Material 명이 Material_M_Hand 여야 하는데 Material #2082 로 되어있었다.   
즉, 모든 파일 같은 형식의 Material 명을 사용해야 한다.(아리님이 인지하고 계심)   
여자 캐릭터가 땅에 박혔던 이유는 양쪽 눈의 bone이 빠져 있어서 였다.   
각 눈의 중간 지점을 카메라의 포지션으로 잡게 되는데 기존 작업자가 눈 포지션이 없을 경우 임의의 포지션을 지정해놓는 코드를 추가해 놓았다.   따라서 오히려 에러가 나지 않아 여자 캐릭터만 땅으로 계속 박히게 되었다.   
모두 수정 된 상태이다.   
관련파일: `ik-controller.js`
## belivvr custom
`belivvr custom` 키워드로 검색시 기존 모질라 허브, 스포크에서 변경한 부분의 주석들을 확인할 수 있다.
## 해상도&화질
- utils/media-devices-manager.js
- naf-dialog-adapter.js
