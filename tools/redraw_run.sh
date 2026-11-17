#!/bin/bash
# §9 손질 컷 다시 그리기(사용자 "다시 그려", 2026-11-17) — 한 줄 요청(redraw_jobs[_f].jsonl)을 Grok 방에 차례로 보낸다.
# 사용: tools/redraw_run.sh <방 url 조각> <jobs.jsonl> [최대 회차=25]  — 방 맥락이 길면 한도를 많이 먹어 25회차마다 새 방(uk 안내 11-17)
#  - 방은 먼저 redraw_rules.md + 인물 기준 그림을 첨부한 첫 메시지로 만들어 둔다(규칙은 그때 한 번만).
#  - 줄마다 같은 편의 손대지 않은 컷 1장을 첨부(장소·옷·조명 맞춤). 답은 3분까지만 기다리고 넘으면 생성 중지(사용자 지시 11-10).
#  - 이미 새로 그린 컷(redraw_done.txt)은 건너뛴다 → 멈추면 같은 명령으로 다시. 옛 그림은 git 에 남아 있다.
cd ~/talkverse/ko
room=$1; jobs=$2; max=${3:-25}; sent=0; done_f=data/review/art/redraw_done.txt; touch $done_f
S=/private/tmp/claude-501/-Users-talkverse-talkverse-ko/d426f6f0-237f-46e3-9ed2-a988e0712508/scratchpad/redraw; mkdir -p $S
n=$(wc -l < $jobs)
for i in $(seq 1 $n); do
  j=$(sed -n ${i}p $jobs)
  key=$(echo "$j" | python3 -c "import json,sys;x=json.load(sys.stdin);print(x['dir']+':'+','.join(map(str,x['cuts'])))")
  grep -qxF "$key" $done_f && continue
  [ $sent -ge $max ] && { echo NEWROOM; exit 4; }; sent=$((sent+1))
  echo "$j" | python3 -c "import json,sys;x=json.load(sys.stdin);open('$S/line.md','w').write(x['line'])"
  dir=$(echo "$key" | cut -d: -f1); cuts=$(echo "$key" | cut -d: -f2 | tr , ' '); cnt=$(echo $cuts | wc -w | tr -d ' ')
  ref=$(echo "$j" | python3 -c "import json,sys;x=json.load(sys.stdin);print(x['ref'] or '')")
  rm -f $S/n_*.jpg
  r=$(/usr/bin/python3 tools/grok_images.py $S/line.md $S/n_ $cnt --tab "$room" ${ref:+--attach $PWD/$ref} --wait 180 2>&1 | tail -1)
  case "$r" in
    OK*) k=0; for c in $cuts; do k=$((k+1)); mv $S/n_$k.jpg $dir/cut$c.jpg; done; echo "$key" >> $done_f ;;
    TIMEOUT*) /usr/bin/python3 tools/grok_stop.py "$room" ;;
  esac
  echo "$(date +%H:%M) $key $r"
  case "$r" in *LIMIT*) echo STOP-LIMIT; exit 3;; esac
done
echo ALLDONE
