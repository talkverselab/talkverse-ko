#!/usr/bin/env python3
"""Grok 재작성 답(data/review/<id>_grok_rewrite.md) → 편 JSON 의 ko·en(·rd) 교체. python3 tools/apply_rewrite.py <편.json> <답.md> <코드>
줄 형식 `번호 화자: 한국어 / English[ / 이유]` — 같은 번호가 두 번 나오면 첫 줄. 화자가 다르면 멈춘다."""
import json, re, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent)); import rd_ko
partial = '--partial' in sys.argv; args = [a for a in sys.argv[1:] if a != '--partial']  # --partial: 답에 있는 턴만 바꾸고(어절 줄이기) review 는 덧붙이기만
p, md, code = args[0], args[1], args[2]
e = json.load(open(p, encoding='utf-8')); got = {}
lines = []  # Grok 이 ` / ` 앞에서 줄을 바꾼 답은 이어 붙인다(r1_culture_a7, 2026-11-03)
for raw in open(md, encoding='utf-8'):
    if raw.strip().startswith('/') and lines: lines[-1] = lines[-1].rstrip() + ' ' + raw.strip()
    else: lines.append(raw)
for line in lines:
    m = re.match(r'^(\d+) ([A-Z]): (.+?) / (.+?)(?: / .*)?$', line.strip())
    if m and int(m[1]) not in got:
        got[int(m[1])] = (m[2], m[3].strip(), m[4].strip())
missing = []
for t in e['turns']:
    if t['num'] not in got:  # Grok 답이 중간에 끊긴 경우 — 그 턴은 초안 유지, review 에 기록
        missing.append(t['num']); continue
    sp, ko, en = got[t['num']]
    assert sp == t['speaker'], (t['num'], sp, t['speaker'])
    t['ko'], t['en'] = ko, en
    if not t.get('rd_manual'):
        t['rd'] = rd_ko.to_rd(ko)
if partial:
    r = e.setdefault('review', {}); r['shorten'] = f'{md} [{code}] 턴 {sorted(got)}'
else:
    e['review'] = {'grok_rewrite': f'{md} [{code}]', 'final': '' if not missing else f'Grok 답이 끊겨 턴 {missing} 은 초안 유지'}
json.dump(e, open(p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print(p, len(got))
