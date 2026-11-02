#!/usr/bin/env python3
"""편 JSON → 장면 컷 그림 요청문. A·B 대화 한 쌍(연속 두 턴) = 컷 1장, 말풍선·글자 없음(사용자 지시 2026-11-02).
  python3 tools/scene_prompts.py <편.json> <코드 접두어>   → data/review/art/<편id>/cut<n>_req.md 를 쓰고 컷 수를 출력
컷 그림은 tools/grok_image.py 로 한 장씩(인물 기준 그림 data/review/art/chars.jpg 첨부) 받아 같은 폴더 cut<n>.jpg 로 저장한다.
"""
import json, os, re, sys
e = json.load(open(sys.argv[1], encoding='utf-8')); pre = sys.argv[2]
out = f"data/review/art/{e['id']}"; os.makedirs(out, exist_ok=True)
CHAR = {'유진': '유진(한국인 20대 여성, 어깨 길이 갈색 머리 반묶음, 크림색 니트·연청 데님·크로스백)',
        '하늘': '하늘(한국인 20대 여성, 검은 긴 생머리, 검은 가죽 재킷·흰 티)',
        '해솔': '해솔(한국인 20대 여성, 짧은 단발, 베이지 가디건)', '지안': '지안(카페 바리스타, 20대 여성, 앞치마)',
        '서아': '서아(한국인 20대 여성, 포니테일, 보라색 후드티 — K-팝 덕후)', '민준': '민준(한국인 20대 남성, 짧은 검은 머리, 체크 셔츠)',
        '도윤': '도윤(셰어하우스 룸메이트, 20대 남성, 안경·회색 맨투맨)', '지호 선배': '지호(회사 선배, 30대 초 남성, 셔츠·사원증)',
        '태오': '태오(한국 아이돌 연습생 느낌의 20대 초 남성 — 새까만 머리를 이마 위로 뾰족하게 세운 레이어드 컷, 날카로운 고양이 눈매·또렷한 턱선, 작은 귀 피어싱, 검은 오버사이즈 재킷·흰 티·와이드 팬츠, 무대 위 카리스마와 무심한 듯 다정한 표정)',
        '{name}': '학습자(외국인 20대, 청자 비취색 #3D8B7A 후드티·베이지 바지·백팩 — 성별은 첨부 기준 그림의 남/여 중 하나, 편 안에서 통일)'}
def who(s):
    n = e['speakers'].get(s, s); return CHAR.get(n, f'{n}(조연)')
turns = e['turns']; cuts = [turns[i:i + 2] for i in range(0, len(turns), 2)]
people = ' / '.join(who(s) for s in e['speakers'])
for k, pair in enumerate(cuts, 1):
    desc = ' → '.join(f"{e['speakers'].get(t['speaker'], t['speaker'])}: 「{re.sub(r'\(.*?\)', '', t['ko']).strip()}」" for t in pair)
    txt = f"""[{pre}-{k}] 회화 장면 컷 {k}/{len(cuts)} — 편 「{e['title']}」({e['id']}). 첨부 1번 = 인물 기준 그림(얼굴·머리·옷을 그대로 유지), 첨부 2번 = 앱 화면 톤(시안 04).
스타일: 부드러운 3D 점토/펠트 인형, 둥근 얼굴, 파스텔 배경, 밝고 따뜻한 조명(어두운 밤 장면도 가로등·간판 불빛으로 밝게), 부드러운 그림자. 가로 16:9.
장면: {e['scene']}
등장: {people}
이 컷의 순간(그림에 글자로 넣지 말 것 — 표정·몸짓·소품으로만 표현): {desc}
반드시: **말풍선·글자·간판 글씨·자막·숫자·로고 없음**(대사는 앱이 나중에 얹는다 — 말풍선이 들어갈 여백을 인물 머리 위쪽에 남길 것). 두 인물이 모두 보이게, 말하는 사람이 조금 더 앞에. 실존 인물·브랜드 금지.
출력: 그림 1장만. 설명 없이.
"""
    open(f"{out}/cut{k}_req.md", 'w', encoding='utf-8').write(txt)
print(len(cuts))
