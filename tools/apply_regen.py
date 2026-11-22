#!/usr/bin/env python3
"""§9 손질 턴 Grok 답(data/review/<id>_regen.md) → 그 턴만 편 JSON 에 넣는다. python3 tools/apply_regen.py [편id...]
대상 턴(regen_turns.json) 밖의 줄은 버리고, 대상 턴 중 답이 없는 것은 MISSING 으로 알린다. 넣기는 apply_rewrite.py --partial(rd 자동).
11-09 손질 턴의 메모(note)는 대사가 바뀌면 맞지 않을 수 있어, 메모 머리 낱말이 새 대사에 없으면 STALE 로 알린다."""
import glob, json, re, subprocess, sys
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
regen = json.load(open(ROOT / 'data/review/realism/regen_turns.json', encoding='utf-8'))
paths = {Path(p).stem: p for p in glob.glob(str(ROOT / 'assets/data/dialogues/R*/*/*.json'))}
ids = sys.argv[1:] or list(regen)
for i, eid in enumerate(ids):
    md = ROOT / f'data/review/{eid}_regen.md'
    if not md.exists(): print('NOANSWER', eid); continue
    want = set(regen[eid]); keep = []; seen = set()
    for line in md.read_text(encoding='utf-8').splitlines():
        m = re.match(r'^\s*\**(\d+)\**\s+([A-Z]):', line)
        if m and int(m[1]) in want and int(m[1]) not in seen:
            seen.add(int(m[1])); keep.append(line.strip().strip('*'))
    if not keep: print('EMPTY', eid); continue
    tmp = ROOT / f'data/review/{eid}_regen_only.md'; tmp.write_text('\n'.join(keep) + '\n', encoding='utf-8')
    r = subprocess.run([sys.executable, str(ROOT / 'tools/apply_rewrite.py'), paths[eid], str(tmp), f'K{901 + i:03d}', '--partial'], capture_output=True, text=True)
    if r.returncode: print('FAIL', eid, r.stderr.strip().splitlines()[-1:]); continue
    miss = sorted(want - seen)
    e = json.load(open(paths[eid], encoding='utf-8'))
    e.setdefault('review', {})['regen_20261122'] = f'§9 손질 턴 {sorted(seen)} Grok(빠른) 재작성' + (f', 답 없음 {miss}' if miss else '')
    stale = []
    for t in e['turns']:
        if t['num'] in seen and t.get('note'):
            head = t['note'].split('=')[0].strip().rstrip('?').strip()
            stem = head[:-1] if head.endswith('다') and len(head) > 1 else head
            if stem and re.search(r'[가-힣]', stem) and stem.replace(' ', '') not in t['ko'].replace(' ', ''):
                stale.append((t['num'], t['note']))
    json.dump(e, open(paths[eid], 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('OK', eid, sorted(seen), ('MISSING %s' % miss) if miss else '', ('STALE %s' % stale) if stale else '')
