# 한국어 전편 재개 절차 (§5 품질 기준 적용, 2026-11-07 밤)

uk 의 "GPU 끝" 뒤 순서대로. PC = Administrator@100.127.143.37, 작업 폴더 ~/tts_work/ko, 검사 venv $TMPDIR/tts_venv.

1. 참고 음성 전부 다시(지시문·참고 문장이 바뀜): PC `D:\tts_test\job\out\ref_ko` 를 `ref_ko_old` 로 개명 → `python3 tools/tts/make_jobs.py ~/tts_work/ko/job --refs`(계획 있는 편의 (목소리,감정) 전부) → vox_jobs.json 만 PC 로 → Start-ScheduledTask → Ready 대기(≈2시간).
2. 받아 와 검사: `scp -r PC:D:/tts_test/job/out/ref_ko ~/tts_work/ko/wav/` → `$TMPDIR/tts_venv/bin/python tools/tts/check_refs.py ~/tts_work/ko/wav/ref_ko --jobs ~/tts_work/ko/job/vox_jobs.json` → 미달 파일을 PC 에서 지우고(REF_SEED=11 등 seed 바꿔) 다시 → 두 번까지, 그래도 미달이면 가장 나은 판.
3. 모델 비교 1편(§5): `python3 tools/tts/make_jobs.py ~/tts_work/ko/job --vox r1_survival_s1` → vox_jobs.json PC → 돌리고 받아 `~/tts_work/ko/wav/vox/r1_survival_s1/` → MOSS 판은 run_all 이 만들므로 r1_survival_s1 이 done 된 뒤 `python3 tools/tts/pack.py ~/tts_work/ko/wav r1_survival_s1 --upload --variant vox` → 리뷰 페이지에 두 모델 버튼.
4. 전편: `nohup $TMPDIR/tts_venv/bin/python tools/tts/run_all.py ~/tts_work/ko 15 >> ~/tts_work/ko/run.log 2>&1 &` (done.txt 에 r3_work_b1 — 시험 1편은 옛 기준이라 전편 뒤 `--force` 재생성 여부는 사용자 결정).
5. 끝: review_html 재생성 → 커밋 → uk "REVIEW_ko 갱신" + 소요·달라진 점.
