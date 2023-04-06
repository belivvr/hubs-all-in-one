# dialog-ex

dialog/Dockerfile로 이미지를 만들면 안 된다.\
dialog/Dockerfile는 내부에 존재하는 스크립트를 실행하는데 여기에 MEDIASOUP_LISTEN_IP, MEDIASOUP_ANNOUNCED_IP 설정을 로컬로 덮어쓴다.
