import 'package:flutter/foundation.dart';

/// 통합 앱(Talkverse, `~/talkverse/talkverse-app`) 임베드 환경 — talkverse-uk docs/talkverse-app/DESIGN.md(2026-11-09).
/// 단독 앱이면 [embedded] = false 로 지금과 똑같이 돈다.
class Embed {
  Embed._();
  static bool embedded = false;
  static VoidCallback? onSwitchLanguage; // 있으면 프로필에 「다른 언어 배우기」
  static const package = 'k_universe';
  static const code = 'ko';
}

/// 에셋 경로 — 통합 앱이 패키지로 부르면 `packages/k_universe/assets/…`.
String assetPath(String p) => Embed.embedded && !p.startsWith('packages/') ? 'packages/${Embed.package}/$p' : p;

/// 에셋 목록(AssetManifest) 키를 앱 기준 `assets/…` 로 되돌린다(통합 앱에서는 `packages/k_universe/` 가 붙어 온다).
String? unpackAsset(String key) {
  const pre = 'packages/${Embed.package}/';
  if (key.startsWith(pre)) return key.substring(pre.length);
  return Embed.embedded ? null : key; // 통합 앱에서 다른 패키지 에셋은 무시
}

/// 이 언어 전용 저장 이름(SharedPreferences 키·파일·폴더) — `ko_` 접두. 학습자 이름·성별·표시 언어·로그인은 접두 없이 공유.
String pk(String key) => '${Embed.code}_$key';
