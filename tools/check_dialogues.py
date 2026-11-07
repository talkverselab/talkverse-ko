#!/usr/bin/env python3
"""한국어 회화(편 JSON) 검사기 — 일본어앱 tools/check_dialogues.py 의 한국어판(가벼운 판, 2026-11-02).

  python3 tools/check_dialogues.py [--fix-rd] [assets/data/dialogues/R*/**/*.json ...]

검사: 턴 수(레벨·종류) · 턴 길이(어절 수) · 표현 풀 노출 ≥2 · 반전 1회(twist) · 변수 · rd(개정 로마자) · 필수 필드 · 채팅 편 규칙.
새 단어·구간 어휘(형태소 기준)는 아직 없음 — 절벽 기준표의 한국어 값이 "확인 필요" 상태라 붙이지 않았다. 오류가 있으면 종료 코드 1.
"""
import csv, glob, json, re, sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import rd_ko  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]
EXPR = [r['expr'] for r in csv.DictReader(open(ROOT / 'data/expressions/top_expressions.csv', encoding='utf-8'))]
TURNS = {'R0': (6, 8), 'R1': (6, 8), 'R2': (8, 12), 'R3': (12, 16), 'R4': (12, 16)}
WORDS = {'R0': (1, 6), 'R1': (1, 9), 'R2': (1, 12), 'R3': (1, 16), 'R4': (1, 18)}  # 어절(띄어쓰기) 수, 표현 풀 한 덩이 = 1
VARS = {'{name}', '{country}', '{city}', '{lang}'}
NEED = ('id', 'region', 'island', 'kind', 'title', 'scene', 'speakers', 'register', 'twist', 'expressions', 'turns')


def eojeol(ko):
    s = re.sub(r'\{[a-z_]+\}', 'X', ko)
    s = re.sub(r'[\U0001F300-\U0001FAFF\u2600-\u27BF\u2B50\uFE0F]', '', s)  # 어조사 턴의 감정 이모지는 어절로 세지 않는다
    for e in sorted(EXPR, key=len, reverse=True):
        if ' ' in e and e in s:
            s = s.replace(e, 'X')
    return len([w for w in re.split(r'\s+', re.sub(r'[.,!?…~()「」"]', ' ', s)) if w])


def hits(ko):
    out, rest = [], ko
    for e in sorted(EXPR, key=len, reverse=True):
        pat = r'(?<![가-힣])' + re.escape(e.rstrip('?')) + (r'\??' if e.endswith('?') else '')
        if re.search(pat, rest):
            out.append(e); rest = re.sub(pat, ' ', rest, count=1)
    return out


def check(path, fix):
    e = json.load(open(path, encoding='utf-8'))
    eid = e.get('id', path.name); err, warn = [], []
    for k in NEED:
        if not e.get(k):
            err.append(f'메타 {k} 없음')
    reg = e.get('region', 'R1'); ts = e.get('turns', [])
    lo, hi = TURNS[reg]
    if not lo <= len(ts) <= hi:
        err.append(f'턴 수 {len(ts)} (허용 {lo}~{hi})')
    if not isinstance(e.get('twist'), int) or not 1 <= e['twist'] <= len(ts):
        err.append('twist 범위 밖')
    found = []
    for t in ts:
        n, ko = t.get('num'), t.get('ko', '')
        for k in ('ko', 'en', 'speaker'):
            if not t.get(k):
                err.append(f'턴 {n}: {k} 없음')
        if t.get('speaker') not in e.get('speakers', {}):
            err.append(f'턴 {n}: 화자 {t.get("speaker")} 가 speakers 에 없음')
        for v in re.findall(r'\{[a-z_]+\}', ko + t.get('en', '')):
            if v not in VARS:
                err.append(f'턴 {n}: 모르는 변수 {v}')
        w = eojeol(ko); wl, wh = WORDS[reg]
        if w > wh:
            (err if reg in ('R0', 'R1') else warn).append(f'턴 {n}: 어절 {w} > {wh} — {ko}')
        auto = rd_ko.to_rd(ko)
        if not t.get('rd') or (fix and not t.get('rd_manual')):
            t['rd'] = auto
        elif not t.get('rd_manual') and t['rd'] != auto:
            warn.append(f'턴 {n}: rd 가 변환기와 다름 — 맞으면 rd_manual: true')
        found += hits(ko)
        if e.get('kind') == 'chat' and t.get('ui') != 'bubble':
            warn.append(f'턴 {n}: 채팅 편인데 ui=bubble 아님')
    if len(found) < 2:
        err.append(f'표현 풀 노출 {len(found)} < 2')
    if fix:
        json.dump(e, open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    return eid, err, warn, sorted(set(found))


def main():
    a = sys.argv[1:]; fix = '--fix-rd' in a
    files = [Path(p) for p in a if not p.startswith('--')] or [Path(p) for p in sorted(glob.glob(str(ROOT / 'assets/data/dialogues/R*/**/*.json'), recursive=True))]
    total = 0
    for f in files:
        eid, err, warn, found = check(f, fix)
        for w in warn: print('  warn', eid, w)
        for x in err: print('  ERR ', eid, x)
        print(f'{eid}: 오류 {len(err)} 경고 {len(warn)} · 표현 {"·".join(found)}')
        total += len(err)
    print('총 오류', total); sys.exit(1 if total else 0)


if __name__ == '__main__':
    main()
