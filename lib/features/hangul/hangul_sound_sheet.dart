import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/l10n.dart';
import '../../core/platform.dart';
import '../../drama/drama_theme.dart';
import '../../services/tts_service.dart';
import 'hangul_phonetics.dart';
import 'vowel_compare_chart.dart';

/// 자모 탭 → 발음 상세 시트(일본어앱 kana_sound_sheet 이식). 열리면 1초 뒤 자동 재생, 다시 듣기·이름 듣기, IPA·조음 위치·영어 비교·모음 위치.
Future<void> showHangulSoundSheet(BuildContext context, Jamo j, {String? syllable}) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _Sheet(j: j, syllable: syllable ?? j.sample),
    );

class _Sheet extends StatefulWidget {
  final Jamo j;
  final String syllable;
  const _Sheet({required this.j, required this.syllable});
  @override
  State<_Sheet> createState() => _SheetState();
}

class _SheetState extends State<_Sheet> {
  Timer? _auto;
  bool _chart = false;

  @override
  void initState() {
    super.initState();
    _auto = Timer(const Duration(seconds: 1), () => TtsService.instance.speak(widget.syllable));
  }

  @override
  void dispose() {
    _auto?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final j = widget.j;
    final isVowel = j.kind == 'vowel' || j.kind == 'compound';
    final vc = isVowel ? vowelCharts[j.ch] : null;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, scroll) => ListView(
        controller: scroll,
        padding: EdgeInsets.fromLTRB(20, 12, 20, 32 + bottomInset(context)),
        children: [
          Row(children: [
            Container(
              width: 84,
              height: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: DramaColors.jade, borderRadius: BorderRadius.circular(12)),
              child: Text(j.kind == 'batchim' ? widget.syllable : j.ch, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Colors.white)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(j.kind == 'batchim' ? trf('받침 {0}', [j.name]) : '${j.ch} · ${j.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: DramaColors.ink)),
                Text(j.rr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: DramaColors.jade)),
                Text('IPA [${j.ipa}]', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: DramaColors.body)),
              ]),
            ),
            IconButton(iconSize: 44, color: DramaColors.jade, tooltip: tr('다시 듣기'), icon: const Icon(Icons.play_circle_fill), onPressed: () => TtsService.instance.speak(widget.syllable)),
          ]),
          if (j.kind != 'batchim' && j.name != j.ch)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(onPressed: () => TtsService.instance.speak(j.name), icon: const Icon(Icons.record_voice_over_outlined, size: 18), label: Text(trf('이름 듣기 ({0})', [j.name]))),
            ),
          const SizedBox(height: 12),
          _box(tr('👄 소리나는 곳 · 입모양'), j.place),
          if (vc != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: DramaColors.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: DramaColors.line)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tr('📍 모음 위치 — 한국어 vs 영어'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: DramaColors.jade)),
                const SizedBox(height: 10),
                VowelCompareChart(data: vc),
              ]),
            ),
          ],
          const SizedBox(height: 6),
          InkWell(
            onTap: () => setState(() => _chart = !_chart),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                Icon(_chart ? Icons.expand_less : Icons.expand_more, size: 18, color: DramaColors.jade),
                Text(isVowel ? tr('모음표 그림 보기') : tr('자음 조음 위치 그림 보기'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: DramaColors.jade)),
              ]),
            ),
          ),
          if (_chart) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(color: Colors.white, padding: const EdgeInsets.all(8), child: Image.asset(isVowel ? 'assets/images/ipa/ipa_vowel_chart.png' : 'assets/images/ipa/places_of_articulation.png', fit: BoxFit.contain)),
            ),
          ],
          const SizedBox(height: 14),
          _box(tr('🇺🇸 영어와 비교'), j.eng),
        ],
      ),
    );
  }

  Widget _box(String t, String b) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: DramaColors.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: DramaColors.line)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: DramaColors.jade)),
          const SizedBox(height: 8),
          Text(b, style: const TextStyle(fontSize: 13.5, height: 1.55, color: DramaColors.ink)),
        ]),
      );
}
