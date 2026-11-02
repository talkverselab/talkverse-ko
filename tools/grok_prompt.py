#!/usr/bin/env python3
"""편 JSON → Grok 재작성 요청문(tools/prompts/rewrite_grok.md 틀). python3 tools/grok_prompt.py <편.json> <코드> > data/review/<id>_req.md"""
import json, re, sys
from pathlib import Path
tpl = re.search(r'```\n(.*?)\n```', (Path(__file__).parent / 'prompts/rewrite_grok.md').read_text(encoding='utf-8'), re.S).group(1)
e = json.load(open(sys.argv[1], encoding='utf-8'))
LEVEL = {'R0': '왕초보(턴당 아주 짧게, 1문장·2~5어절)', 'R1': '초보(턴당 1~2문장)', 'R2': '중급(턴당 1~2문장, 자연스러운 구어)', 'R3': '고급(턴당 1~3문장, 감정·뉘앙스)'}
LEN = {'R0': '1문장, 2~5어절', 'R1': '1~2문장', 'R2': '1~2문장', 'R3': '1~3문장'}
roles = ', '.join(f"{k} = {'학습자(외국인, 이름 {name})' if v == '{name}' else v}" for k, v in e['speakers'].items())
kd = (f"K-드라마 장치: 이 편은 K-드라마를 본 사람이면 웃음이 터지는 **뻔하디 뻔한 장면**({e['kdrama']})을 일부러 쓴다 — 그 클리셰를 알아보게, 그리고 코믹하게 비틀 것."
      if e.get('kdrama') else '이 편은 **일상 장면**이다 — 드라마 클리셰를 넣지 말고 진짜 생활 대화로.')
lines = '\n'.join(f"{t['num']} {t['speaker']}: {t['ko']} / {t['en']}" for t in e['turns'])
print(tpl.replace('{code}', sys.argv[2]).replace('{roles}', roles).replace('{scene}', e['scene']).replace('{register}', e['register'])
      .replace('{level}', LEVEL[e['region']]).replace('{kdrama}', kd).replace('{n}', str(len(e['turns']))).replace('{{name}}', '{name}')
      .replace('{targets}', '·'.join(e['expressions'])).replace('{length}', LEN[e['region']]).replace('{twist}', str(e['twist'])).replace('{lines}', lines))
