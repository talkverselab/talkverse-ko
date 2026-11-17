#!/usr/bin/env python3
"""§9 손질 컷 다시 그리기 — 한 줄 요청 목록(Grok 프롬프트 최소화, 사용자 지시 2026-11-09).
규칙·화풍·인물은 data/review/art/redraw_rules.md 에 한 번만 두고, 여기서는 편마다 한 줄(컷 최대 4장)만 만든다.
  python3 tools/redraw_lines.py [--female]  → data/review/art/redraw_jobs[_f].jsonl  {id, dir, cuts, line, ref}
"""
import glob, json, os, re, sys
FEMALE = '--female' in sys.argv
touched = json.load(open('data/review/realism/cuts_touched.json'))
paths = {os.path.basename(p)[:-5]: p for p in glob.glob('assets/data/dialogues/R*/*/*.json')}
out = open(f"data/review/art/redraw_jobs{'_f' if FEMALE else ''}.jsonl", 'w', encoding='utf-8')
n = 0
for eid, cuts in touched.items():
    d = f"data/review/art/{eid}{'_f' if FEMALE else ''}"
    if FEMALE and not os.path.isdir(d):
        continue
    e = json.load(open(paths[eid], encoding='utf-8'))
    name = lambda s: '학습자' if e['speakers'].get(s, s) == '{name}' else e['speakers'].get(s, s)
    pairs = [e['turns'][i:i + 2] for i in range(0, len(e['turns']), 2)]
    total = len(pairs)
    ref = next((f"{d}/cut{k}.jpg" for k in range(1, total + 1) if k not in cuts and os.path.exists(f"{d}/cut{k}.jpg")), None)
    sex = '여' if FEMALE or e.get('learner_gender') == 'F' else ('남' if e.get('learner_gender') == 'M' else '첨부 컷과 같게')
    cuts = [c for c in cuts if not FEMALE or os.path.exists(f"{d}/cut{c}.jpg")]
    for gi in range(0, len(cuts), 4):
        grp = cuts[gi:gi + 4]
        parts = [f"{eid}{' 여자판' if FEMALE else ''}", f"장면: {e['scene']}", f"학습자: {sex}"]
        if e.get('kind') == 'chat':
            parts.append('채팅')
        for k in grp:
            parts.append(f"컷{k}: " + ' → '.join(f"{name(t['speaker'])}「{re.sub(r'[\U0001F300-\U0001FAFF\u2600-\u27BF\uFE0F]', '', re.sub(r'[(].*?[)]', '', t['ko'])).strip()}」" for t in pairs[k - 1]))
        line = ' | '.join(parts).replace('\n', ' ')
        out.write(json.dumps({'id': eid, 'dir': d, 'cuts': grp, 'line': line, 'ref': ref}, ensure_ascii=False) + '\n')
        n += 1
print(n, 'lines')
