#!/usr/bin/env python3
"""미달 참고 음성 재생성(2회, seed 11·23) → run_all. resume_ko.py 의 2·4단계만."""
import json, os, subprocess, sys, time
HERE = os.path.dirname(os.path.abspath(__file__)); W = os.path.expanduser('~/tts_work/ko'); PC = 'Administrator@100.127.143.37'; PY = sys.executable
log = lambda *a: print(time.strftime('%m-%d %H:%M:%S'), *a, flush=True)
sh = lambda *a, **k: subprocess.run(a, capture_output=True, text=True, **k)
pc = lambda c: sh('ssh', PC, c).stdout
def wait_ready():
    while 'Ready' not in pc("(Get-ScheduledTask -TaskName 'TTS job 2060').State"):
        time.sleep(45)
for seed in (11, 23):
    r = sh(PY, f'{HERE}/check_refs.py', f'{W}/wav/ref_ko', '--jobs', f'{W}/job/ref_retake.json', env=dict(os.environ, REF_SEED=str(seed)))
    log((r.stdout.strip().splitlines() or [r.stderr[-300:]])[-2 if r.stdout else -1])
    jobs = json.load(open(f'{W}/job/ref_retake.json'))
    if not jobs:
        break
    # 미달 파일은 old 로 두고(가장 나은 판 비교용) PC 에서 지운다
    os.makedirs(f'{W}/wav/ref_old{seed}', exist_ok=True)
    for j in jobs:
        n = j['out'].split('/')[-1]; p = f'{W}/wav/ref_ko/{n}'
        if os.path.exists(p):
            os.replace(p, f'{W}/wav/ref_old{seed}/{n}')
    pc('Remove-Item ' + ','.join(f"'D:\\tts_test\\job\\out\\ref_ko\\{j['out'].split('/')[-1]}'" for j in jobs) + ' -ErrorAction SilentlyContinue')
    wait_ready(); pc("Remove-Item D:\\tts_test\\job\\moss_jobs.json -ErrorAction SilentlyContinue")
    sh('scp', '-q', f'{W}/job/ref_retake.json', f'{PC}:D:/tts_test/job/vox_jobs.json')
    pc("Start-ScheduledTask -TaskName 'TTS job 2060'"); log('참고 음성 재생성', len(jobs), 'seed', seed); time.sleep(30); wait_ready()
    sh('scp', '-q', '-r', f'{PC}:D:/tts_test/job/out/ref_ko', f'{W}/wav/')
r = sh(PY, f'{HERE}/check_refs.py', f'{W}/wav/ref_ko'); log('최종', (r.stdout.strip().splitlines() or [''])[-1])
log('run_all 시작'); os.execv(PY, [PY, f'{HERE}/run_all.py', W, '15'])
