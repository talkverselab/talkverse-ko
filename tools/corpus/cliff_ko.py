#!/usr/bin/env python3
"""한국어 절벽구간 — 일본어앱과 같은 방식(2026-11-03 사용자 지시, 일본어앱 세션 절차 확인).

  python cliff_ko.py <자막 말뭉치.zip> <출력 폴더> [--max-docs N]

- 단위: kiwi 형태소. 조사(J*)·어미(E*)·접사도 각각 한 토큰으로 세어 분자·분모 모두에 넣는다(일본어 조사·조동사와 같게).
  용언(VV·VA·VX·VCP·VCN·XSV·XSA)은 기본형 「어간+다」. 기호(S*)·숫자(SN)·외국어(SL·SH)는 뺀다. 고유명사·감탄사는 남긴다.
- frequency = 토큰 수 ÷ 전체 토큰 수(가중 없음), cum_pct = 1위부터 누적.
- 구간: 2,500위까지의 최대 누적 max 를 80%로 보고 비례 — R1 = cum ≥ max×55/80 첫 순위, R2 = ×60/80, R3 = ×70/80, R4 = 2,500.
- 말뭉치: zip 안의 문서(.xml 자막 한 편 또는 .txt 줄). 공개 저장소에는 말뭉치 이름을 적지 않는다 — 결과 파일엔 「N편·M만 토큰」만.
출력: lang_ko_top2500.csv(rank,word,pos,frequency,cum_pct,region) · ko_cliff_summary.json
"""
import csv, io, json, re, sys, zipfile, gzip, time
from collections import Counter
from kiwipiepy import Kiwi

src, out = sys.argv[1], sys.argv[2]
maxdocs = int(sys.argv[sys.argv.index('--max-docs') + 1]) if '--max-docs' in sys.argv else 0
# --only <파일>: 작품 번호(자막 폴더 이름) 목록 — 자국(한국) 제작 영화·드라마만 쓰기(사용자 원칙). 목록은 공개 작품 DB 의 「제작 국가 = 대한민국」 + 그 시리즈의 회차로 만든다.
only = set(open(sys.argv[sys.argv.index('--only') + 1]).read().split()) if '--only' in sys.argv else None
VERB = ('VV', 'VA', 'VX', 'VCP', 'VCN', 'XSV', 'XSA')
DROP = ('SF', 'SP', 'SS', 'SSO', 'SSC', 'SE', 'SO', 'SW', 'SN', 'SL', 'SH', 'SB', 'W_URL', 'W_EMAIL', 'W_HASHTAG', 'W_MENTION', 'W_SERIAL', 'W_EMOJI', 'UN')
TAG_RE = re.compile(r'<[^>]+>')

def docs(zf):
    n = 0; seen = set()
    for name in zf.namelist():
        if name.endswith('/'):
            continue
        if name.endswith('.xml'):  # 같은 작품의 자막 여러 판 → 작품 폴더(…/<연도>/<id>/)당 한 파일만
            key = name.rsplit('/', 1)[0]
            if only is not None and re.match(r'\d+', key.rsplit('/', 1)[1]).group(0).lstrip('0') not in only:  # 드라마 회차 폴더 = 「시리즈번호_회차번호_시즌_회」 → 앞 번호로
                continue
            if key in seen:
                continue
            seen.add(key)
        data = zf.read(name)
        if name.endswith('.gz'):
            data = gzip.decompress(data)
        text = data.decode('utf-8', 'ignore')
        if name.endswith('.xml'):
            lines = [TAG_RE.sub(' ', l) for l in re.findall(r'<s\b[^>]*>(.*?)</s>', text, re.S)] or [TAG_RE.sub(' ', text)]
            # 청각장애인용 자막의 소리 설명 「(신음)」「[음악]」「♪…」 은 대사가 아니므로 뺀다
            lines = [re.sub(r'\([^)]*\)|\[[^\]]*\]|（[^）]*）|♪[^♪]*♪?|^\s*-\s*', ' ', l) for l in lines]
            SDH = re.compile(r'^(음악|숨소리|웃음|웃음소리|신음|비명|한숨|박수|노크|초인종|벨소리|전화벨|발소리|문소리|흐느낌|울음|기침|탄성|함성|환호|효과음|노래|노랫소리)+[\s.…!]*$')
            yield [l for l in (re.sub(r'\s+', ' ', x).strip() for x in lines) if l and not SDH.match(l)]
            n += 1
        else:  # 한 줄 = 한 문장, 파일 하나를 여러 "편"으로 쪼개지 않고 줄 묶음 1만 줄을 한 묶음으로
            buf = []
            for l in text.splitlines():
                if l.strip():
                    buf.append(l.strip())
                if len(buf) >= 10000:
                    yield buf; buf = []; n += 1
                    if maxdocs and n >= maxdocs: return
            if buf: yield buf; n += 1
        if maxdocs and n >= maxdocs:
            return

kiwi = Kiwi(num_workers=4)
cnt = Counter(); pos = {}; total = 0; ndoc = 0; t0 = time.time()
with zipfile.ZipFile(src) as zf:
    for lines in docs(zf):
        ndoc += 1
        for toks in kiwi.tokenize(lines):
            for t in toks:
                tag = t.tag.split('-')[0]
                if tag in DROP or not re.search(r'[가-힣ㄱ-ㅎㅏ-ㅣ]', t.form):
                    continue
                w = t.form + '다' if tag in VERB else t.form
                cnt[w] += 1; total += 1; pos.setdefault(w, tag)
        if ndoc % 500 == 0:
            print(f'{ndoc}편 {total/1e6:.1f}M 토큰 {time.time()-t0:.0f}s', flush=True)

top = cnt.most_common(2500); acc = 0.0; rows = []
for i, (w, c) in enumerate(top, 1):
    f = c / total; acc += f; rows.append([i, w, pos[w], round(f, 8), round(acc * 100, 4)])
mx = rows[-1][4]
cut = {}
for name, p in (('R1', 55), ('R2', 60), ('R3', 70)):
    need = mx * p / 80
    cut[name] = next(r[0] for r in rows if r[4] >= need)
cut['R4'] = 2500
for r in rows:
    r.append('R1' if r[0] <= cut['R1'] else 'R2' if r[0] <= cut['R2'] else 'R3' if r[0] <= cut['R3'] else 'R4')
with open(f'{out}/lang_ko_top2500.csv', 'w', encoding='utf-8', newline='') as fo:
    w = csv.writer(fo); w.writerow(['rank', 'word', 'pos', 'frequency', 'cum_pct', 'region']); w.writerows(rows)
summ = {'docs': ndoc, 'tokens': total, 'types': len(cnt), 'max_cum_2500': mx, 'R1': cut['R1'], 'R2': cut['R2'], 'R3': cut['R3'], 'R4': 2500,
        'cum_at': {k: rows[v - 1][4] for k, v in cut.items()}, 'method': 'kiwi 형태소, 조사·어미 포함, 용언 기본형, 기호·숫자·외국어 제외, 가중 없음, 비례 구간(55/60/70/80 ÷ 80 × max)'}
json.dump(summ, open(f'{out}/ko_cliff_summary.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print(json.dumps(summ, ensure_ascii=False))
