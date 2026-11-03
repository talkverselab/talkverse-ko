#!/usr/bin/env python3
"""어절 한도를 넘긴 턴만 Grok 에게 줄여 달라는 요청문. python3 tools/shorten_prompt.py <편.json> <코드> > data/review/<id>_req.md
한도는 check_dialogues.WORDS(R0 6·R1 9 어절). 넘긴 턴이 없으면 아무것도 출력하지 않고 종료 코드 1."""
import json, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent)); import check_dialogues as cd
e = json.load(open(sys.argv[1], encoding='utf-8')); code = sys.argv[2]
wh = cd.WORDS[e['region']][1]
over = [t for t in e['turns'] if cd.eojeol(t['ko']) > wh]
if not over: sys.exit(1)
roles = ', '.join(f"{k} = {'학습자(외국인, 이름 {name})' if v == '{name}' else v}" for k, v in e['speakers'].items())
lines = '\n'.join(f"{t['num']} {t['speaker']}: {t['ko']} / {t['en']}" for t in e['turns'])
nums = ', '.join(f"{t['num']}({cd.eojeol(t['ko'])}어절)" for t in over)
print(f"""[{code}] 아래는 영어권 학습자용 한국어 앱의 회화 1편입니다(이미 구어체로 쓴 완성본). 레벨 {e['region']} 은 턴당 **{wh}어절(띄어쓰기 단위) 이하**가 규칙인데 턴 {nums} 이 넘칩니다.
그 턴들만 **{wh}어절 이하로 줄여서** 다시 써 주세요. 장면·흐름·킥·말투(카톡·현장의 진짜 구어)는 그대로, 두 문장이면 한 문장으로 합치거나 덜 중요한 쪽을 덜어 내세요. 괄호 지문 ( ) 은 꼭 필요할 때만 아주 짧게. 변수 {{name}} 그대로. 다른 턴은 손대지 말 것.
화자: {roles}. 장면: {e['scene']}. 말투: {e['register']}.
출력 형식(이것만, 다른 설명 없이): 넘친 턴만 줄마다 `번호 화자: 한국어 / English(자연스러운 영어 구어) / 무엇을 덜어 냈는지 한 줄`.

회화 전체:
{lines}""")
