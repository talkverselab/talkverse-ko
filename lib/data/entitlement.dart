import 'package:flutter/material.dart';

import 'account.dart';
import 'purchase.dart';
import '../curriculum/curriculum_service.dart';
import '../drama/drama_service.dart';
import '../screens/paywall_screen.dart';

/// 이용권 — Talkverse 계정 이용권(lang 'ko') OR 이 기기에서 산·복원한 스토어 구매(lang_ko_* · all_*).
/// 무료/유료 범위 = ~/talkverse/PAYWALL_SPEC.md §2(uk, 2026-11-23): 무료 = 커리큘럼 1단계·회화 R0·R1·글자/발음/단어 기본·언어감각 1급.
/// 잠긴 곳은 숨기지 않고 자물쇠 → 결제 화면. 무료 한도는 서버 단계표(free·freeSenseLevels)가 정한다.
class Entitlement {
  Entitlement._();
  static const lang = 'ko';
  @visibleForTesting
  static bool? premiumForTest;
  static bool get premium => premiumForTest ?? (Account.has(lang) || Purchase.owns(lang));

  static Future<void> showPaywall(BuildContext context) => PaywallScreen.show(context);

  /// 회화 편: R0·R1 은 무료, R2 이상은 이용권.
  static bool freeRegion(String region) => region == 'R0' || region == 'R1';
  static bool canOpenEpisode(DramaEpisode e) => premium || freeRegion(e.region);

  /// 커리큘럼 단계.
  static bool canOpenStage(CurStage s) => premium || s.free;

  /// 언어감각 급(0부터) — freeSenseLevels 개까지 무료.
  static bool canOpenSenseLevel(int index) => premium || index < CurriculumService.instance.freeSenseLevels;

  /// 열 수 있으면 true, 잠겼으면 결제 화면을 띄우고 false.
  static Future<bool> gate(BuildContext context, bool open) async {
    if (open) return true;
    await showPaywall(context);
    return premium;
  }
}
