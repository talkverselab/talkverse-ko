# Supabase → Cloudflare 이관 — 한국어앱

Supabase 사용 없음 — 확인 2026-10-26.

- 추적 중인 코드·스크립트·웹 파일(`lib/`, `tools/`, `android/`, `ios/`, `.github/`, `pubspec.yaml`)에 Supabase 주소·키·패키지가 없다.
  표·저장소 버킷·RPC·로그인(Auth) 모두 쓰지 않는다.
- 학습 데이터는 기기 안 로컬 DB(drift/SQLite)와 `shared_preferences` 에만 있다. 서버로 보내는 것 없음.
- 네트워크는 앱 업데이트 하나뿐: GitHub `latest` 릴리스의 `latest.json`·APK(`lib/services/update_service.dart`). Supabase 와 무관.
- 그래서 옮길 것·지울 것 없음. 나중에 계정·학습 기록 동기화를 넣게 되면 처음부터 공용 `talkverse-accounts`·`talkverse-auth`(로그인)와
  `talkverse-db`(`lang = 'ko'`)를 쓴다 — 이 앱용 DB 는 따로 만들지 않는다.
