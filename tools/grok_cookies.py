#!/usr/bin/env python3
"""공용 Grok Chrome(M4 9222)의 grok.com 로그인 쿠키를 ko 전용 Chrome(9224)에 CDP 로 옮긴다. python3 tools/grok_cookies.py
sso 는 세션 쿠키라 Cookies 파일에 안 남는다 — Chrome 을 끄면 로그아웃되므로 다시 켠 뒤 이걸 돌린다(2026-11-04).
터널: 로컬 19222→M4 9222(없으면 연다), 19224→9224 는 grok_base 가 연다."""
import json, re, subprocess, sys, time, urllib.request
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent)); from grok_base import g
SRC = 'http://127.0.0.1:19222'
try: urllib.request.urlopen(SRC + '/json/version', timeout=3)
except Exception:
    subprocess.run(['ssh', '-fN', '-o', 'ExitOnForwardFailure=yes', '-L', '19222:127.0.0.1:9222', 'macmini4']); time.sleep(2)
t = [t for t in json.load(urllib.request.urlopen(SRC + '/json/list')) if t['type'] == 'page'][0]
t['webSocketDebuggerUrl'] = re.sub(r'127\.0\.0\.1:\d+', '127.0.0.1:19222', t['webSocketDebuggerUrl'])
ck = [k for k in g.CDP(t).call('Network.getAllCookies')['cookies'] if 'grok.com' in k['domain']]
items = []
for k in ck:
    it = {'name': k['name'], 'value': k['value'], 'domain': k['domain'], 'path': k['path'], 'secure': k['secure'], 'httpOnly': k['httpOnly']}
    if k.get('expires', -1) > 0: it['expires'] = k['expires']
    if k.get('sameSite'): it['sameSite'] = k['sameSite']
    items.append(it)
dst = g.CDP(g.tab(sys.argv[1] if len(sys.argv) > 1 else 'grok.com'))
dst.call('Network.setCookies', cookies=items)
print('옮긴 쿠키', len(items), 'sso' in [k['name'] for k in ck])
