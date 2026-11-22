#!/usr/bin/env python3
"""대사가 바뀌어 옛 음성이 안 맞는 줄을 서버 음성 목록(D1 audio_lines)에서 뺀다 → 앱은 그 줄을 기기 TTS 로 읽는다(lib/drama/drama_audio.dart speakTurn).
새 음성을 pack.py --upload 로 올리면 그 편의 줄이 다시 들어가 녹음이 먼저 나온다(사용자 지시 2026-11-22 「음성이 없는건 TTS로」).
  python3 tools/tts/drop_stale.py            빠질 줄만 보여 줌
  python3 tools/tts/drop_stale.py --apply    백업(data/tts/stale_backup_<시각>.json) 뒤 D1 에서 지움
기준: 서버 줄의 녹음 문장(text) ≠ 음성 계획(data/tts/plan, 대사를 바꿀 때 함께 고침)의 그 판 문장."""
import datetime, json, os, subprocess, sys, tempfile, urllib.request
import ttslib as L

W = ['npx', '-y', 'wrangler@4']
items = json.load(urllib.request.urlopen('https://auth.talkverse.uk/art/ko/audio/manifest', timeout=60))['items']
cache, stale = {}, []
for x in items:
    ep = x['episode']
    if ep not in L.EP:
        continue
    if ep not in cache:
        cache[ep] = {t['num']: t for t in L.turns(ep)}
    t = cache[ep].get(x['turn'])
    if t and t[x['voice']]['text'] != x.get('text'):
        stale.append(x)
turns = sorted({(x['episode'], x['turn']) for x in stale})
print('옛 음성 줄', len(stale), '· 턴', len(turns))
if '--apply' not in sys.argv or not stale:
    sys.exit(0)
bk = f'{L.R}/data/tts/stale_backup_{datetime.datetime.now():%Y%m%d_%H%M}.json'
json.dump(stale, open(bk, 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
sql = [f"DELETE FROM audio_lines WHERE lang='ko' AND episode='{e}' AND turn={n};" for e, n in turns]
sf = os.path.join(tempfile.mkdtemp(), 'drop.sql'); open(sf, 'w').write('\n'.join(sql) + '\n')
r = subprocess.run(W + ['d1', 'execute', 'talkverse-db', '--remote', '--file', sf, '-y'], cwd=L.R, capture_output=True, text=True)
if r.returncode:
    sys.exit('D1 실패 ' + r.stderr[-400:] + r.stdout[-300:])
print('지움 — 백업', os.path.relpath(bk, L.R))
