import 'package:flutter/material.dart';

import 'account.dart';
import 'purchase.dart';
import '../screens/paywall_screen.dart';

/// 평생 이용권 — Talkverse 계정 이용권(lang 'ko', auth.talkverse.uk) OR 이 기기에서 산·복원한 스토어 구매(2026-11-02, 한자 앱 방식).
/// 어떤 화면을 잠글지는 아직 정하지 않았다 — 지금은 잠금 없이 「나」의 이용권 타일에서만 시트를 연다.
class Entitlement {
  Entitlement._();
  static const lang = 'ko';
  static bool get premium => Account.has(lang) || Purchase.owns(lang);

  static Future<void> showPaywall(BuildContext context) => PaywallScreen.show(context);
}
