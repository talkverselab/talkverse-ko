#!/usr/bin/env python3
"""한국어 → 개정 로마자(발음대로) 변환 — 회화 턴 `rd` 자동 채움용.

  python tools/rd_ko.py "데워 드릴까요?"   → deowo deurilkkayo?

띄어쓰기 단위(어절) 안에서만 소리 바뀜을 적용한다: 연음·ㅎ 탈락/격음화·비음화·유음화·구개음화.
된소리되기는 개정 로마자가 표기하지 않으므로 무시. 틀리면 턴에 `rd_manual: true` 와 손 표기.
"""
import re
import sys

INI = ['g', 'kk', 'n', 'd', 'tt', 'r', 'm', 'b', 'pp', 's', 'ss', '', 'j', 'jj', 'ch', 'k', 't', 'p', 'h']
MED = ['a', 'ae', 'ya', 'yae', 'eo', 'e', 'yeo', 'ye', 'o', 'wa', 'wae', 'oe', 'yo', 'u', 'wo', 'we', 'wi', 'yu', 'eu', 'ui', 'i']
# 받침(종성) 인덱스 → 자모
FIN = ['', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ']
INI_J = ['ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ']
# 겹받침 → (남는 받침, 다음 음절로 넘어가는 자음)
SPLIT = {'ㄳ': ('ㄱ', 'ㅅ'), 'ㄵ': ('ㄴ', 'ㅈ'), 'ㄶ': ('ㄴ', 'ㅎ'), 'ㄺ': ('ㄹ', 'ㄱ'), 'ㄻ': ('ㄹ', 'ㅁ'), 'ㄼ': ('ㄹ', 'ㅂ'),
         'ㄽ': ('ㄹ', 'ㅅ'), 'ㄾ': ('ㄹ', 'ㅌ'), 'ㄿ': ('ㄹ', 'ㅍ'), 'ㅀ': ('ㄹ', 'ㅎ'), 'ㅄ': ('ㅂ', 'ㅅ'), 'ㄲ': ('', 'ㄲ'), 'ㅆ': ('', 'ㅆ')}
# 대표음(음절 끝소리)
REP = {'ㄱ': 'K', 'ㄲ': 'K', 'ㅋ': 'K', 'ㄳ': 'K', 'ㄺ': 'K', 'ㄴ': 'N', 'ㄵ': 'N', 'ㄶ': 'N', 'ㄷ': 'T', 'ㅅ': 'T', 'ㅆ': 'T',
       'ㅈ': 'T', 'ㅊ': 'T', 'ㅌ': 'T', 'ㅎ': 'T', 'ㄹ': 'L', 'ㄼ': 'L', 'ㄽ': 'L', 'ㄾ': 'L', 'ㅀ': 'L', 'ㅁ': 'M', 'ㄻ': 'M',
       'ㅂ': 'P', 'ㅍ': 'P', 'ㅄ': 'P', 'ㄿ': 'P', 'ㅇ': 'NG', '': ''}
REP_ROM = {'K': 'k', 'N': 'n', 'T': 't', 'L': 'l', 'M': 'm', 'P': 'p', 'NG': 'ng', '': ''}
ASP = {'ㄱ': 'ㅋ', 'ㄷ': 'ㅌ', 'ㅂ': 'ㅍ', 'ㅈ': 'ㅊ'}


def _syl(word):
    out = []
    for ch in word:
        c = ord(ch) - 0xAC00
        if 0 <= c < 11172:
            out.append([INI_J[c // 588], c % 588 // 28, FIN[c % 28]])
        else:
            out.append(ch)
    return out


def _word(word):
    s = _syl(word)
    n = len(s)
    for i in range(n - 1):
        a, b = s[i], s[i + 1]
        if isinstance(a, str) or isinstance(b, str):
            continue
        f, nxt = a[2], b[0]
        if not f:
            continue
        if nxt == 'ㅇ':  # 연음(뒤가 모음)
            if f == 'ㅇ':
                continue
            if f in ('ㅎ',):
                a[2] = ''; continue
            if f in ('ㄷ', 'ㅌ') and b[1] == 20:  # 구개음화: 굳이·같이
                a[2] = ''; b[0] = 'ㅈ' if f == 'ㄷ' else 'ㅊ'; continue
            keep, move = SPLIT.get(f, ('', f))
            if move == 'ㅎ':
                a[2] = keep; continue
            a[2], b[0] = keep, move
            continue
        if f == 'ㅎ' or f in ('ㄶ', 'ㅀ'):  # ㅎ 받침 + ㄱㄷㅈ → 격음
            if nxt in ASP:
                a[2] = {'ㅎ': '', 'ㄶ': 'ㄴ', 'ㅀ': 'ㄹ'}[f]; b[0] = ASP[nxt]; continue
            if nxt == 'ㅅ':
                a[2] = {'ㅎ': '', 'ㄶ': 'ㄴ', 'ㅀ': 'ㄹ'}[f]; b[0] = 'ㅆ'; continue
            if nxt == 'ㄴ' and f == 'ㅎ':
                a[2] = 'ㄴ'; continue
        r = REP.get(f, '')
        if nxt == 'ㅎ' and r in ('K', 'T', 'P') and f not in ('ㅅ', 'ㅆ'):  # 받침 ㄱㄷㅂㅈ + ㅎ → 격음
            b[0] = {'K': 'ㅋ', 'T': 'ㅌ', 'P': 'ㅍ'}[r]; a[2] = SPLIT.get(f, (f, ''))[0] if f in SPLIT and SPLIT[f][0] else ''
            if f == 'ㅈ': b[0] = 'ㅊ'
            continue
        if nxt in ('ㄴ', 'ㅁ') and r in ('K', 'T', 'P'):  # 비음화
            a[2] = {'K': 'ㅇ', 'T': 'ㄴ', 'P': 'ㅁ'}[r]; continue
        if nxt == 'ㄹ':
            if r == 'N':  # 유음화 ㄴ+ㄹ
                a[2] = 'ㄹ'; continue
            if r in ('K', 'P', 'M', 'NG', 'T'):  # ㄹ의 비음화
                b[0] = 'ㄴ'
                if r in ('K', 'P', 'T'):
                    a[2] = {'K': 'ㅇ', 'T': 'ㄴ', 'P': 'ㅁ'}[r]
                continue
        if r == 'L' and nxt == 'ㄴ':  # 유음화 ㄹ+ㄴ
            b[0] = 'ㄹ'; continue
    out = []
    for i, x in enumerate(s):
        if isinstance(x, str):
            out.append(x); continue
        ini, med, fin = x
        prev_l = i > 0 and not isinstance(s[i - 1], str) and REP.get(s[i - 1][2], '') == 'L'
        if ini == 'ㄹ':
            ro = 'l' if prev_l else 'r'
        else:
            ro = INI[INI_J.index(ini)]
        out.append(ro + MED[med] + REP_ROM[REP.get(fin, '')])
    return ''.join(out)


def to_rd(text):
    """문장 → 로마자. {변수}·숫자·영문·문장부호는 그대로."""
    parts = re.split(r'(\{[a-z_]+\}|[^가-힣]+)', text)
    return ''.join(_word(p) if re.fullmatch(r'[가-힣]+', p or '') else p for p in parts)


if __name__ == '__main__':
    for arg in sys.argv[1:] or ['안녕하세요. 주문 도와드릴까요?', '같이 먹어요', '좋아해', '입학', '신라', '설날', '읽어요', '많이요', '못 해요', '{name} 씨, 진짜?']:
        print(arg, '→', to_rd(arg))
