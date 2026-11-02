# 사용: send_batch.sh <시작 번호> <편 경로...>  (assets/data/dialogues/ 아래 경로, .json 없이)
cd ~/talkverse/ko
i=$1; shift
/usr/bin/python3 - <<'PY'
import sys,time; sys.path.insert(0,'/Users/talkverse/Hanja/tools'); import grok_cdp as g
g.BASE='http://127.0.0.1:9224'; c=g.CDP(g.tab('9632e457'))
c.call('Page.navigate',url='https://grok.com/project/9632e457-d0cc-4b6a-a58d-a9e04b886855'); time.sleep(7)
PY
for f in "$@"; do
  id=$(basename $f); code=$(printf "K%03d" $i); i=$((i+1))
  python3 tools/grok_prompt.py assets/data/dialogues/$f.json $code > data/review/${id}_req.md
  r=$(/usr/bin/python3 tools/grok_send.py data/review/${id}_req.md data/review/${id}_grok_rewrite.md --tab 9632e457 --wait 420 2>&1 | tail -1)
  sleep 5; /usr/bin/python3 tools/grok_fetch.py 9632e457 data/review/${id}_grok_rewrite.md >/dev/null 2>&1
  echo "$code $id $r"
  case "$r" in LIMIT*) break;; esac
done
echo ALLDONE
