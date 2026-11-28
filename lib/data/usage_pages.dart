import 'dart:convert';

import 'package:http/http.dart' as http;

import '../usage_log.dart';
import 'account.dart';

/// 화면 열람 기록의 화면 ID와 환불 기준(uk, 2026-11-28 · ~/talkverse/_shared/talkverse_usage/USAGE_LOG.md).
/// ID = 내용에 붙은 고정 이름. 목록 tool/usage_catalog.json(tools/usage_catalog.py)과 글자까지 같아야 센다.
/// 학습 한 단위를 열 때만 기록 — 목록·메뉴·설정은 기록하지 않는다. 무료 화면도 기록한다.
class UsagePages {
  UsagePages._();

  static String episode(String id) => 'ep/$id'; // 회화 한 편(R0·R1 무료, R2~ 이용권)
  static String sense(String lessonId) => 'sense/$lessonId'; // 언어감각 회차(freeSenseLevels 급까지 무료)
  static String scenario(String id) => 'scn/$id'; // 기본 회화 장면(무료)
  static const vocab = 'vocab', particles = 'particles', loanwords = 'loanwords', loanwordQuiz = 'loanwords/quiz', hanja = 'hanja', hangul = 'hangul';

  static void view(String page) => UsageLog.view(page);
}

/// 환불 기준 숫자는 여기 한 곳(사용자가 바꿀 수 있음 — 서버 REFUND_RULE·talkverse.uk/refund/ 와 함께 고칠 것).
class RefundRule {
  RefundRule._();
  static const noRefundPct = 30;
  static const url = 'https://talkverse.uk/refund/';

  /// 내 정보 쪽 안내 문구(tr 키, {0} = noRefundPct).
  static const profileText = '유료 화면의 {0}% 이상을 열람하면 환불되지 않습니다.';

  /// 결제 화면 안내 문구 — 앱 안 결제는 스토어가 환불을 정하므로 30% 문구 대신 이 한 줄(사용자 확정 2026-11-28, USAGE_LOG.md 7). 바꾸면 l10n 사전 세 곳도.
  static const paywallText = '환불 심사 때 이용 기록이 스토어에 제공될 수 있습니다.';
}

/// 「내 정보」 열람률 — GET /v1/usage/summary?lang=ko. 로그인 전·실패면 null.
class UsageSummary {
  final int viewed, total;
  const UsageSummary(this.viewed, this.total);
  int get pct => total == 0 ? 0 : (viewed * 100 / total).floor();

  static Future<UsageSummary?> fetch({String lang = 'ko'}) async {
    try {
      final tok = await Account.accessToken();
      if (tok == null || tok.isEmpty) return null;
      final r = await http.get(Uri.parse('https://auth.talkverse.uk/v1/usage/summary?lang=$lang'),
          headers: {'Authorization': 'Bearer $tok'}).timeout(const Duration(seconds: 10));
      if (r.statusCode != 200) return null;
      final j = jsonDecode(r.body) as Map<String, dynamic>;
      var v = 0, t = 0;
      for (final x in (j['tiers'] as List? ?? const [])) {
        final m = x as Map<String, dynamic>;
        if (m['tier'] == 'free') continue; // 유료 화면만(pro, 한국어는 exam 없음)
        v += (m['viewed'] as num?)?.toInt() ?? 0;
        t += (m['total'] as num?)?.toInt() ?? 0;
      }
      return t == 0 ? null : UsageSummary(v, t);
    } catch (_) {
      return null;
    }
  }
}
