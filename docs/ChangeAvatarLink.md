# Change Avatar Link

Spoke에서 아바타 변경 기능을 추가하는 방법입니다.

## 1. Inline View 컴포넌트 추가
1. Add Object > Inline View 선택
2. Properties 설정:
   - Content Type: "avatar" 선택
   - Button Text: "Change Avatar" (기본값)
   - Frame Option: "main" (자동 설정)
   - URL: 변경하고자 하는 아바타의 GLB 파일 URL 입력

## 주의사항
- Content Type을 "avatar"로 설정하면 Frame Option이 자동으로 "main"으로 설정됩니다
- Button Text는 기본값 "Change Avatar"가 설정되지만, 필요시 사용자가 직접 수정할 수 있습니다
- 사용자가 직접 수정한 Button Text는 Content Type을 변경해도 유지됩니다

## 동작 방식
1. 사용자가 버튼 클릭
2. 지정된 GLB 파일의 아바타로 변경
3. 아바타 변경 후 자동으로 프레임 닫힘 