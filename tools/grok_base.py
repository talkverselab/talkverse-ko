"""Grok CDP 연결 설정 — 어느 맥의 Chrome 을 쓰는지 한 곳에서(2026-11-03 사용자 지시: Grok 은 M4 Chrome 에서).
기본 = M4 의 한국어 전용 Chrome(M4 127.0.0.1:9224, 프로필 ~/chrome-grok-ko)을 M6 로컬 19224 로 터널해서 쓴다:
  ssh -fN -L 19224:127.0.0.1:9224 macmini4
GROK_CDP_PORT 로 포트를, GROK_REMOTE 로 첨부 파일을 보낼 원격 호스트를 바꾼다(GROK_REMOTE= 빈 값이면 로컬 Chrome).
"""
import os, re, subprocess, sys
sys.path.insert(0, '/Users/talkverse/Hanja/tools')
import grok_cdp as g  # noqa: E402

PORT = os.environ.get('GROK_CDP_PORT', '19224')
REMOTE = os.environ.get('GROK_REMOTE', 'macmini4')
g.BASE = f'http://127.0.0.1:{PORT}'


def _ensure_tunnel():
    """터널(로컬 PORT → M4 9224)이 죽어 있으면 다시 연다. 로컬 Chrome(GROK_REMOTE 빈 값)일 땐 하지 않는다."""
    if not REMOTE:
        return
    import urllib.request
    try:
        urllib.request.urlopen(g.BASE + '/json/version', timeout=4).read(); return
    except Exception:
        subprocess.run(['ssh', '-fN', '-o', 'ExitOnForwardFailure=yes', '-L', f'{PORT}:127.0.0.1:9224', REMOTE])


_ensure_tunnel()

_tab = g.tab
def _tab_local(frag):
    t = _tab(frag)  # 원격 Chrome 이 알려 주는 ws 주소의 포트(9224)를 터널 로컬 포트로 바꾼다
    t['webSocketDebuggerUrl'] = re.sub(r'127\.0\.0\.1:\d+', f'127.0.0.1:{PORT}', t['webSocketDebuggerUrl'])
    return t
g.tab = _tab_local


def remote_paths(paths):
    """첨부 파일은 브라우저가 있는 맥의 경로여야 한다 → M4 /tmp/grok_att/ 로 보내고 그 경로를 돌려준다."""
    if not REMOTE:
        return [os.path.abspath(p) for p in paths]
    subprocess.run(['ssh', REMOTE, 'mkdir -p /tmp/grok_att'], check=True)
    out = []
    for p in paths:
        dst = f'/tmp/grok_att/{os.path.basename(p)}'
        subprocess.run(['scp', '-q', p, f'{REMOTE}:{dst}'], check=True)
        out.append(dst)
    return out
