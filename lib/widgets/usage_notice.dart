import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../data/account.dart';
import '../data/usage_pages.dart';
import '../drama/drama_theme.dart';
import 'legal_links.dart';

/// 「유료 화면의 30% 이상을 열람하면 환불되지 않습니다」 + 환불 규정 링크(결제 화면·내 정보 공용). 숫자는 RefundRule 한 곳.
class RefundNotice extends StatelessWidget {
  final bool paywall; // 결제 화면이면 RefundRule.paywallText
  const RefundNotice({super.key, this.paywall = false});
  @override
  Widget build(BuildContext context) => Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, children: [
        Text(trf(paywall ? RefundRule.paywallText : RefundRule.profileText, ['${RefundRule.noRefundPct}']),
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5, color: DramaColors.muted, height: 1.4)),
        TextButton(
          onPressed: () => Legal.open(RefundRule.url),
          child: Text(tr('환불 규정'), style: const TextStyle(fontSize: 12, color: DramaColors.jade, fontWeight: FontWeight.w700, decoration: TextDecoration.underline)),
        ),
      ]);
}

/// 「내 정보」 열람률 — 로그인했을 때만, 서버 집계(유료 화면 중 연 수 / 전체).
class UsageRateTile extends StatelessWidget {
  const UsageRateTile({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<Map<String, dynamic>?>(
        valueListenable: Account.user,
        builder: (context, u, _) => u == null
            ? const SizedBox.shrink()
            : FutureBuilder<UsageSummary?>(
                future: UsageSummary.fetch(),
                builder: (context, s) {
                  final v = s.data;
                  return Column(children: [
                    ListTile(
                      leading: const Icon(Icons.visibility_outlined, color: DramaColors.muted),
                      title: Text(tr('유료 화면 열람률')),
                      subtitle: Text(
                          v == null ? (s.connectionState == ConnectionState.done ? tr('아직 집계가 없습니다') : tr('확인 중…')) : trf('{0} / {1}개 화면 · {2}%', ['${v.viewed}', '${v.total}', '${v.pct}']),
                          style: const TextStyle(fontSize: 12)),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(12, 0, 12, 6), child: RefundNotice()),
                  ]);
                },
              ),
      );
}
