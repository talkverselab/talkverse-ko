# 사용: send_batch.sh <시작 번호> <편 경로...>  (assets/data/dialogues/ 아래 경로, .json 없이)
cd ~/talkverse/ko
i=$1; shift
/usr/bin/python3 - <<'PY'
import sys,time; sys.path.insert(0,'tools'); from grok_base import g
c=g.CDP(g.tab('e049e908'))
c.call('Page.navigate',url='https://grok.com/project/e049e908-b4a7-45d4-9523-4f006f6f7e0c'); time.sleep(7)
PY
for f in "$@"; do
  id=$(basename $f); code=$(printf "K%03d" $i); i=$((i+1))
  python3 tools/grok_prompt.py assets/data/dialogues/$f.json $code > data/review/${id}_req.md
  # 편마다 새 대화방(한 방에 여러 편이면 답 순서가 꼬인다 — 공용 작성법 §0)
  /usr/bin/python3 -c "import sys,time; sys.path.insert(0,'tools'); from grok_base import g; c=g.CDP(g.tab('e049e908')); c.call('Page.navigate',url='https://grok.com/project/e049e908-b4a7-45d4-9523-4f006f6f7e0c'); time.sleep(7)"
  r=$(/usr/bin/python3 tools/grok_send.py data/review/${id}_req.md data/review/${id}_grok_rewrite.md --tab e049e908 --wait 420 2>&1 | tail -1)
  sleep 30; /usr/bin/python3 tools/grok_fetch.py e049e908 data/review/${id}_grok_rewrite.md >/dev/null 2>&1
  echo "$code $id $r"
  case "$r" in LIMIT*) break;; esac
done
echo ALLDONE
