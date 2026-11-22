#!/usr/bin/env python3
"""이미 올린 편의 나쁜 조각만 다시 만든다(2026-11-23 — qa 캐시가 옛 녹음 점수를 써서 재생성이 빠졌던 43편 손보기).
  <venv>/bin/python tools/tts/retake.py <작업폴더> <편id>...
qa → PC 재생성(3090) → 받아 오기 → qa 가 더 나은 판을 본 파일로 고름, 세 번까지 → pack --upload 로 서버 음성 교체.
PC 작업 폴더의 moss_jobs.json 만 새로 쓴다. 3090 을 다른 언어와 나눠 쓰니 uk 가 순서를 준 뒤에만 돌릴 것. <작업폴더>/STOP 이 있으면 회차 경계에서 멈춤."""
import glob, json, os, subprocess, sys, time
HERE = os.path.dirname(os.path.abspath(__file__))
work, eps = sys.argv[1], sys.argv[2:]
PC = 'Administrator@100.127.143.37'
log = lambda *a: print(time.strftime('%H:%M:%S'), *a, flush=True)
sh = lambda *a, check=True: subprocess.run(a, check=check, capture_output=True, text=True)


def pc_run():
    if os.path.exists(f'{work}/STOP'):
        log('STOP — 멈춤'); sys.exit(0)
    while 'Ready' not in sh('ssh', PC, "(Get-ScheduledTask -TaskName 'TTS job 2060').State", check=False).stdout:
        time.sleep(30)
    sh('scp', '-q', f'{work}/job/moss_jobs.json', f'{PC}:D:/tts_test/job/')
    sh('ssh', PC, "Remove-Item D:\\tts_test\\job\\vox_jobs.json -ErrorAction SilentlyContinue; Start-ScheduledTask -TaskName 'TTS job 2060'")
    time.sleep(20)
    while 'Ready' not in sh('ssh', PC, "(Get-ScheduledTask -TaskName 'TTS job 2060').State", check=False).stdout:
        time.sleep(30)


def fetch(path):
    os.makedirs(os.path.dirname(f'{work}/wav/{path}'), exist_ok=True)
    sh('scp', '-q', '-r', f'{PC}:D:/tts_test/job/out/ko/{path}', os.path.dirname(f'{work}/wav/{path}') + '/', check=False)


os.makedirs(f'{work}/job', exist_ok=True)
for rnd in range(4):
    jobs = []
    for ep in eps:
        p = f'{work}/job/qa_{ep}.json'
        r = subprocess.run([sys.executable, f'{HERE}/qa.py', f'{work}/wav', ep, '--jobs', p], capture_output=True, text=True, timeout=900)
        log(ep, (r.stdout.strip().splitlines() or [r.stderr.strip()[-200:]])[-1])
        if os.path.exists(p):
            jobs += json.load(open(p)); os.remove(p)
    log('회차', rnd, '재생성', len(jobs))
    if not jobs or rnd == 3:
        break
    json.dump(jobs, open(f'{work}/job/moss_jobs.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
    pc_run()
    for ep in eps:
        fetch(f'retake/{ep}')
for ep in eps:
    r = sh(sys.executable, f'{HERE}/pack.py', f'{work}/wav', ep, '--upload', check=False)
    log(ep, '올림' if r.returncode == 0 else '실패 ' + (r.stderr or r.stdout)[-300:])
log('끝')
