#!/usr/bin/env python3
"""Grok 답이 끊겨 초안으로 남은 턴(review.final 의 번호)만 다시 써 달라는 요청문. python3 tools/tail_prompt.py <편.json> <코드>
남은 턴이 없으면 종료 코드 1."""
import json, re, sys
e = json.load(open(sys.argv[1], encoding='utf-8')); code = sys.argv[2]
m = re.search(r'턴 \[([\d, ]+)\]', e.get('review', {}).get('final', ''))
if not m: sys.exit(1)
nums = [int(x) for x in m[1].split(',')]
LEN = {'R0': '1문장, 2~5어절', 'R1': '1~2문장', 'R2': '1~2문장', 'R3': '1~3문장', 'R4': '1~3문장'}
roles = ', '.join(f"{k} = {'학습자(외국인, 이름 {name})' if v == '{name}' else v}" for k, v in e['speakers'].items())
lines = '\n'.join(f"{t['num']} {t['speaker']}: {t['ko']} / {t['en']}" + ('   ← 초안(다시 쓸 턴)' if t['num'] in nums else '') for t in e['turns'])
print(f"""[{code}] 아래는 영어권 학습자용 한국어 앱의 회화 1편입니다. 턴 {', '.join(map(str, nums))} 만 아직 **초안**이고 나머지는 이미 구어체로 완성된 대사입니다.
그 초안 턴들만, 앞 턴들과 같은 말투(지금 한국 20~30대가 실제로 하는 말, 카톡·현장 구어)로 **새로 써 주세요**. 초안 문장을 그대로 두지 말 것(「유지」 금지). 턴 길이 {LEN[e['region']]}. 변수 {{name}} 그대로. 편의 끝 여운·킥을 살릴 것. 성적 묘사 금지(12세 이상). 실존 작품·인물·브랜드 금지. 다른 턴은 손대지 말 것.
화자: {roles}. 장면: {e['scene']}. 말투: {e['register']}.
출력 형식(이것만, 다른 설명 없이): 그 턴만 줄마다 `번호 화자: 한국어 / English(자연스러운 영어 구어) / 초안에서 무엇을 바꿨는지 한 줄`.

회화 전체:
{lines}""")
