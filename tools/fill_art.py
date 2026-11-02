#!/usr/bin/env python3
"""생성된 장면 컷을 편 JSON 의 턴 `art` 에 채운다 — A·B 쌍(연속 두 턴)의 첫 턴에 "scene/ko/<편id>/cut<N>"(uk 매니페스트 키, 2026-11-02).
  python3 tools/fill_art.py        — data/review/art/<편id>/cutN.jpg 가 있는 컷만. 다시 돌려도 안전."""
import glob, json, os
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]; n = 0
for p in sorted(glob.glob(str(ROOT / 'assets/data/dialogues/R*/*/*.json'))):
    e = json.load(open(p, encoding='utf-8')); changed = False
    for i, t in enumerate(e['turns']):
        if i % 2: continue
        k = i // 2 + 1
        if (ROOT / f"data/review/art/{e['id']}/cut{k}.jpg").exists():
            key = f"scene/ko/{e['id']}/cut{k}"
            if t.get('art') != key: t['art'] = key; changed = True; n += 1
    if changed: json.dump(e, open(p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('art 채움', n)
