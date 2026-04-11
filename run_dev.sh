#!/bin/bash
LOCAL_IP=$(ipconfig getifaddr en0)
sed -i '' "s/LOCAL_IP=.*/LOCAL_IP=$LOCAL_IP/" .env.dev
echo "LOCAL_IP=$LOCAL_IP 로 설정 완료"
flutter run --dart-define-from-file=.env.dev
