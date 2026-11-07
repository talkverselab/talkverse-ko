#!/usr/bin/python3
"""문장 조각 wav → 턴별 mp4(AAC) → R2 `audio/ko/<편>/<턴>_<m|f>.mp4` + D1 `audio_lines`(그 편의 줄을 지우고 다시 넣는다).
모든 턴에 남성판·여성판 두 파일·두 줄(본문 text(한국어)·reading(빈 값)·rd(로마자)·ko(영어 뜻) 포함). 두 판의 소리가 같아도 따로 올린다 — 구조를 단순하게.
조각마다 앞뒤 무음을 자르고 0.45초 넘는 쉼을 줄인 뒤 0.22초 간격으로 잇고 소리 크기를 맞춘다(-18 LUFS).
  python3 tools/tts/pack.py <wav폴더> <편id>... [--upload] [--variant vox]   (--variant vox = <wav>/vox/<편>/ 의 VoxCPM2 조각을 <편id>_vox 로 올림 — §5 모델 비교)
목록 = data/tts/audio_ko.json(리뷰 페이지용). 주소에는 ?v=<sha1 앞 8자리>(서버 캐시가 1년)."""
import datetime, hashlib, json, os, re, subprocess, sys, tempfile
from concurrent.futures import ThreadPoolExecutor
import ttslib as L
R = L.R
# §5(2026-11-07 밤): 조각 안 쉼 ≤0.25초, 조각 사이 0.18초, 느리면(음절/초 < 3.7) 음높이 유지한 채 최대 1.15배
TRIM = ('silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.03,areverse,'
        'silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.05,areverse,'
        'silenceremove=stop_periods=-1:stop_duration=0.25:stop_threshold=-45dB:stop_silence=0.25')
GAP = '0.18'; SLOW = 3.7; MAX_TEMPO = 1.15
W = ['npx', '-y', 'wrangler@4']


def run(*a):
    subprocess.run(a, check=True, capture_output=True)


def build(wav, ep, num, tag, segs, out, tmp):
    parts = []
    for i, (_, text) in enumerate(segs):
        o = f'{tmp}/{ep}_{num}_{i}_{tag}.wav'
        src = f'{wav}/{ep}/{num:02d}_{i}_{tag}.wav'
        run('ffmpeg', '-y', '-i', src, '-af', TRIM, '-ar', '24000', '-ac', '1', o)
        if os.path.getsize(o) < 1000:            # 소리가 작아 무음 자르기에 전부 잘려 나간 조각(ffmpeg 는 0 을 돌려준다) → 자르지 않고 쓴다
            run('ffmpeg', '-y', '-i', src, '-ar', '24000', '-ac', '1', o)
        syl = len(re.sub(r'[^가-힣]', '', text)); d = dur(o)
        if syl >= 3 and d > 0 and syl / d < SLOW:    # 느린 조각은 속도만 올린다(음높이 유지)
            t = min(MAX_TEMPO, SLOW / (syl / d)); o2 = o[:-4] + '_t.wav'
            run('ffmpeg', '-y', '-i', o, '-af', f'atempo={t:.3f}', o2); o = o2
        parts.append(o)
    gap = f'{tmp}/gap.wav'
    if not os.path.exists(gap):
        run('ffmpeg', '-y', '-f', 'lavfi', '-i', 'anullsrc=r=24000:cl=mono', '-t', GAP, gap)
    lst = f'{tmp}/{ep}_{num}_{tag}.txt'; open(lst, 'w').write(''.join(f"file '{x}'\n" for p in parts for x in (p, gap))[:-len(f"file '{gap}'\n")])
    j = f'{tmp}/{ep}_{num}_{tag}_j.wav'; run('ffmpeg', '-y', '-f', 'concat', '-safe', '0', '-i', lst, '-c', 'copy', j)
    run('ffmpeg', '-y', '-i', j, '-af', 'apad=pad_dur=0.12,loudnorm=I=-18:TP=-1.5:LRA=11,aresample=44100', '-ac', '1',
        '-c:a', 'aac', '-b:a', '80k', '-movflags', '+faststart', '-f', 'mp4', '-map_metadata', '-1', out)
    return dur(out)


def dur(f):
    return float(subprocess.run(['ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 'csv=p=0', f], capture_output=True, text=True).stdout or 0)


def put(r):
    for _ in range(3):
        x = subprocess.run(W + ['r2', 'object', 'put', f"talkverse-art/{r['key']}", '--file', r['f'], '--content-type', 'audio/mp4', '--remote'], cwd=R, capture_output=True, text=True)
        if x.returncode == 0:
            return None
    return r['key'] + ' ' + x.stderr[-200:]


def main():
    UP = '--upload' in sys.argv; a = [x for x in sys.argv[1:] if x != '--upload']
    var = ''
    if '--variant' in a:
        i = a.index('--variant'); var = '_' + a[i + 1]; a = a[:i] + a[i + 2:]
    wav, eps = a[0], a[1:]
    tmp = tempfile.mkdtemp(); q = lambda s: "'" + s.replace("'", "''") + "'"
    mf = f'{R}/data/tts/audio_ko.json'
    for ep0 in eps:
        ep = ep0 + var; src = f'{wav}/{var[1:]}' if var else wav
        rows = []
        for t in L.turns(ep0):
            for g in 'mf':
                x = t[g]; tag = 'c' if t['same'] else g; f = f"{tmp}/{ep}_{t['num']:02d}_{g}.mp4"
                d = build(src, ep0, t['num'], tag, x['segs'], f, tmp)
                rows.append(dict(turn=t['num'], voice=g, speaker=x['voice'], emotion='+'.join(s[0] for s in x['segs']), key=f"audio/ko/{ep}/{t['num']:02d}_{g}.mp4",
                                 sha1=hashlib.sha1(open(f, 'rb').read()).hexdigest(), ms=int(d * 1000), text=x['text'], reading=x['reading'], rd=x['rd'], ko=x['ko'], f=f))
        if UP:
            with ThreadPoolExecutor(8) as ex:
                err = [e for e in ex.map(put, rows) if e]
            if err:
                sys.exit('R2 실패 ' + ' | '.join(err[:3]))
            now = datetime.datetime.now(datetime.UTC).strftime('%Y-%m-%d %H:%M:%S')
            sql = [f"DELETE FROM audio_lines WHERE lang='ko' AND episode='{ep}';"] + [
                "INSERT INTO audio_lines (lang,episode,turn,voice,speaker,emotion,key,ms,sha1,text,reading,rd,ko,created_at) VALUES "
                f"('ko','{ep}',{r['turn']},'{r['voice']}','{r['speaker']}','{r['emotion']}','{r['key']}',{r['ms']},'{r['sha1']}',{q(r['text'])},{q(r['reading'])},{q(r['rd'])},{q(r['ko'])},'{now}');" for r in rows]
            sf = f'{tmp}/{ep}.sql'; open(sf, 'w', encoding='utf-8').write('\n'.join(sql) + '\n')
            x = subprocess.run(W + ['d1', 'execute', 'talkverse-db', '--remote', '--file', sf, '-y'], cwd=R, capture_output=True, text=True)
            if x.returncode:
                sys.exit('D1 실패 ' + ep + x.stderr[-400:] + x.stdout[-300:])
        M = json.load(open(mf, encoding='utf-8')) if os.path.exists(mf) else {}
        M[ep] = [{k: v for k, v in r.items() if k not in ('f', 'text', 'reading', 'rd', 'ko')} for r in rows]
        json.dump(M, open(mf, 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
        print(ep, len(rows), '줄', sum(r['ms'] for r in rows) // 1000, '초', '올림' if UP else '안 올림', flush=True)


if __name__ == '__main__':
    main()
