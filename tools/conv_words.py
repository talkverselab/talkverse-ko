"""회화 단어 목록 — 회화 전 편의 레마 중 절벽 단어표 2,000위 밖이면서 단어 DB(assets/seed/vocab.json)에 있는 것.
절벽 단어 화면의 「회화 단어 포함」이 읽는다(사용자 지시 2026-11-07, 일본어앱 tools/freq/conv_words.py 와 같음). 인물 이름은 뺀다.
  python3 tools/conv_words.py  → assets/data/freq/conv_words_ko.json"""
import json, glob, collections, os
v = json.load(open('assets/seed/vocab.json'))
v = v if isinstance(v, list) else v['vocab']
db = {x['word']: x for x in v}
top = {x['word'] for x in v if x['rank'] <= 2000}
SKIP = set()
for f in glob.glob('assets/data/dialogues/R*/**/*.json', recursive=True):
    for name in json.load(open(f)).get('speakers', {}).values():
        if '{' not in name: SKIP.add(name)
lem = collections.Counter(); rd = {}
for f in glob.glob('assets/data/dialogues/R*/**/*.json', recursive=True):
    for t in json.load(open(f)).get('turns', []):
        for l in t.get('lemmas', []):
            if len(l) >= 2 and l[1] not in top and l[1] not in SKIP:
                lem[l[1]] += 1; rd.setdefault(l[1], l[2] if len(l) > 2 else '')
out = [{'word': w, 'rd': rd.get(w, ''), 'en': db[w].get('gloss_en') or '', 'n': c} for w, c in lem.most_common() if w in db]
os.makedirs('assets/data/freq', exist_ok=True)
json.dump({'_meta': '회화 레마 중 절벽 단어표(2,000위) 밖이면서 단어 DB에 있는 것 · tools/conv_words.py', 'words': out},
          open('assets/data/freq/conv_words_ko.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
print(len(lem), '→', len(out))
