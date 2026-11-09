# 스토어 등록 문안 — 한국어 유니버스 (Talkverse Korean)

기준: `~/talkverse/STORE_DIFFERENTIATION.md`(애플 지침 4.3 대비, 사용자 "엄청 중요해", 2026-11-09). 숫자는 2026-11-09 앱 실측.
**출시 순서**: 지금은 한자앱만 심사. 이 앱은 아래 「출시 전 남은 일」을 다 끝낸 뒤, 일본어·중국어 다음 차례로 낸다(uk 공지). 그 전까지 Zealot·TestFlight 전용.

## 이 앱만의 축
다른 언어앱은 한국어 화자가 외국어를 배우는 앱이고, **이 앱은 반대로 영어 화자가 한국어를 배우는 앱**이다(화면 기본 언어 = 기기 언어, 뜻·설명 = 영어). 한국어 회화의 63%를 만드는 조사·어미 19개와, 한국 영화·드라마 대사에서 잰 절벽 단어가 중심.

## 스토어 설명 (English, App Store / Google Play)

**First line**
Real Korean as people actually speak it — learn the 75 words and 19 particles & endings that make up over half of everyday Korean, through original K-drama-style scenes with voiced audio.

**What only this app has**
- **Hangul & Pronunciation** — all 19 consonants (plain · aspirated · tense), 21 vowels, the 7 final-consonant sounds and a 14×10 syllable chart. Tap any letter: it plays after a second, with IPA, where the sound is made, and a side-by-side comparison with English vowels.
- **Particles & endings first** — 이/가, 은/는, 을/를, -요, -아/어… the 19 grammar pieces that build 63% of Korean speech, each highlighted inside real sentences.
- **250 original K-drama-style dialogues** (R0 beginner → R3 advanced) — first dates, roommates, office "nunchi", convenience stores — each with clay-style scene illustrations (2,198 panels) and **4,562 voiced lines (3 hours 13 minutes)** with emotion, in male and female learner versions.
- **Cliff words** — 2,000 words ranked from a corpus of 4,268 Korean films and drama episodes (23 million tokens): the first 75 cover 55% of dialogue, 521 cover 80%. Units of 20, picture tiles, tap to hear.
- **Every word in a sentence is tappable** → meaning, romanization and picture. Romanization is off by default (turn it on when you need it).

**Study tools**: picture cards, Leitner spaced review (7 levels), progress that counts finished scenes and real frequency coverage — no streaks, no points.

**Also**: one Talkverse account across iPhone, iPad and Android · works offline after the first download · plans: 1 month, 3 months, 1 year (auto-renew, cancel anytime) or lifetime (for as long as the service runs).

## 스토어 설명 (한국어 요약 — 한국 스토어용 짧은 판)
영어 화자를 위한 한국어 앱. 한국 영화·드라마 4,268편에서 잰 절벽 단어(75어 = 대사의 55%), 조사·어미 19개, K-드라마풍 자체 제작 회화 250편(장면 그림 2,198컷·감정 음성 4,562줄), 한글 자모 발음표(IPA·영어 모음 비교).

## 심사 메모 (App Review Notes)
> This app is one of a family of language-specific apps by Universal Talking Lab (Talkverse). Each app is built from scratch for one target language and is NOT a re-skin. Unlike the other apps in the family (which teach foreign languages to Korean speakers), the Korean app teaches **Korean to English speakers**: it has its own script & pronunciation module (Hangul: 19 consonants in three series — plain, aspirated, tense — 21 vowels, 7 final-consonant sounds and a syllable chart, with IPA and English vowel comparison), its own grammar tools (the 19 particles and endings that make up 63% of Korean speech, highlighted inside sentences), 250 original conversation episodes with 4,562 recorded-voice lines written for Korean (K-drama-style scenes), and a vocabulary list measured from a Korean film & drama corpus (75 words = 55% of dialogue, 521 = 80%). Content, curriculum and UI flows differ between apps; we keep them separate because learners search for and buy one language at a time.
>
> Paid features: none are locked at launch. The plan sheet is under Profile → Pass. Sign-in is optional (Apple / email).

## 스크린샷 순서 (첫 두 장 = 한국어 고유 화면, 홈·프로필로 시작하지 않음)
1. 회화 장면 — 점토 컷 + 대화 스크립트(한국어·영어), 문장 단어 밑줄
2. 한글과 발음 — 자음표(예사·거센·된소리)
3. 발음 시트 — ㅡ: IPA·입모양·한국어 vs 영어 모음 위치
4. 조사·어미 19
5. 그림 카드
6. 절벽 단어(20어 단원 타일)
7. 홈
시뮬레이터 캡처: `python3 tools/pane_shots.py <UDID> data/store/shots_<기기> integration_test/store_shots_test.dart` (iPhone 6.9" = iPhone 17 Pro Max, iPad 13" = iPad Pro 13). 문구 얹기(캡션)는 출시 직전에.

## 출시 전 남은 일 (지침 2.1 — 하나라도 남으면 내지 않음)
- 로그인 화면: 구글·네이버·카카오 버튼이 누르면 「준비 중」 — 서버 지원 전이면 버튼을 숨긴다.
- 「한글과 발음」 조음 그림은 임시 — 출시 전 Grok 그림으로 교체(사용자 지시).
- 시작 화면의 「그림 준비 중」은 첫 내려받기 진행 문구라 괜찮지만, 오프라인 첫 실행에서 빈 그림 자리가 어떻게 보이는지 실기기 확인.
- 스토어 상품 6개 등록 + 서버 `/me/purchases` 새 ID(uk).
- 실기기(아이폰·아이패드·갤럭시) 한 바퀴 확인.
