import 'dart:convert';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import '../../core/l10n.dart';
import '../../core/platform.dart';
import '../../db/database.dart';
import '../../drama/drama_service.dart';
import '../../drama/drama_theme.dart';
import '../../drama/lemma_chips.dart';
import '../../drama/roman_toggle.dart';
import '../../services/learner_prefs.dart';
import '../../services/achievement_service.dart';
import '../../services/content_sync.dart';
import '../../services/tts_service.dart';

/// 절벽 단어 — 일본어앱 2026-11-07 개편과 같은 구조(`docs/MENU_WORDS_2026-11-07.md`).
/// R5 는 2,000위에서 끊고, 20어 = 한 단원(머리줄 「1단원 · #1-20 · R1」), 단어는 네모 타일 격자(순위·로마자·그림·단어·뜻), 탭하면 발음.
/// 위 버튼 2개 「절벽구간 단어만 / 회화 단어 포함(+N)」 — 포함이면 회화 레마 중 2,000위 밖·단어 DB 에 있는 것이 「회화」 구간으로 뒤에 붙는다
/// (`assets/data/freq/conv_words_ko.json`, 생성 `tools/conv_words.py`). DB 는 합치지 않고 화면에서만 합친다.
class VocabularyScreen extends StatefulWidget {
  final bool focusSearch;
  const VocabularyScreen({super.key, this.focusSearch = false});
  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _Word {
  final int rank; // 회화 구간은 0
  final String word, rd, en;
  final String region; // R1~R5 · 회화
  const _Word(this.rank, this.word, this.rd, this.en, this.region);
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  static const maxRank = 2000;
  List<_Word>? _cliff;
  List<_Word> _conv = const [];
  bool _withConv = false;
  String _band = '전체'; // 전체 · R1~R5 · 회화
  String _q = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  static String regionOf(int rank) {
    const c = AchievementService.cliffs;
    for (var i = 0; i < c.length; i++) {
      if (rank <= c[i]) return 'R${i + 1}';
    }
    return 'R5';
  }

  Future<void> _load() async {
    final db = context.read<AppDatabase>();
    await DramaService.instance.ensureLoaded();
    final rows = await (db.select(db.vocab)..orderBy([(t) => OrderingTerm.asc(t.rank)])).get();
    final roman = DramaService.instance.romanOf;
    final cliff = [for (final v in rows) if (v.rank <= maxRank) _Word(v.rank, v.word, roman[v.word] ?? '', v.glossEn ?? '', regionOf(v.rank))];
    if (mounted) setState(() => _cliff = cliff);
    // 회화 단어 목록은 따로 — 늦게 와도 절벽 단어 화면은 먼저 뜬다
    try {
      final j = json.decode(await rootBundle.loadString('assets/data/freq/conv_words_ko.json')) as Map<String, dynamic>;
      final conv = [for (final w in (j['words'] as List? ?? const [])) _Word(0, '${w['word']}', '${w['rd'] ?? ''}', '${w['en'] ?? ''}', '회화')];
      if (mounted) setState(() => _conv = conv);
    } catch (_) {}
  }

  List<_Word> get _shown {
    final all = [...?_cliff, if (_withConv) ..._conv];
    final q = _q.trim().toLowerCase();
    if (q.isNotEmpty) return all.where((w) => w.word.contains(q) || w.en.toLowerCase().contains(q) || w.rd.contains(q)).take(200).toList();
    if (_band == '전체') return all;
    return all.where((w) => w.region == _band).toList();
  }

  @override
  Widget build(BuildContext context) {
    final words = _shown;
    final bands = ['전체', 'R1', 'R2', 'R3', 'R4', 'R5', if (_withConv) '회화'];
    return Scaffold(
      backgroundColor: DramaColors.bg,
      appBar: AppBar(backgroundColor: DramaColors.ink, foregroundColor: Colors.white, title: Text(tr('절벽 단어'), style: const TextStyle(fontWeight: FontWeight.w900)), actions: const [RomanToggleAction()]),
      body: _cliff == null
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(children: [
                  Expanded(
                    child: SegmentedButton<bool>(
                      showSelectedIcon: false,
                      style: SegmentedButton.styleFrom(visualDensity: VisualDensity.compact, selectedBackgroundColor: DramaColors.jade, selectedForegroundColor: Colors.white, textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                      segments: [
                        ButtonSegment(value: false, label: Text(tr('절벽구간 단어만'))),
                        ButtonSegment(value: true, label: Text(trf('회화 단어 포함 (+{0})', [_conv.length]))),
                      ],
                      selected: {_withConv},
                      onSelectionChanged: (s) => setState(() {
                        _withConv = s.first;
                        if (!_withConv && _band == '회화') _band = '전체';
                      }),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                child: TextField(
                  autofocus: widget.focusSearch,
                  onChanged: (v) => setState(() => _q = v),
                  decoration: InputDecoration(hintText: tr('단어 · 뜻으로 찾기'), prefixIcon: const Icon(Icons.search), isDense: true, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: DramaColors.line))),
                ),
              ),
              if (_q.trim().isEmpty)
                SizedBox(
                  height: 40,
                  child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), children: [
                    for (final b in bands)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(b == '전체' || b == '회화' ? tr(b) : b),
                          selected: _band == b,
                          showCheckmark: false,
                          selectedColor: DramaColors.jade,
                          labelStyle: TextStyle(color: _band == b ? Colors.white : DramaColors.ink, fontWeight: FontWeight.w700),
                          onSelected: (_) => setState(() => _band = b),
                        ),
                      ),
                  ]),
                ),
              Expanded(
                child: words.isEmpty
                    ? Center(child: Text(tr('찾는 단어가 없습니다'), style: const TextStyle(color: DramaColors.muted)))
                    : LayoutBuilder(builder: (context, c) {
                        final cols = (c.maxWidth ~/ 112).clamp(3, 8);
                        final units = <List<_Word>>[];
                        for (var i = 0; i < words.length; i += 20) {
                          units.add(words.sublist(i, (i + 20).clamp(0, words.length)));
                        }
                        return ListView.builder(
                          padding: EdgeInsets.fromLTRB(12, 6, 12, 24 + bottomInset(context)),
                          itemCount: units.length,
                          itemBuilder: (context, u) {
                            final list = units[u];
                            final first = list.first, last = list.last;
                            final head = first.rank == 0
                                ? '${tr('회화')} · ${u * 20 + 1}-${u * 20 + list.length}'
                                : '#${first.rank}-${last.rank} · ${first.region == last.region ? first.region : '${first.region}~${last.region}'}';
                            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
                                child: Text('${trf('{0}단원', [u + 1])} · $head', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: DramaColors.muted)),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 150),
                                itemCount: list.length,
                                itemBuilder: (context, i) => _Tile(w: list[i], db: context.read<AppDatabase>()),
                              ),
                            ]);
                          },
                        );
                      }),
              ),
            ]),
    );
  }
}

class _Tile extends StatelessWidget {
  final _Word w;
  final AppDatabase db;
  const _Tile({required this.w, required this.db});

  Future<void> _open(BuildContext context) async {
    final v = await (db.select(db.vocab)..where((t) => t.word.equals(w.word))).getSingleOrNull();
    if (v != null && context.mounted) showWordSheet(context, v, w.rd);
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(valueListenable: LearnerPrefs.roman, builder: (context, _, _) => _build(context));

  Widget _build(BuildContext context) {
    final art = ContentSync.instance.wordArt(w.word);
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: DramaColors.line)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => TtsService.instance.speak(w.word),
        onLongPress: () => _open(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(w.rank == 0 ? tr('회화') : '${w.rank}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: DramaColors.jade)),
              const SizedBox(width: 6),
              Expanded(child: Text(LearnerPrefs.roman.value ? w.rd : '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: DramaColors.muted))),
            ]),
            const SizedBox(height: 4),
            Expanded(
              child: Center(
                child: art == null
                    ? const Icon(Icons.volume_up_rounded, color: DramaColors.line, size: 28)
                    : ClipRRect(borderRadius: BorderRadius.circular(8), child: Image(image: artProvider(art), fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, _, _) => const SizedBox.shrink())),
              ),
            ),
            const SizedBox(height: 4),
            Text(w.word, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: DramaColors.ink)),
            Text(w.en, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, color: DramaColors.body)),
          ]),
        ),
      ),
    );
  }
}
