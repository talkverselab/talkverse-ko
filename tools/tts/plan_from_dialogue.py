#!/usr/bin/python3
"""회화 파일의 `emotion`·`segs` 로 감정 계획을 자동 생성(사용자 지시 2026-11-07 "음성 만들 때 본 감정을 고려하도록 스크립트") — 감정을 다시 손으로 적지 않는다.
  python3 tools/tts/plan_from_dialogue.py <편id>... [--force]     그 편들의 data/tts/plan/<편id>.json 을 만든다(이미 있으면 --force 때만 덮어씀)
  python3 tools/tts/plan_from_dialogue.py --missing              계획이 없는 편 중 턴에 emotion/segs 가 있는 편 전부
턴 → segs: 턴에 `segs`([감정, 본문] 또는 [감정, 본문, 읽기])가 있으면 그대로, 없으면 `emotion`(없으면 neutral) 하나로 턴 전체.
읽기(세 번째 칸)가 없으면 자동 정리: 지문 (…)·ㅋㅋ·ㅠㅠ·이모지·「」 제거, 아라비아 숫자 한글 읽기, 문장부호 없는 끝에 마침표. cast = voices.json 의 `cast` 표 → 이름 단서 → man_y/woman_y 번갈아.
m/f 판(누나/오빠 등 학습자 성별 의존 말)은 자동으로 만들지 않는다 — 필요하면 생성된 계획에 손으로 넣는다."""
import json, os, re, sys
import ttslib as L
R, V, EP = L.R, L.V, L.EP
NUM = ['영', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구']
UNIT = [('천', 1000), ('백', 100), ('십', 10)]
NATIVE = {1: '한', 2: '두', 3: '세', 4: '네', 5: '다섯', 6: '여섯', 7: '일곱', 8: '여덟', 9: '아홉', 10: '열', 11: '열한', 12: '열두'}


def sino(n):
    if n == 0:
        return '영'
    out = ''
    if n >= 10000:
        out += (sino(n // 10000) if n // 10000 > 1 else '') + '만'; n %= 10000
    for name, u in UNIT:
        if n >= u:
            out += (NUM[n // u] if n // u > 1 else '') + name; n %= u
    if n:
        out += NUM[n]
    return out


def num_ko(m):
    n, unit = int(m.group(1)), m.group(2) or ''
    if unit in ('시', '시간', '개', '명', '살', '잔', '병', '마리', '번째') and n in NATIVE:
        return NATIVE[n] + ' ' + unit
    return sino(n) + (' ' + unit if unit else '')


def reading(text):
    s = re.sub(r'\([^)]*\)|\[[^\]]*\]', '', text)
    s = re.sub(r'[ㅋㅎㅠㅜ]{2,}|[「」『』“”"]', '', s)
    s = re.sub(r'[\U0001F300-\U0001FAFF☀-➿⭐️]', '', s)
    s = re.sub(r'(\d+)\s*(시간|시|분|초|개|명|살|잔|병|마리|번째|번|층|년|월|일|원|교시|호|킬로|퍼센트|%)?', num_ko, s)
    s = re.sub(r'\s+', ' ', s).strip()
    if s and s[-1] not in '.?!…,~':
        s += '.'
    return s


_alt = [0]


def pick_voice(name, used):
    c = V.get('cast', {})
    v = c.get(name) or next((c[k] for k in sorted(c, key=len, reverse=True) if k in name), None)
    if v is None:
        if re.search(r'아주머니|할머니|엄마|언니|누나|여자|이모|아내|부인', name):
            v = 'woman_m'
        elif re.search(r'아저씨|할아버지|아빠|형|오빠|남자|남편', name):
            v = 'man_m'
        else:
            v = ['man_y', 'woman_y'][_alt[0] % 2]; _alt[0] += 1
    if v in used:   # 같은 편 두 인물이 같은 목소리면 성별 비슷한 다른 목소리로
        for alt in (['man_y', 'man_m', 'doyun', 'taeo'] if v.startswith(('man', 'jiho', 'timjang', 'prof', 'minjun', 'doyun', 'taeo')) else ['woman_y', 'woman_m', 'haesol', 'jian']):
            if alt not in used:
                v = alt; break
    return v


def build(ep):
    d = json.load(open(EP[ep], encoding='utf-8'))
    used = set(); cast = {}
    for k, name in d['speakers'].items():
        if k == 'A':
            continue
        cast[k] = pick_voice(name, used); used.add(cast[k])
    turns = {}
    for t in d['turns']:
        if t.get('segs'):
            segs = [[s[0], s[1]] + ([s[2]] if len(s) > 2 else [reading(s[1])]) for s in t['segs']]
        else:
            segs = [[t.get('emotion') or 'neutral', t['ko'], reading(t['ko'])]]
        turns[str(t['num'])] = {'segs': segs}
    return {'ep': ep, 'cast': cast, 'turns': turns, '_auto': 'plan_from_dialogue.py'}


def main():
    a = sys.argv[1:]; force = '--force' in a; a = [x for x in a if x != '--force']
    if a == ['--missing']:
        have = set(L.planned())
        a = [e for e in sorted(EP) if e not in have and any(t.get('emotion') or t.get('segs') for t in json.load(open(EP[e], encoding='utf-8'))['turns'])]
    n = 0
    for ep in a:
        p = f'{R}/data/tts/plan/{ep}.json'
        if os.path.exists(p) and not force:
            print('있음(건너뜀)', ep); continue
        json.dump(build(ep), open(p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1); n += 1; print('만듦', ep)
    print('계획', n, '편')


if __name__ == '__main__':
    main()
