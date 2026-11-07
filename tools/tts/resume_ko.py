#!/usr/bin/env python3
"""한국어 전편 재개 진행기(RESUME_KO.md 자동판). 참고 음성 생성이 끝나길 기다려 검사·재생성(2회) → VoxCPM2 비교 1편 조각 생성 → run_all.
  nohup <venv>/bin/python tools/tts/resume_ko.py >> ~/tts_work/ko/run.log 2>&1 &"""
import json, os, subprocess, sys, time
HERE = os.path.dirname(os.path.abspath(__file__)); W = os.path.expanduser('~/tts_work/ko'); PC = 'Administrator@100.127.143.37'; PY = sys.executable
log = lambda *a: print(time.strftime('%m-%d %H:%M:%S'), *a, flush=True)


def sh(*a, check=True):
    return subprocess.run(a, check=check, capture_output=True, text=True)


def pc(cmd):
    return sh('ssh', PC, cmd, check=False).stdout


def wait_ready():
    while 'Ready' not in pc("(Get-ScheduledTask -TaskName 'TTS job 2060').State"):
        time.sleep(45)


def run_pc(vox=None, moss=None):
    wait_ready()
    pc("Remove-Item D:\\tts_test\\job\\vox_jobs.json,D:\\tts_test\\job\\moss_jobs.json -ErrorAction SilentlyContinue")
    if vox:
        sh('scp', '-q', vox, f'{PC}:D:/tts_test/job/vox_jobs.json')
    if moss:
        sh('scp', '-q', moss, f'{PC}:D:/tts_test/job/moss_jobs.json')
    pc("Start-ScheduledTask -TaskName 'TTS job 2060'"); time.sleep(30); wait_ready()


def fetch(remote, local_dir):
    os.makedirs(local_dir, exist_ok=True)
    sh('scp', '-q', '-r', f'{PC}:D:/tts_test/job/out/{remote}', local_dir + '/', check=False)


# 1. 참고 음성(이미 돌고 있음) 끝나길 기다려 받아 온다
log('참고 음성 대기'); wait_ready()
sh('rm', '-rf', f'{W}/wav/ref_ko'); fetch('ref_ko', f'{W}/wav'); log('참고 음성 받음', len(os.listdir(f'{W}/wav/ref_ko')))
# 2. 검사·재생성(두 번까지)
for i, seed in enumerate((11, 23)):
    r = subprocess.run([PY, f'{HERE}/check_refs.py', f'{W}/wav/ref_ko', '--jobs', f'{W}/job/ref_retake.json'], capture_output=True, text=True, env=dict(os.environ, REF_SEED=str(seed)))
    log(r.stdout.strip().splitlines()[-2] if r.stdout else r.stderr[-300:])
    jobs = json.load(open(f'{W}/job/ref_retake.json')) if os.path.exists(f'{W}/job/ref_retake.json') else []
    if not jobs:
        break
    names = ','.join(f"'D:\\tts_test\\job\\out\\{j['out'].replace('/', chr(92))}'" for j in jobs)
    pc(f"Remove-Item {names} -ErrorAction SilentlyContinue")
    log('참고 음성 재생성', len(jobs), 'seed', seed); run_pc(vox=f'{W}/job/ref_retake.json')
    sh('rm', '-rf', f'{W}/wav/ref_ko'); fetch('ref_ko', f'{W}/wav')
# 3. VoxCPM2 비교 1편(r1_survival_s1) 조각
sh(PY, f'{HERE}/make_jobs.py', f'{W}/job', '--vox', 'r1_survival_s1')
log('VoxCPM2 비교 조각 생성'); run_pc(vox=f'{W}/job/vox_jobs.json')
fetch('ko_vox/r1_survival_s1', f'{W}/wav/vox'); log('vox 조각', len(os.listdir(f'{W}/wav/vox/r1_survival_s1')))
# 4. 전편
log('run_all 시작')
os.execv(PY, [PY, f'{HERE}/run_all.py', W, '15'])
