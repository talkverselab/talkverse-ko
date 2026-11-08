import 'package:flutter/material.dart';

import '../../core/l10n.dart';
import '../../core/platform.dart';
import '../../drama/drama_theme.dart';
import 'hangul_phonetics.dart';
import 'hangul_sound_sheet.dart';

/// 한글과 발음 — 일본어앱 「50음도와 발음」과 같은 메뉴(공통 프롬프터 §5-3, 2026-11-08).
/// 묶음 칩: 자음 19 · 모음 21 · 받침 7 · 음절표. 로마자 토글. 글자 탭 → 발음 시트(1초 뒤 재생·IPA·조음 위치·영어 비교).
class HangulChartScreen extends StatefulWidget {
  const HangulChartScreen({super.key});
  @override
  State<HangulChartScreen> createState() => _HangulChartScreenState();
}

class _HangulChartScreenState extends State<HangulChartScreen> {
  int _set = 0;
  bool _rr = true;

  static const _rowColors = [Color(0xFF3D8B7A), Color(0xFF0A2540), Color(0xFF635BFF), Color(0xFFB77548)];

  @override
  Widget build(BuildContext context) {
    final labels = [tr('자음 19'), tr('모음 21'), tr('받침 7'), tr('음절표')];
    return Scaffold(
      backgroundColor: DramaColors.bg,
      appBar: AppBar(
        backgroundColor: DramaColors.ink,
        foregroundColor: Colors.white,
        title: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(tr('한글과 발음'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          Text(tr('탭하면 발음·IPA 상세'), style: const TextStyle(fontSize: 10, color: Colors.white70, letterSpacing: 1)),
        ]),
        actions: [
          IconButton(
            tooltip: tr('로마자'),
            icon: Text('Aa', style: TextStyle(fontWeight: FontWeight.w900, color: _rr ? Colors.white : Colors.white38, decoration: _rr ? null : TextDecoration.lineThrough)),
            onPressed: () => setState(() => _rr = !_rr),
          ),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 52,
          child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.fromLTRB(12, 10, 12, 6), children: [
            for (var i = 0; i < labels.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(labels[i]),
                  selected: _set == i,
                  showCheckmark: false,
                  selectedColor: DramaColors.jade,
                  labelStyle: TextStyle(color: _set == i ? Colors.white : DramaColors.ink, fontWeight: FontWeight.w800, fontSize: 12.5),
                  onSelected: (_) => setState(() => _set = i),
                ),
              ),
          ]),
        ),
        Expanded(child: _set == 3 ? _syllables() : _groups()),
      ]),
    );
  }

  Widget _groups() {
    final groups = switch (_set) {
      0 => [(tr('예사소리'), consonants.where((j) => j.kind == 'plain').toList()), (tr('거센소리'), consonants.where((j) => j.kind == 'aspirated').toList()), (tr('된소리'), consonants.where((j) => j.kind == 'tense').toList())],
      1 => [(tr('기본 모음'), vowels.where((j) => j.kind == 'vowel').toList()), (tr('겹모음'), vowels.where((j) => j.kind == 'compound').toList())],
      _ => [(tr('받침 7대표음'), batchim)],
    };
    return LayoutBuilder(builder: (context, c) {
      final cols = (c.maxWidth ~/ 86).clamp(4, 8);
      return ListView(padding: EdgeInsets.fromLTRB(12, 4, 12, 24 + bottomInset(context)), children: [
        for (var g = 0; g < groups.length; g++) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
            child: Row(children: [
              Container(width: 4, height: 14, color: _rowColors[g % 4]),
              const SizedBox(width: 6),
              Text('${groups[g].$1} · ${groups[g].$2.length}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: DramaColors.muted)),
            ]),
          ),
          GridView.count(
            crossAxisCount: cols,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.92,
            children: [for (final j in groups[g].$2) _cell(j, _rowColors[g % 4])],
          ),
        ],
        if (_set == 2)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 14, 4, 0),
            child: Text(tr('받침은 끝에서 터뜨리지 않는다 — 글자는 27가지지만 소리는 7가지뿐.'), style: const TextStyle(fontSize: 12, color: DramaColors.body, height: 1.5)),
          ),
      ]);
    });
  }

  Widget _cell(Jamo j, Color color) => Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: color.withValues(alpha: 0.5))),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => showHangulSoundSheet(context, j),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(j.kind == 'batchim' ? j.sample : j.ch, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: color)),
            if (_rr) Text(j.rr, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: DramaColors.muted)),
            Text(j.kind == 'batchim' ? j.ch : j.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: DramaColors.body)),
          ]),
        ),
      );

  /// 음절표: 기본 자음 14 × 기본 모음 10.
  Widget _syllables() {
    final cons = consonants.where((j) => j.kind != 'tense').toList();
    final vs = vowels.where((j) => j.kind == 'vowel').toList();
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 24 + bottomInset(context)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(54),
          border: TableBorder.all(color: DramaColors.line),
          children: [
            TableRow(decoration: const BoxDecoration(color: DramaColors.jadeSoft), children: [
              const SizedBox(height: 40),
              for (final v in vs) Center(child: Padding(padding: const EdgeInsets.all(6), child: Text(v.ch, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: DramaColors.jade)))),
            ]),
            for (final c in cons)
              TableRow(children: [
                Container(color: DramaColors.jadeSoft, height: 52, alignment: Alignment.center, child: Text(c.ch, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: DramaColors.jade))),
                for (final v in vs)
                  InkWell(
                    onTap: () => showHangulSoundSheet(context, c, syllable: compose(c.ch, v.ch)),
                    child: SizedBox(
                      height: 52,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(compose(c.ch, v.ch), style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: DramaColors.ink)),
                        if (_rr) Text('${romanPlainSyllable[c.ch]}${romanVowel[v.ch]}', style: const TextStyle(fontSize: 9.5, color: DramaColors.muted)),
                      ]),
                    ),
                  ),
              ]),
          ],
        ),
      ),
    );
  }
}
