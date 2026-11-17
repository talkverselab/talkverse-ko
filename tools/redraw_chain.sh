#!/bin/bash
# 다시 그리기 연속 실행 — 목록 파일들을 차례로, 25회차마다 새 방(grok_newroom.sh), 한도(3)면 멈춤
cd ~/talkverse/ko
room=${ROOM:-$(tools/grok_newroom.sh)}; echo "ROOM $room"
for jobs in "$@"; do
  while true; do
    bash tools/redraw_run.sh "$room" "$jobs" 25; rc=$?
    case $rc in
      4) room=$(tools/grok_newroom.sh); echo "ROOM $room"; [ -z "$room" ] && { echo ROOMFAIL; exit 5; } ;;
      3) exit 3 ;;
      *) break ;;
    esac
  done
done
echo CHAINDONE
