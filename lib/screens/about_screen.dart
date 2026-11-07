import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/l10n.dart';
import '../core/platform.dart';
import '../drama/drama_theme.dart';
import '../services/achievement_service.dart';

/// 「앱 소개」 — 절벽 구간이 무엇인지(일본어앱 about_screen 과 같은 짜임, 숫자는 한국어 산출값 `data/corpus/ko_cliff_summary.json`).
/// 공개 저장소 규칙: 말뭉치 제공처·작품 이름은 적지 않는다.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // 순위 상한 · 누적 %(2026-11-03 산출, 누적 55/60/70/80% 에 처음 닿는 순위 · R5 = 2,000위)
  static const _rows = [('R1', 1, 75, 55.0), ('R2', 76, 104, 60.0), ('R3', 105, 215, 70.1), ('R4', 216, 521, 80.0), ('R5', 522, 2000, 90.7)];

  @override
  Widget build(BuildContext context) {
    const h = TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: DramaColors.ink);
    const p = TextStyle(fontSize: 13.5, color: DramaColors.body, height: 1.55);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(tr('앱 소개'), style: const TextStyle(fontWeight: FontWeight.w900, color: DramaColors.ink))),
      body: ListView(padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset(context)), children: [
        Text(tr('처음 75개 단어가 한국 영화·드라마 대사의 55%를, 521개가 80%를 차지합니다. 이 앱은 그 가파른 구간 — 「절벽」 — 을 먼저 익히도록 짜여 있습니다.'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: DramaColors.ink, height: 1.5)),
        const SizedBox(height: 22),
        Text('1. ${tr('단어 기준')}', style: h),
        const SizedBox(height: 8),
        _Bars(rows: _rows),
        const SizedBox(height: 10),
        _Table(rows: _rows),
        const SizedBox(height: 22),
        Text('2. ${tr('산출 방식')}', style: h),
        const SizedBox(height: 6),
        Text(tr('말뭉치: 한국 제작 영화 430편과 드라마 3,838회차의 대사 자막, 약 2,322만 토큰. 단위는 형태소 — 조사·어미도 한 단어로 세고 용언은 기본형으로 묶습니다. 빈도 = 그 단어의 토큰 수 ÷ 전체 토큰 수. 구간 경계는 누적 빈도가 55 · 60 · 70 · 80%에 처음 닿는 순위로, 19개 언어 앱이 같은 기준을 씁니다. 80% 밖은 R5(2,000위까지).'), style: p),
        const SizedBox(height: 22),
        Text('3. ${tr('앱에서 쓰는 곳')}', style: h),
        const SizedBox(height: 6),
        Text(tr('• 절벽 단어: 구간별 단어를 20어 단원으로 익힙니다.\n• 회화: 편마다 문장의 단어가 단어장과 이어집니다.\n• 성과: 안정적으로 기억하는 단어가 대사의 몇 %를 덮는지, 다음 절벽까지 몇 개 남았는지 보여 줍니다.'), style: p),
        const SizedBox(height: 26),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, s) => Text('Talkverse Korean ${s.data == null ? '' : '${s.data!.version} (${s.data!.buildNumber})'}\n© Talkverse', style: const TextStyle(fontSize: 12, color: DramaColors.muted, height: 1.5)),
        ),
      ]),
    );
  }
}

class _Bars extends StatelessWidget {
  final List<(String, int, int, double)> rows;
  const _Bars({required this.rows});
  @override
  Widget build(BuildContext context) => Row(children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(width: 3),
          Expanded(
            child: Column(children: [
              Container(height: 10, decoration: BoxDecoration(color: DramaColors.jade.withValues(alpha: 1 - i * 0.17), borderRadius: BorderRadius.horizontal(left: Radius.circular(i == 0 ? 5 : 1), right: Radius.circular(i == rows.length - 1 ? 5 : 1)))),
              const SizedBox(height: 4),
              Text('${rows[i].$1} · ${rows[i].$4.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: DramaColors.ink)),
            ]),
          ),
        ],
      ]);
}

class _Table extends StatelessWidget {
  final List<(String, int, int, double)> rows;
  const _Table({required this.rows});
  @override
  Widget build(BuildContext context) {
    const s = TextStyle(fontSize: 12.5, color: DramaColors.ink);
    const hs = TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: DramaColors.muted);
    Widget cell(String t, {TextStyle st = s, TextAlign a = TextAlign.right}) => Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4), child: Text(t, textAlign: a, style: st));
    return Container(
      decoration: BoxDecoration(border: Border.all(color: DramaColors.line), borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Table(
        columnWidths: const {0: FixedColumnWidth(44)},
        children: [
          TableRow(children: [cell(tr('구간'), st: hs, a: TextAlign.left), cell(tr('순위'), st: hs), cell(tr('개수'), st: hs), cell(tr('누적'), st: hs)]),
          for (final r in rows) TableRow(children: [cell(r.$1, a: TextAlign.left, st: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: DramaColors.jade)), cell('${r.$2}–${r.$3}'), cell('${r.$3 - r.$2 + 1}'), cell('${r.$4.toStringAsFixed(1)}%')]),
        ],
      ),
    );
  }
}
