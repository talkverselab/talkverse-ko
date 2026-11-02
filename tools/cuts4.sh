# 사용: cuts4.sh <코드접두어> <편 경로...> — 편마다 컷 4개씩 한 요청(그림 최대 4장)으로 생성
cd ~/talkverse/ko  # 재개: tools/cuts4.sh KD <편 경로...>(4장 묶음) · tools/cuts.sh(1장씩) · tools/push_loop.sh(15분 푸시) — 스크래치 대신 tools/ 에 보관(2026-11-03 13:00 재개 예정)
pre=$1; shift; n=0
for f in "$@"; do
  id=$(basename $f); n=$((n+1)); code=$(printf "%s%02d" $pre $n)
  total=$(python3 -c "import json;print((len(json.load(open('assets/data/dialogues/$f.json'))['turns'])+1)//2)")
  groups=$(python3 tools/scene_prompts.py assets/data/dialogues/$f.json $code --batch)
  for gi in $(seq 1 $groups); do
    first=$(( (gi-1)*4+1 )); last=$(( gi*4 )); [ $last -gt $total ] && last=$total; cnt=$(( last-first+1 ))
    done_all=1; for k in $(seq $first $last); do [ -f data/review/art/$id/cut$k.jpg ] || done_all=0; done
    [ $done_all -eq 1 ] && continue
    r=$(/usr/bin/python3 tools/grok_images.py data/review/art/$id/batch${gi}_req.md data/review/art/$id/b${gi}_ $cnt --attach /Users/talkverse/talkverse/ko/data/review/art/chars_v2.jpg,/Users/talkverse/talkverse/ko/data/review/uxui/sian_04.jpg --wait 480 2>&1 | tail -1)
    j=0; for k in $(seq $first $last); do j=$((j+1)); [ -f data/review/art/$id/b${gi}_$j.jpg ] && mv data/review/art/$id/b${gi}_$j.jpg data/review/art/$id/cut$k.jpg; done
    echo "$id batch$gi ($first-$last) $r"
    case "$r" in *LIMIT*) echo STOP-LIMIT; exit 3;; esac
  done
done
echo ALLDONE
