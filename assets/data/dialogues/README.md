# 회화 데이터 구조 (talkverse-ko) — 2026-11-02

일본어앱(`talkverselab/talkverse-ja` `assets/data/dialogues/README.md`)과 같은 모양. 공통 원칙 https://talkverse.uk/talkverse/dialogue-rules/ .

```
assets/data/dialogues/R<레벨>/<주제>/<id>.json   R0 왕초보 · R1 초보 · R2 중급 · R3 고급 · R4 최상급
```
주제(island) = survival · friends · love · life · travel · culture · work · study. 고정 인물: 연애 = 유진(남녀 모두 쓰는 이름).

## 편 JSON (일본어앱과 다른 점만)
- 턴: `ko`(목표어 한국어) · `rd`(개정 로마자, `tools/rd_ko.py` — 틀리면 `rd_manual: true`) · `en`(학습자 언어 = 영어) · `note`(영어 학습 메모).
- `kdrama`: K-드라마 클리셰를 일부러 쓰는 편만 그 장면 한 줄(예: 「비 오는 날 우산 하나」). 없으면 일상 편 — **모든 편이 클리셰면 안 된다**(사용자 지시 2026-11-02).
- 제작: 초안 → `tools/check_dialogues.py` → `tools/grok_prompt.py`(틀 `tools/prompts/rewrite_grok.md`, 「유지」 금지) → Grok 「한국어 회화 검수」 재작성 → `tools/apply_rewrite.py` → 최소 수정 → `tools/review_html.py data/review/REVIEW_ko.html …` → https://talkverse.uk/talkverse/review/ko/ .
- 아직 앱(pubspec assets)에 넣지 않았다 — 지금 앱은 옛 시드(`assets/seed/`)를 쓴다.

## 턴의 감정 열 (2026-11-07 사용자 지시, 모든 언어 공통)

앞으로 쓰는 회화는 턴마다 `emotion` 을 넣는다 — 값은 `data/tts/PLAN_GUIDE.md` 의 16개(neutral polite stiff cheerful amused teasing excited surprised shout tsukkomi annoyed sad worried flustered shy gentle).
한 턴에서 감정이 바뀌면 `segs: [[감정, 본문], …]` 로 나눈다(이어 붙이면 `ko` 와 같아야 함). 밋밋하게 neutral 만 쓰지 않는다. 음성 생성(`tools/tts/`)이 이 값을 그대로 쓴다.
