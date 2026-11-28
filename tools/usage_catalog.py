#!/usr/bin/env python3
"""화면 열람 목록 내보내기 → tool/usage_catalog.json (uk 가 서버에 올린다: tools/usage_catalog.sh ko <파일>).

page ID 는 lib/data/usage_pages.dart 와 글자까지 같다. tier 는 lib/data/entitlement.dart 의 잠금 기준:
  회화 편 ep/<id>      — R0·R1 free, 그 밖 pro
  언어감각 sense/<id>  — 보이는 급(내용 있는 회차가 있는 급) 순서로 freeSenseLevels 급까지 free, 그 밖 pro
  나머지(기본 회화 장면·단어·조사·외래어·한자·한글) — free
쓰는 법: python3 tools/usage_catalog.py [--build N]   (N 없으면 GitHub latest.json 의 build)
"""
import glob, json, os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PAGE_RE = re.compile(r'^[\w./:#-]{1,120}$', re.ASCII)


def load(p):
    with open(os.path.join(ROOT, p), encoding='utf-8') as f:
        return json.load(f)


def has_content(ls):  # SenseCourse.hasContent
    if ls.get('open') is not None:
        return True
    for k in ('sentences', 'points', 'footnotes', 'items', 'rules', 'body', 'video'):
        v = ls.get(k)
        if isinstance(v, list) and v:
            return True
        if isinstance(v, str) and v.strip():
            return True
    return False


def build_no():
    if '--build' in sys.argv:
        return int(sys.argv[sys.argv.index('--build') + 1])
    try:
        out = subprocess.run(['curl', '-sL', 'https://github.com/talkverselab/talkverse-ko/releases/download/latest/latest.json'],
                             capture_output=True, text=True, timeout=20).stdout
        return int(json.loads(out)['build'])
    except Exception:
        return 0


def main():
    pages = []
    for p in sorted(glob.glob(os.path.join(ROOT, 'assets/data/dialogues/R[0-4]/*/*.json'))):
        e = json.load(open(p, encoding='utf-8'))
        region = e.get('region') or 'R1'
        pages.append({'page': f"ep/{e['id']}", 'tier': 'free' if region in ('R0', 'R1') else 'pro', 'title': e.get('title', '')})
    free_sense = int(load('assets/curriculum_ko.json').get('freeSenseLevels', 1))
    vis = 0
    for lv in load('assets/data/grammar/sense_course.json').get('levels', []):
        lessons = [ls for ls in lv.get('lessons', []) if has_content(ls)]
        if not lessons:
            continue
        for ls in lessons:
            pages.append({'page': f"sense/{ls['id']}", 'tier': 'free' if vis < free_sense else 'pro',
                          'title': f"{lv.get('title', '')} — {ls.get('title', ls['id'])}"})
        vis += 1
    for s in load('assets/seed/scenarios.json'):
        pages.append({'page': f"scn/{s['id']}", 'tier': 'free', 'title': s.get('title_en') or s.get('title_ko') or s['id']})
    for pid, title in (('vocab', 'Cliff words R1-R5'), ('particles', 'Particles & endings'), ('loanwords', 'Loanwords'),
                       ('loanwords/quiz', 'Loanword quiz'), ('hanja', 'Hanja practice'), ('hangul', 'Hangul & pronunciation')):
        pages.append({'page': pid, 'tier': 'free', 'title': title})
    bad = [x['page'] for x in pages if not PAGE_RE.match(x['page'])]
    ids = [x['page'] for x in pages]
    assert not bad, bad
    assert len(ids) == len(set(ids)), 'duplicate page id'
    out = os.path.join(ROOT, 'tool/usage_catalog.json')
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with open(out, 'w', encoding='utf-8') as f:
        json.dump({'build': build_no(), 'pages': pages}, f, ensure_ascii=False, indent=1)
        f.write('\n')
    tiers = {}
    for x in pages:
        tiers[x['tier']] = tiers.get(x['tier'], 0) + 1
    print(out, len(pages), tiers)


if __name__ == '__main__':
    main()
