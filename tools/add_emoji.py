#!/usr/bin/env python3
"""어조사(문장 끝 종결어미로 감정을 드러내는 말) 턴에 감정에 어울리는 이모지 하나를 `ko` 끝에 붙인다(사용자 지시 2026-11-07, 기존 회화 포함).
감정은 data/tts/plan/<편id>.json 의 마지막 조각 감정(없으면 턴의 emotion, 없으면 neutral). 이미 이모지가 있는 턴·어조사가 없는 턴·채팅 스탬프 턴은 건드리지 않는다.
  python3 tools/add_emoji.py [--dry] [편id...]"""
import glob, json, os, re, sys
R = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EMOJI = re.compile(r'[\U0001F300-\U0001FAFF☀-➿⭐️]')
# 문장 끝(문장부호·ㅋㅋ·공백 앞)에 오는 어조사·감정 종결어미
TAIL = re.compile(r'(?<=[가-힣])(잖아요?|거든요?|네요|네|지요|죠|지|구나|군요|군|다니|라니|다니까요?|라니까요?|니까요?|는데요|은데요|ㄴ데요|는데|은데|ㄴ데|더라고요?|더라|던데요?|나요|을까요|ㄹ까요|을까|ㄹ까|대요|래요|냐고|다고요?|라고요?|걸요|ㄹ걸|을걸|잖니|거든)[\s]*[.?!…~ㅋㅎㅠㅜ]*$')  # 단순 존댓말 '요' 는 어조사로 치지 않는다
PICK = {
 'cheerful': '😊', 'amused': '😄', 'teasing': '😏', 'excited': '🤩', 'surprised': '😮', 'shout': '😱', 'tsukkomi': '😤',
 'annoyed': '😒', 'sad': '😢', 'worried': '😟', 'flustered': '😳', 'shy': '☺️', 'gentle': '🙂', 'polite': '🙂', 'stiff': '😐', 'neutral': '',
}
# 담담한 턴은 어조사별로 가벼운 이모지
NEUTRAL_TAIL = {'잖아': '🙂', '거든': '🙂', '네': '🙂', '지': '🙂', '구나': '🤔', '군': '🤔', '다니': '😮', '라니': '😮', '더라': '🙂', '던데': '🤔', '나요': '🤔', '까': '🤔', '대요': '🙂', '래요': '🙂', '걸': '🙂'}


def main():
    a = sys.argv[1:]; dry = '--dry' in a; ids = [x for x in a if x != '--dry']
    files = sorted(glob.glob(f'{R}/assets/data/dialogues/R[0-4]/*/*.json'))
    if ids:
        files = [f for f in files if os.path.basename(f)[:-5] in ids]
    n = m = 0
    for f in files:
        ep = os.path.basename(f)[:-5]; raw = open(f, encoding='utf-8').read(); d = json.loads(raw)
        pf = f'{R}/data/tts/plan/{ep}.json'; P = json.load(open(pf, encoding='utf-8'))['turns'] if os.path.exists(pf) else {}
        changed = False
        for t in d['turns']:
            ko = t['ko']
            if EMOJI.search(ko) or t.get('stamp') or not re.search(r'[가-힣]', ko):
                continue
            body = re.sub(r'\([^)]*\)', '', ko).strip()
            mt = TAIL.search(body)
            if not mt:
                continue
            segs = (P.get(str(t['num'])) or {}).get('segs') or []
            emo = segs[-1][0] if segs else (t.get('emotion') or 'neutral')
            e = PICK.get(emo, '')
            if not e:
                tail = mt.group(1)
                e = next((v for k, v in NEUTRAL_TAIL.items() if k in tail), '')
            if not e:
                continue
            t['ko'] = ko.rstrip() + ' ' + e; changed = True; m += 1
        if changed:
            n += 1
            if not dry:
                ind = 2 if raw.startswith('{\n  "') else 1
                json.dump(d, open(f, 'w', encoding='utf-8'), ensure_ascii=False, indent=ind)
                if raw.endswith('\n'):
                    open(f, 'a').write('\n')
    print(('[dry] ' if dry else '') + f'편 {n} · 턴 {m}')


if __name__ == '__main__':
    main()
