#!/bin/bash
# 새 Grok 방 열기(다시 그리기용) — 첫 탭을 grok.com 새 채팅으로 → 「빠른」 확인 → redraw_rules.md + 인물 기준 3장 첨부 → 방 id 출력
cd ~/talkverse/ko
S=/private/tmp/claude-501/-Users-talkverse-talkverse-ko/d426f6f0-237f-46e3-9ed2-a988e0712508/scratchpad/redraw; mkdir -p $S
{ cat data/review/art/redraw_rules.md; printf '\n첨부: chars_v2·chars_side = 인물 기준, sian_04 = 앱 화면 톤. 이 메시지에는 그림 없이 「준비됨」 한 마디만 답할 것.\n'; } > $S/rules0.md
/usr/bin/python3 - <<'PY' || exit 1
import sys,time; sys.path.insert(0,'tools'); from grok_base import g
c=g.CDP(g.tab('grok.com')); c.call('Page.navigate', url='https://grok.com/'); time.sleep(6)
c=g.CDP(g.tab('grok.com'))
m=c.ev("[...document.querySelectorAll('button')].map(b=>b.innerText.trim()).filter(x=>['빠른','전문가','자동','헤비'].includes(x)).join(',')")
if m!='빠른': print('MODEL',m); sys.exit(1)  # 사용자 지시 11-18: 문법 세션 외 Grok 은 모두 「빠른」
PY
/usr/bin/python3 tools/grok_send.py $S/rules0.md $S/rules_ans.md --tab grok.com --wait 90 --attach $PWD/data/review/art/chars_v2.jpg,$PWD/data/review/art/chars_side.jpg,$PWD/data/review/uxui/sian_04.jpg >/dev/null 2>&1
sleep 5
curl -s http://127.0.0.1:19224/json | python3 -c "import json,sys,re;[print(re.search(r'/c/([0-9a-f]{8})',t['url']).group(1)) for t in json.load(sys.stdin) if t['type']=='page' and '/c/' in t['url']][:1]"
