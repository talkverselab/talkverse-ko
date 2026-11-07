import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n.dart';
import '../../core/platform.dart';
import '../../db/database.dart';
import '../../drama/drama_service.dart';
import '../../drama/drama_theme.dart';
import '../../drama/lemma_chips.dart';
import '../../services/achievement_service.dart';
import '../../services/content_sync.dart';

/// 절벽 단어 — 빈도순 단어장. 구간 칩(R1~R4·그 밖) + 찾기 + 그림. 누르면 단어 시트.
class VocabularyScreen extends StatefulWidget {
  final bool focusSearch;
  const VocabularyScreen({super.key, this.focusSearch = false});
  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  List<VocabEntry>? _all;
  int _band = 0; // 0 = R1 … 3 = R4, 4 = 그 밖
  String _q = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = context.read<AppDatabase>();
    await DramaService.instance.ensureLoaded();
    final rows = await (db.select(db.vocab)..orderBy([(t) => OrderingTerm.asc(t.rank)])).get();
    if (mounted) setState(() => _all = rows);
  }

  List<VocabEntry> get _shown {
    final all = _all ?? const <VocabEntry>[];
    final q = _q.trim().toLowerCase();
    if (q.isNotEmpty) return all.where((v) => v.word.contains(q) || (v.glossEn ?? '').toLowerCase().contains(q)).take(200).toList();
    const c = AchievementService.cliffs;
    final lo = _band == 0 ? 0 : c[_band - 1];
    final hi = _band < c.length ? c[_band] : 1 << 30;
    return all.where((v) => v.rank > lo && v.rank <= hi).toList();
  }

  @override
  Widget build(BuildContext context) {
    final words = _shown;
    return Scaffold(
      backgroundColor: DramaColors.bg,
      appBar: AppBar(backgroundColor: DramaColors.ink, foregroundColor: Colors.white, title: Text(tr('절벽 단어'), style: const TextStyle(fontWeight: FontWeight.w900))),
      body: _all == null
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                    for (var i = 0; i < 5; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(i < 4 ? 'R${i + 1}' : tr('그 밖')),
                          selected: _band == i,
                          showCheckmark: false,
                          selectedColor: DramaColors.jade,
                          labelStyle: TextStyle(color: _band == i ? Colors.white : DramaColors.ink, fontWeight: FontWeight.w700),
                          onSelected: (_) => setState(() => _band = i),
                        ),
                      ),
                  ]),
                ),
              Expanded(
                child: words.isEmpty
                    ? Center(child: Text(tr('찾는 단어가 없습니다'), style: const TextStyle(color: DramaColors.muted)))
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + bottomInset(context)),
                        itemCount: words.length,
                        itemBuilder: (context, i) => _Row(v: words[i]),
                      ),
              ),
            ]),
    );
  }
}

class _Row extends StatelessWidget {
  final VocabEntry v;
  const _Row({required this.v});
  @override
  Widget build(BuildContext context) {
    final art = ContentSync.instance.wordArt(v.word);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: DramaColors.line)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => showWordSheet(context, v, DramaService.instance.romanOf[v.word] ?? ''),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(children: [
              SizedBox(width: 36, child: Text('${v.rank}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: DramaColors.muted))),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: art == null ? Container(color: DramaColors.jadeSoft) : Image(image: artProvider(art), fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: DramaColors.jadeSoft)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(v.word, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: DramaColors.ink)),
                  if ((v.glossEn ?? '').isNotEmpty) Text(v.glossEn!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, color: DramaColors.body)),
                ]),
              ),
              if (v.cumPct != null) Text('${v.cumPct!.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 11, color: DramaColors.jade, fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
      ),
    );
  }
}
