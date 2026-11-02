#!/usr/bin/python3
"""Grok 에 그림 1장 요청 → 생성이 끝날 때까지 기다려 jpg 로 저장(로그인된 전용 Chrome 안에서 받아 옴).
  /usr/bin/python3 tools/grok_image.py <요청문.md> <저장.jpg> [--tab 91501f08] [--attach a.jpg,b.jpg] [--wait 600]
출력 마지막 줄: OK <저장.jpg> <답 글자 수> | NOIMAGE | TIMEOUT
"""
import base64, os, subprocess, sys, time
sys.path.insert(0, '/Users/talkverse/Hanja/tools'); import grok_cdp as g
g.BASE = 'http://127.0.0.1:' + os.environ.get('GROK_CDP_PORT', '9224')
a = sys.argv[1:]; src, dst = a[0], a[1]
frag = a[a.index('--tab') + 1] if '--tab' in a else '91501f08'
wait = int(a[a.index('--wait') + 1]) if '--wait' in a else 600
here = os.path.dirname(os.path.abspath(__file__))
before = len(g.CDP(g.tab(frag)).ev("[...document.querySelectorAll('.response-content-markdown')]") or [])
cmd = ['/usr/bin/python3', f'{here}/grok_send.py', src, dst + '.md', '--tab', frag, '--wait', '45']
if '--attach' in a: cmd += ['--attach', a[a.index('--attach') + 1]]
subprocess.run(cmd, capture_output=True, text=True)
t0 = time.time()
while time.time() - t0 < wait:
    c = g.CDP(g.tab(frag))
    n = len(c.ev("[...document.querySelectorAll('.response-content-markdown')]") or [])
    busy = c.ev("document.body.innerText.includes('생성 중') || document.body.innerText.includes('작업 중') || !![...document.querySelectorAll('button')].find(e=>(e.getAttribute('aria-label')||'')==='응답 중지')")
    imgs = c.ev("(()=>{const r=[...document.querySelectorAll('.response-content-markdown')];const l=r[r.length-1];return l?[...l.querySelectorAll('img')].map(i=>i.src).filter(s=>s.includes('generated')):[]})()") or []
    if n > before and not busy and imgs:
        u = imgs[0]
        r = c.call('Runtime.evaluate', expression=f"fetch('{u}',{{credentials:'include'}}).then(r=>r.blob()).then(b=>new Promise(res=>{{const f=new FileReader();f.onload=()=>res(f.result);f.readAsDataURL(b)}}))", awaitPromise=True, returnByValue=True)
        open(dst, 'wb').write(base64.b64decode(r['result']['value'].split(',', 1)[1]))
        txt = c.ev("(()=>{const r=[...document.querySelectorAll('.response-content-markdown')];return r[r.length-1].innerText})()")
        open(dst + '.md', 'w', encoding='utf-8').write(txt + '\n\n[images]\n' + '\n'.join(imgs))
        print('OK', dst, len(txt)); sys.exit(0)
    if n > before and not busy and time.time() - t0 > 120:
        print('NOIMAGE'); sys.exit(2)
    time.sleep(10)
print('TIMEOUT'); sys.exit(1)
