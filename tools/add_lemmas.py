#!/usr/bin/env python3
"""편 JSON 의 턴마다 `lemmas`(내용어 [표면형, 기본형, 로마자]) 를 채운다 — 문장 레마 ↔ 단어장 연결(사용자 지시 2026-11-04, 일본어앱 add_lemmas.py 를 kiwi 로).
내용어 = 일반·고유명사(NNG·NNP), 동사·형용사(VV·VA, 기본형 = 어간+다), 일반 부사(MAG), 어근(XR), 감탄사(IC). 조사·어미·의존명사·보조용언·기호는 뺀다.
단어장(assets/seed/vocab.json)에 없는 레마는 data/review/write/missing_lemmas.csv(빈도순)로 — uk 세션에 넘겨 단어·그림 제작.
  <kovenv>/bin/python tools/add_lemmas.py"""
import csv, glob, json, re, sys
from collections import Counter
from pathlib import Path
from kiwipiepy import Kiwi
ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'tools')); import rd_ko
KEEP = {'NNG', 'NNP', 'VV', 'VA', 'MAG', 'XR', 'IC'}
SKIP = {'하다', '되다', '있다', '없다', '같다', '이렇다', '그렇다', '저렇다', '어떻다', '좀', '안', '못', '더', '또', '잘', '다', '막', '그냥', '아', '어', '오', '응', '네', '예', '음', '헐', '야', '자', '와', '흠', '에이', '아이', '어머'}
VAR = re.compile(r'\{[a-z_]+\}|\([^)]*\)')  # 변수·괄호 지문은 뺀다
kiwi = Kiwi()
CAST = {'유진', '하늘', '태오', '서아', '민준', '도윤', '지호', '해솔', '지안', '민지'}  # 고정 인물 이름은 단어가 아니다
for f in glob.glob(str(ROOT / 'assets/data/dialogues/R*/*/*.json')):
    CAST |= {re.sub(r'\s*\d+$', '', v) for v in json.load(open(f, encoding='utf-8')).get('speakers', {}).values() if not v.startswith('{')}
vocab = {e['word'] for e in json.load(open(ROOT / 'assets/seed/vocab.json', encoding='utf-8'))}
miss = Counter(); ex = {}; tot = hit = 0
for f in sorted(glob.glob(str(ROOT / 'assets/data/dialogues/R*/*/*.json'))):
    d = json.load(open(f, encoding='utf-8')); ch = False
    for t in d['turns']:
        out = []; src = VAR.sub(' ', t['ko'])
        for tok in kiwi.tokenize(src):
            if tok.tag not in KEEP: continue
            base = tok.form + '다' if tok.tag in ('VV', 'VA') else tok.form
            if base in SKIP or base in CAST or len(base) < 1 or not re.search(r'[가-힣]', base): continue
            surf = src[tok.start:tok.start + tok.len]
            out.append([surf, base, rd_ko.to_rd(base)]); tot += 1
            if base in vocab: hit += 1
            else: miss[base] += 1; ex.setdefault(base, t['ko'])
        if t.get('lemmas') != out: t['lemmas'] = out; ch = True
    if ch: json.dump(d, open(f, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
with open(ROOT / 'data/review/write/missing_lemmas.csv', 'w', encoding='utf-8', newline='') as fo:
    w = csv.writer(fo); w.writerow(['lemma', 'romanization', 'count', 'example'])
    for b, n in miss.most_common(): w.writerow([b, rd_ko.to_rd(b), n, ex[b]])
print(f'내용어 {tot} · 단어장 있음 {hit/tot:.0%} · 없는 레마 {len(miss)} → data/review/write/missing_lemmas.csv')
