import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../core/l10n.dart';
import '../db/database.dart';
import '../drama/drama_service.dart';
import '../drama/drama_theme.dart';
import '../services/achievement_service.dart';

/// 「나」 탭 성과 데스크 — 시안 02 §5·wire_02. 큰 숫자 대신 문장 + 작은 진행 막대. 경쟁·순위·포인트·스트릭 없음.
class AchievementDesk extends StatefulWidget {
  const AchievementDesk({super.key});
  @override
  State<AchievementDesk> createState() => _AchievementDeskState();
}

class _AchievementDeskState extends State<AchievementDesk> {
  final _a = AchievementService.instance;
  ({double pct, int known, int nextCliff, int toNext})? _cov;

  @override
  void initState() {
    super.initState();
    _a.changes.addListener(_reload);
    _reload();
  }

  @override
  void dispose() {
    _a.changes.removeListener(_reload);
    super.dispose();
  }

  Future<void> _reload() async {
    await _a.load();
    await DramaService.instance.ensureLoaded();
    if (!mounted) return;
    final c = await _a.coverage(context.read<AppDatabase>());
    if (mounted) setState(() => _cov = c);
  }

  @override
  Widget build(BuildContext context) {
    // 자기 칸 너비 기준(아이패드 「나」 탭은 왼쪽 좁은 칸에 들어간다): 700 이상이면 좌우 2단, 아니면 세로 1단
    return LayoutBuilder(builder: (context, c) {
      final twoCol = c.maxWidth >= 700;
      final left = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _WeekLine(a: _a),
        const SizedBox(height: 12),
        _CoverageMeter(cov: _cov),
        const SizedBox(height: 12),
        _LeitnerBars(levels: _a.leitnerLevels()),
        const SizedBox(height: 12),
        _WeekDots(a: _a),
      ]);
      final right = _IslandGrid(a: _a, columns: c.maxWidth >= 900 ? 4 : (c.maxWidth >= 380 ? 2 : 1));
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        twoCol
            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 5, child: left), const SizedBox(width: 14), Expanded(flex: 7, child: right)])
            : Column(children: [left, const SizedBox(height: 12), right]),
        const SizedBox(height: 6),
        Text(tr('센다: 편 완주 · 라이트너 단계 · 핵심 표현 · 빈도 커버율  /  안 센다: 앱 오픈 · 스트릭 · 포인트 · 순위'),
            style: const TextStyle(fontSize: 10.5, color: DramaColors.muted, height: 1.4)),
      ]);
    });
  }
}

Widget _card({required Widget child, Color? border}) => Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: border ?? DramaColors.line), borderRadius: BorderRadius.circular(14)),
      child: child,
    );

Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: DramaColors.muted, letterSpacing: 1)));

class _WeekLine extends StatelessWidget {
  final AchievementService a;
  const _WeekLine({required this.a});
  @override
  Widget build(BuildContext context) {
    final w = a.thisWeek;
    final e = w['episodes'] ?? 0, c = w['cards'] ?? 0;
    final island = a.weekIsland();
    final line = e == 0 && c == 0
        ? tr('이번 주는 아직 조용해요. 편 하나를 끝까지 들어 보세요.')
        : (island.isNotEmpty ? trf('이번 주엔 {0} 주제를 가장 많이 읽었어요', [tr(DramaService.islandKo[island] ?? island)]) : tr('이번 주도 한 걸음씩 가고 있어요'));
    return _card(
      border: DramaColors.jade.withValues(alpha: 0.5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(tr('이번 주 한 줄')),
        Text(line, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: DramaColors.ink, height: 1.4)),
        const SizedBox(height: 4),
        Text(trf('편 {0} 완주 · 핵심 표현 {1} 맞음', [e, c]), style: const TextStyle(fontSize: 11.5, color: DramaColors.muted)),
      ]),
    );
  }
}

class _CoverageMeter extends StatelessWidget {
  final ({double pct, int known, int nextCliff, int toNext})? cov;
  const _CoverageMeter({required this.cov});
  @override
  Widget build(BuildContext context) {
    final pct = cov?.pct ?? 0;
    const cliffs = AchievementService.cliffs;
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(tr('빈도 커버율')),
        Row(children: [
          SizedBox(
            width: 76,
            height: 76,
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(width: 76, height: 76, child: CircularProgressIndicator(value: (pct / 100).clamp(0, 1), strokeWidth: 9, color: DramaColors.jade, backgroundColor: DramaColors.line)),
              Text('${pct.toStringAsFixed(pct < 10 ? 1 : 0)}%', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: DramaColors.ink)),
            ]),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(trf('내가 아는 단어로 일상 한국어의 약 {0}%를 이해할 수 있어요', [pct.toStringAsFixed(pct < 10 ? 1 : 0)]), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: DramaColors.ink, height: 1.4)),
              const SizedBox(height: 4),
              Text(cov == null ? '' : trf('안정적으로 기억하는 단어 {0}개 · 다음 절벽 {1}까지 {2}개 더', [cov!.known, cov!.nextCliff, cov!.toNext]), style: const TextStyle(fontSize: 11, color: DramaColors.jade, fontWeight: FontWeight.w700)),
            ]),
          ),
        ]),
        const SizedBox(height: 10),
        _label(tr('절벽 마일스톤')),
        // 절벽 구간 4칸 등폭(0→75→104→215→521): 2,500어 선형이면 앞 세 눈금이 왼쪽에 뭉친다(폰 확인 2026-11-04)
        Builder(builder: (context) {
          final known = cov?.known ?? 0;
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              for (var i = 0; i < cliffs.length; i++) ...[
                if (i > 0) const SizedBox(width: 3),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(i == 0 ? 4 : 1), right: Radius.circular(i == cliffs.length - 1 ? 4 : 1)),
                    child: Stack(children: [
                      Container(height: 8, color: DramaColors.line),
                      FractionallySizedBox(
                        widthFactor: ((known - (i == 0 ? 0 : cliffs[i - 1])) / (cliffs[i] - (i == 0 ? 0 : cliffs[i - 1]))).clamp(0.0, 1.0),
                        child: Container(height: 8, color: DramaColors.jade),
                      ),
                    ]),
                  ),
                ),
              ],
            ]),
            const SizedBox(height: 5),
            Row(children: [
              for (var i = 0; i < cliffs.length; i++) ...[
                if (i > 0) const SizedBox(width: 3),
                Expanded(
                  child: Text('${cliffs[i]}', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: known >= cliffs[i] ? DramaColors.jade : DramaColors.muted)),
                ),
              ],
            ]),
          ]);
        }),
      ]),
    );
  }
}

class _LeitnerBars extends StatelessWidget {
  final Map<int, int> levels;
  const _LeitnerBars({required this.levels});
  @override
  Widget build(BuildContext context) {
    final maxV = levels.values.fold<int>(1, (a, b) => a > b ? a : b);
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(tr('라이트너 분포(카드 수)')),
        SizedBox(
          height: 104,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            for (var lv = 1; lv <= 8; lv++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text('${levels[lv] ?? 0}', style: const TextStyle(fontSize: 9, color: DramaColors.muted)),
                    const SizedBox(height: 2),
                    Container(height: (66 * (levels[lv] ?? 0) / maxV).clamp(2, 66).toDouble(), decoration: BoxDecoration(color: lv == 8 ? DramaColors.ink : DramaColors.jade, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 3),
                    Text(lv == 8 ? tr('졸') : '$lv', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: DramaColors.muted)),
                  ]),
                ),
              ),
          ]),
        ),
      ]),
    );
  }
}

class _WeekDots extends StatelessWidget {
  final AchievementService a;
  const _WeekDots({required this.a});
  @override
  Widget build(BuildContext context) {
    const names = ['월', '화', '수', '목', '금', '토', '일'];
    final week = a.week();
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(tr('이번 주 되돌아보기')),
        Row(children: [
          for (final (d, n) in week)
            Expanded(
              child: Column(children: [
                Container(
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: n > 0 ? DramaColors.jade.withValues(alpha: 0.14) : Colors.white, border: Border.all(color: n > 0 ? DramaColors.jade : DramaColors.line), borderRadius: BorderRadius.circular(8)),
                  child: Text(DateTime.parse(d).weekday == 7 ? (AppLangPrefs.isKo ? '일' : tr('일(요일)')) : tr(names[DateTime.parse(d).weekday - 1]), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: DramaColors.ink)),
                ),
                const SizedBox(height: 3),
                Text(n > 0 ? trf('{0}편', [n]) : ' ', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: DramaColors.jade)),
              ]),
            ),
        ]),
      ]),
    );
  }
}

class _IslandGrid extends StatelessWidget {
  final AchievementService a;
  final int columns;
  const _IslandGrid({required this.a, required this.columns});
  @override
  Widget build(BuildContext context) {
    final svc = DramaService.instance;
    final islands = DramaService.islands.where((i) => ['R0', 'R1', 'R2', 'R3'].any((r) => svc.list(r, island: i).isNotEmpty)).toList();
    // 카드 높이 = 가장 줄이 많은 주제 기준(고정 182 는 줄 1~2개 카드에 빈 공간이 컸다 — 폰 확인 2026-11-04)
    var maxRows = 1;
    for (final i in islands) {
      final n = ['R0', 'R1', 'R2', 'R3'].where((r) => svc.list(r, island: i).isNotEmpty).length;
      if (n > maxRows) maxRows = n;
    }
    final extent = 14 * 2 + 20 + 8 + maxRows * 22 + 6 + 14.0;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: extent),
      itemCount: islands.length,
      itemBuilder: (context, i) {
        final isl = islands[i];
        final rows = <Widget>[];
        var exprRight = 0, exprTotal = 0;
        for (final r in ['R0', 'R1', 'R2', 'R3']) {
          final (done, all) = a.progress(island: isl, region: r);
          if (all == 0) continue;
          for (final d in svc.list(r, island: isl)) {
            final c = a.cardsOf(d.id);
            if (c != null) {
              exprRight += c[0];
              exprTotal += c[1];
            }
          }
          rows.add(Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(children: [
              SizedBox(width: 38, child: Text(tr(DramaService.levelKo[r] ?? r), style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: DramaColors.muted))),
              Expanded(
                child: Stack(children: [
                  Container(height: 7, decoration: BoxDecoration(color: DramaColors.line, borderRadius: BorderRadius.circular(4))),
                  FractionallySizedBox(widthFactor: all == 0 ? 0 : done / all, child: Container(height: 7, decoration: BoxDecoration(color: DramaColors.jade, borderRadius: BorderRadius.circular(4)))),
                ]),
              ),
              const SizedBox(width: 6),
              Text('$done/$all', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: done > 0 ? DramaColors.jade : DramaColors.muted)),
            ]),
          ));
        }
        return _card(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${DramaService.islandEmoji[isl]} ${tr(DramaService.islandKo[isl] ?? isl)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: DramaColors.ink)),
            const SizedBox(height: 8),
            ...rows,
            const Spacer(),
            Text(exprTotal > 0 ? trf('핵심 표현 {0}/{1} 기억', [exprRight, exprTotal]) : tr('그림 카드로 표현을 확인해 보세요'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: DramaColors.jade)),
          ]),
        );
      },
    );
  }
}
