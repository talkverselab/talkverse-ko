# 사용: cuts.sh <코드접두어> <편 경로...>  — 편마다 컷 요청문 생성 후 UXUI 방에 한 장씩 요청·저장
cd ~/talkverse/ko
pre=$1; shift; n=0
for f in "$@"; do
  id=$(basename $f); n=$((n+1)); code=$(printf "%s%02d" $pre $n)
  k=$(python3 tools/scene_prompts.py assets/data/dialogues/$f.json $code)
  for i in $(seq 1 $k); do
    [ -f data/review/art/$id/cut$i.jpg ] && continue
    r=$(/usr/bin/python3 tools/grok_image.py data/review/art/$id/cut${i}_req.md data/review/art/$id/cut$i.jpg --attach /Users/talkverse/talkverse/ko/data/review/art/chars_v2.jpg,$( [ -f data/review/art/chars_side.jpg ] && echo /Users/talkverse/talkverse/ko/data/review/art/chars_side.jpg, )/Users/talkverse/talkverse/ko/data/review/uxui/sian_04.jpg --wait 420 2>&1 | tail -1)
    echo "$id cut$i $r"
    case "$r" in *LIMIT*) echo STOP-LIMIT; exit 3;; esac
  done
done
echo ALLDONE
