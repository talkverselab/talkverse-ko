"""편 작업 기록(review: 어떤 도구·누가 언제 다시 썼나)은 앱 묶음·서버 공개 원고에 넣지 않고 여기 따로 둔다
(uk 심사 점검 F, 2026-11-23 — 공개 주소로 열리는 원고에 출처 이름이 보이지 않게). data/review/dialogue_review.json = {편id: {...}}."""
import json
from pathlib import Path
F = Path(__file__).resolve().parent.parent / 'data/review/dialogue_review.json'


def load():
    return json.loads(F.read_text(encoding='utf-8')) if F.exists() else {}


def get(eid):
    return load().get(eid, {})


def update(eid, **kv):
    m = load(); m.setdefault(eid, {}).update(kv)
    F.write_text(json.dumps(m, ensure_ascii=False, indent=1, sort_keys=True) + '\n', encoding='utf-8')


def replace(eid, rec):
    m = load(); m[eid] = rec
    F.write_text(json.dumps(m, ensure_ascii=False, indent=1, sort_keys=True) + '\n', encoding='utf-8')
