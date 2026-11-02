# 컷 생성이 도는 동안 15분마다 새 컷을 공용 저장소로 푸시. cuts.sh 가 끝나면(프로세스 없음) 마지막 한 번 푸시하고 종료.
cd ~/talkverse/ko
while true; do
  bash tools/push_scenes.sh 2>&1 | tail -1
  pgrep -f "tools/cuts4?[.]sh" >/dev/null || { bash tools/push_scenes.sh 2>&1 | tail -1; echo LOOP-END; break; }
  sleep 900
done
