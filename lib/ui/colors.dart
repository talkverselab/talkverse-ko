import 'package:flutter/material.dart';

/// 컬러 팔레트 — talkverse.uk 톤(2026-10-26).
///
/// 흰 바탕 + 남색 글자 + 인디고 포인트 하나, 그 밖의 색은 절제한다.
/// 이름(softPink·lilac·bgCream…)은 옛 팔레트에서 온 것이라 화면 코드가 그대로 쓰고,
/// 값만 사이트 토큰(`--ink`·`--body`·`--accent`…)에 맞췄다.
class KColors {
  // 주색 — 사이트 `--accent` 인디고 / `--accent-ink`
  static const softPink = Color(0xFF635BFF);
  static const lilac = Color(0xFF4B44D6);
  // 한국어 카드색(talkverse.uk 언어 카드 `--c`) — 완료·학습됨 표시
  static const sage = Color(0xFF3FB26A);
  // 별점·강조 — 히어로 메시의 피치를 진하게
  static const buttercream = Color(0xFFF5A524);
  static const coral = Color(0xFFF5B8E6);

  // 글자 — `--ink` / `--body` / `--muted`
  static const ink = Color(0xFF0A2540);
  static const inkSoft = Color(0xFF425466);
  static const inkFaint = Color(0xFF6B7C93);
  // 바탕 — 흰색 / `--soft`
  static const bgCream = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceTint = Color(0xFFF6F9FC);
  // 구분선 — `--line`
  static const line = Color(0xFFE6EBF1);

  // Dark variant — 남색 계열
  static const darkBg = Color(0xFF0A2540);
  static const darkSurface = Color(0xFF14365A);

  // 타일 바탕 — 히어로 메시 네 색(피치·분홍·라벤더·하늘)을 아주 옅게
  static const tileCream = Color(0xFFFFF4E6);
  static const tileLilac = Color(0xFFEFEEFF);
  static const tileBlush = Color(0xFFFDEEF8);
  static const tilePeach = Color(0xFFFFF1E2);
  static const tileGold = Color(0xFFFFF4E0);
  static const tileMint = Color(0xFFE8F9FF);
  static const tileSage = Color(0xFFEAF7EF);
  static const tileLavender = Color(0xFFF0EFFF);

  // 주석(문법 표시) 색 — 구분이 되게 서로 다른 색 유지
  static const annParticle = Color(0xFF8F89FF);
  static const annEnding = Color(0xFFEC8FD0);
  static const annHonorific = Color(0xFFF5B85A);
  static const annVocab = Color(0xFF5FD0F0);

  // 카드·타일 그림자 — 사이트 `0 2px 5px -1px rgba(50,50,93,.1), 0 1px 3px -1px rgba(0,0,0,.1)`
  static const cardShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x1A32325D),
      blurRadius: 5,
      offset: Offset(0, 2),
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 3,
      offset: Offset(0, 1),
      spreadRadius: -1,
    ),
  ];
  // 강조 그라데이션 — 왼쪽 하늘색 → 오른쪽 인디고 `#00b3ff → #635bff` (2026-10-26 사용자 결정)
  static const accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF00B3FF), Color(0xFF635BFF)],
  );
}

class ScenarioVisual {
  final String emoji;
  final Color tileColor;
  const ScenarioVisual(this.emoji, this.tileColor);

  static const _map = <String, ScenarioVisual>{
    'cafe-ordering-01': ScenarioVisual('☕', KColors.tileCream),
    'taxi-guesthouse-01': ScenarioVisual('🚖', KColors.tileGold),
    'convenience-store-01': ScenarioVisual('🏪', KColors.tileBlush),
    'first-meeting-01': ScenarioVisual('🌸', KColors.tileLavender),
    'restaurant-recommend-01': ScenarioVisual('🍱', KColors.tilePeach),
    'subway-asking-01': ScenarioVisual('🚇', KColors.tileLilac),
    'market-haggling-01': ScenarioVisual('🥬', KColors.tileSage),
    'pharmacy-cold-01': ScenarioVisual('💊', KColors.tileMint),
  };

  static ScenarioVisual forId(String id) =>
      _map[id] ?? const ScenarioVisual('💫', KColors.tileLilac);
}
