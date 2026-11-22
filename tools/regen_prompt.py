#!/usr/bin/env python3
"""§9 손질(2026-11-09, Claude 가 고친 턴)만 Grok 에게 새로 써 달라는 요청문. python3 tools/regen_prompt.py <편.json> <코드> > data/review/<id>_regen_req.md
턴 목록 = data/review/realism/regen_turns.json. 대상 턴이 없으면 종료 코드 1. 답은 apply_rewrite.py --partial 로 넣는다.
(사용자 결정 2026-11-22 「Claude 손질 43편 재작성 여부 - 재작성」, 회화 원칙 11-18: 대사는 Grok 이 쓰고 그대로 붙여 넣기)"""
import json, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent)); import check_dialogues as cd
ROOT = Path(__file__).resolve().parents[1]
e = json.load(open(sys.argv[1], encoding='utf-8')); code = sys.argv[2]
nums = json.load(open(ROOT / 'data/review/realism/regen_turns.json', encoding='utf-8')).get(e['id'], [])
if not nums: sys.exit(1)
wh = cd.WORDS[e['region']][1]
roles = ', '.join(f"{k} = {'학습자(외국인, 이름 {name})' if v == '{name}' else v}" for k, v in e['speakers'].items())
lines = '\n'.join(f"{t['num']} {t['speaker']}: {t['ko']} / {t['en']}" + ('   ← 새로 쓸 턴' if t['num'] in nums else '') for t in e['turns'])
targets = ', '.join(e.get('expressions') or []) or '(없음)'
print(f"""[{code}] 아래는 영어권 학습자가 한국어를 배우는 앱의 회화 1편입니다. 「← 새로 쓸 턴」 표시가 붙은 턴 {', '.join(map(str, nums))} 만 **지금 한국 20~30대가 이 장면에서 실제로 할 법한 구어체 한국어로 새로 써 주세요**(판정이 아니라 재작성). 나머지 턴은 그대로 두고 답에 넣지 마세요.
이 턴들은 「일상에서 동떨어진 과장·비현실 설정」을 덜어 내려고 손본 자리입니다 — 반전·설렘·플러팅은 살리되 진짜 일상 안에서 일어날 법하게. 앞뒤 턴과 말이 이어져야 합니다.
화자: {roles}. 장면: {e['scene']}. 말투: {e['register']}. 레벨: {e['region']}(턴당 {wh}어절 이하).
지킬 것: ① 턴 번호·화자 그대로 ② 변수 {{name}} 그대로 ③ 학습 목표 표현 {targets} 이 그 턴에 있었다면 살릴 것 ④ 교과서체·번역투·설명하는 대사 금지, 카톡·현장의 진짜 말투 ⑤ 12세 이상(성적 묘사 금지) ⑥ 실존 드라마·배우·아이돌·브랜드 이름 금지 ⑦ 지금 문장을 그대로 두지 말 것 — 뜻이 같아도 말투·어순·말끝이 달라야 함.
출력 형식(이것만, 다른 설명 없이): 새로 쓴 턴만 줄마다 `번호 화자: 한국어 / English(자연스러운 영어 구어) / 무엇을 바꿨는지 한 줄`.

회화 전체:
{lines}""")
