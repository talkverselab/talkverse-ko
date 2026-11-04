#!/bin/bash
# 여자 학습자 컷(<편id>_f) 일괄 생성(2026-11-04 사용자 "1. 진행") — 목록 data/review/write/female_eps.txt(learner_gender F 20편 제외, R0→R3).
# 이미 받은 컷은 건너뛰므로 멈추면 그대로 다시 실행. 50편마다 공용 그림 저장소로 푸시.
cd "$(dirname "$0")/.." || exit 1
mapfile -t E < data/review/write/female_eps.txt 2>/dev/null || E=($(cat data/review/write/female_eps.txt))
for ((i=0; i<${#E[@]}; i+=50)); do
  FEMALE=1 bash tools/cuts4.sh F "${E[@]:i:50}" | grep -v "^$"; rc=${PIPESTATUS[0]}
  bash tools/push_scenes.sh
  [ "$rc" = 3 ] && { echo STOP-LIMIT; exit 3; }
done
echo FEMALE_ALLDONE
