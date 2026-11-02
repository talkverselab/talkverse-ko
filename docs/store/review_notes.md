# 심사 메모(App Review Notes) 초안 · 개인정보처리방침 추가 문안 — 2026-11-02

> 한자 앱(hanja-app `docs/store/review_notes.md`)을 옮김. 한국어 유니버스 = Talkverse ID 로그인(선택) + 인앱 구입 「평생 이용권」 1개.
> **아직 잠긴 기능이 없다** — 무엇을 유료로 잠글지 정해지면 아래 [IAP] 의 "어디서 사는가"를 고친다(지금은 Profile → 계정 → 평생 이용권).

## App Store Connect "심사 정보 → 메모"

```
[Sign-in] Optional. Every learning feature works without an account; sign-in is only for restoring purchases across devices.
- Where: Profile → Account → Sign in (Sign in with Apple, or email sign-in for review/testing).
- Demo account (email sign-in): review@talkverse.uk / password: <paste from Doppler keys/prd TALKVERSE_REVIEW_ACCOUNT> — it already owns the Lifetime Pass.
- Account deletion: Profile → Account → Delete account (confirmation) → personal data is deleted server-side and all sessions are revoked.
[IAP] One non-consumable "Lifetime Pass" (com.kuniverse.kUniverse.lifetime). Profile → Account → Lifetime Pass → [Buy Lifetime Pass ₩…], [Restore purchases] to restore. Works with a Sandbox account; sign-in is not required to buy or restore.
[Network] Only sign-in, purchase verification and the app-update check use the network; lessons work offline.

[로그인] 선택입니다. 모든 학습 기능은 로그인 없이 쓰고, 로그인은 구매 복원·기기 간 이용권 공유에만 씁니다.
- 위치: 프로필 → 계정 → 로그인(Apple 로그인, 심사·테스트용 이메일 로그인).
- 데모 계정: review@talkverse.uk / 비밀번호 <Doppler 에서 복사> — 평생 이용권 보유.
- 계정 삭제: 프로필 → 계정 → 계정 삭제(확인 창) → 서버에서 개인정보 삭제, 모든 기기 로그아웃.
[인앱 구입] 비소모성 「평생 이용권」(com.kuniverse.kUniverse.lifetime) 1개. 프로필 → 계정 → 평생 이용권 → 구매 / 이전 구매 복원. Sandbox 로 시험, 로그인 없이도 구매·복원.
```

## App Store "앱 개인정보 보호" 답
- 데이터 수집: **예**. 사용자와 연결됨·추적 아님:
  - 연락처 정보 → 이메일 주소, 이름(Apple 로그인 때 선택) — 로그인한 사용자만
  - 식별자 → 사용자 ID(Talkverse 계정 ID) — 로그인한 사용자만
  - 구매 → 구매 내역(이용권 복원) — 구매한 사용자만
- 수집하지 않음: 위치·건강·금융(카드 정보는 Apple/Google)·사용 데이터·진단·검색 기록. 추적(ATT) 없음. 학습 기록은 기기 안에만.

## Google Play 데이터 보안 답
- 수집: 예 — 이메일·이름(계정 관리, 선택), 사용자 ID, 구매 내역. 전송 암호화 예. **삭제 요청 가능: 예** — 앱 안 「계정 삭제」 + https://talkverse.uk/account/delete .
- 공유: 없음(결제는 Google Play). 광고 없음.

## 개인정보처리방침에 추가할 절(talkverse.uk 세션이 언어앱 방침 페이지에 반영)
```
계정(선택) — 한국어 유니버스는 로그인 없이 쓸 수 있습니다. Talkverse 계정으로 로그인하면 이메일 주소·이름(로그인 제공자가 전달하는 범위)·계정 ID·로그인 시각과 기기 토큰을 로그인 유지, 구매 복원·기기 간 공유, 문의 응대에 씁니다. 계정 삭제 시 즉시 지웁니다(구매 기록은 관계 법령에 따라 사용자 ID 만 회계 목적으로 남김). 삭제: 앱 → 프로필 → 계정 → 계정 삭제, 또는 talkverse.lab@gmail.com. 계정 서버는 Cloudflare(미국 등 글로벌 리전)에서 운영됩니다.
결제 — 평생 이용권 결제는 Apple App Store 또는 Google Play 가 처리하며, 앱은 카드 정보를 받지 않고 구매 영수증(거래 번호·상품 ID)만 확인합니다.
```

## 사용자가 할 일(콘솔)
- 개발자 포털 App ID `com.kuniverse.kUniverse` → **Sign in with Apple capability 켜기**(Services ID `com.talkverse.auth` 에 "Group with existing primary").
- App Store Connect 인앱 구입 비소모성 `com.kuniverse.kUniverse.lifetime` 등록(심사 스크린샷 = 평생 이용권 시트), Play Console 일회성 상품 `lang_ko`.
- 데모 계정 review@talkverse.uk 에 lang `ko` 이용권 부여 — talkverse.uk 세션.
