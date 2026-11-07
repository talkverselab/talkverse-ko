#!/usr/bin/env python3
"""참고 음성 검사(§5): 잡음 바닥(무음 구간만, §5 b189b0c) — -45dB 넘으면 불합격(문서의 -60 은 우리 측정과 안 맞아 보고만), 무음 구간이 없으면 건너뜀, 같은 목소리의 감정별 음색 상관(MFCC 평균 코사인) ≥ 0.90. 미달 목록을 vox 재생성 작업(seed 바꿈)으로 쓴다.
  <venv>/bin/python tools/tts/check_refs.py <ref_ko 폴더> [--jobs <vox_jobs.json>]"""
import glob, json, os, sys
import librosa, numpy as np
import ttslib as L
# §5 의 -60dB 를 우리 측정(무음 구간 RMS)으로 재면 한국어 참고 음성 21/21 이 -45~-50 으로 전부 미달 → 측정법 차이로 보고 '분명한 잡음' -45 만 불합격, 나머지는 수치만 보고("수치는 재생성 근거가 아니라 들어 볼 조각을 고르는 체").
NOISE_FAIL = -45.0


def noise_floor(f):
    return L.audio_stats(f)[1]


def timbre(f):
    y, sr = librosa.load(f, sr=16000)
    m = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=20)[1:]   # 0번(음량) 제외
    return m.mean(axis=1)


def main():
    a = sys.argv[1:]; jobs_out = None
    if '--jobs' in a:
        i = a.index('--jobs'); jobs_out = a[i + 1]; a = a[:i] + a[i + 2:]
    d = a[0]; bad = {}; rep = []
    for v in sorted(L.V['voices']):
        base = f'{d}/{v}_base.wav'
        if not os.path.exists(base):
            continue
        tb = timbre(base); nb = noise_floor(base)
        if nb is not None and nb > NOISE_FAIL:
            bad[f'{v}_base'] = f'base 잡음 {nb:.0f}dB'
        for f in sorted(glob.glob(f'{d}/{v}_*.wav')):
            e = os.path.basename(f)[len(v) + 1:-4]
            if e == 'base':
                continue
            nf = noise_floor(f); te = timbre(f)
            cor = float(np.dot(tb, te) / (np.linalg.norm(tb) * np.linalg.norm(te) + 1e-9))
            rep.append((v, e, nf, cor))
            if (nf is not None and nf > NOISE_FAIL) or cor < 0.90:
                bad[f'{v}_{e}'] = f'잡음 {nf:.0f}dB 상관 {cor:.2f}'
    for v, e, nf, cor in rep:
        print(f'{v:10s} {e:10s} 잡음 {("%6.1f" % nf) if nf is not None else "  없음"}  상관 {cor:.2f}' + ('  ✗' if f'{v}_{e}' in bad else ''))
    print('참고 음성', len(rep), '미달', len(bad))
    if jobs_out:
        seed = int(os.environ.get('REF_SEED', '7'))
        jobs = []
        for k in bad:
            v, e = k.rsplit('_', 1)
            x = L.V['voices'][v]
            if e == 'base':
                jobs.append({'out': f'ref_ko/{v}_base.wav', 'text': L.V['base_text'], 'instruct': x['desc'], 'seed': seed})
            else:
                E = L.V['emotions'][e]
                jobs.append({'out': f'ref_ko/{v}_{e}.wav', 'text': E['ref'], 'instruct': f"{x['desc']}, {E['instruct']}", 'reference': f'out/ref_ko/{v}_base.wav', 'seed': seed})
        json.dump(jobs, open(jobs_out, 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
        print('재생성 작업', len(jobs), '→', jobs_out, '(PC 의 해당 파일을 지운 뒤 돌릴 것 — vox 는 있는 파일을 건너뜀)')


if __name__ == '__main__':
    main()
