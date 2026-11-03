import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/l10n.dart';
import '../db/database.dart';
import 'drama_service.dart';
import 'drama_theme.dart';

/// 문장의 내용어(레마) 칩 — 단어장에 있는 말은 누르면 단어 시트, 없는 말은 회색(사용자 지시 2026-11-04 "문장 레마별로 단어장이랑 연결").
/// 레마는 `tools/add_lemmas.py`(kiwi)가 턴마다 채운다. 단어장에 없는 레마는 `data/review/write/missing_lemmas.csv` → uk 세션이 단어·그림 제작.
class LemmaChips extends StatelessWidget {
  final DramaTurn turn;
  final bool compact;
  const LemmaChips({super.key, required this.turn, this.compact = false});

  static final Map<String, VocabEntry?> _cache = {};

  static Future<Map<String, VocabEntry>> _lookup(AppDatabase db, List<String> bases) async {
    final todo = bases.where((b) => !_cache.containsKey(b)).toList();
    if (todo.isNotEmpty) {
      final rows = await (db.select(db.vocab)..where((v) => v.word.isIn(todo))).get();
      for (final b in todo) {
        _cache[b] = null;
      }
      for (final r in rows) {
        _cache[r.word] = r;
      }
    }
    return {for (final b in bases) if (_cache[b] != null) b: _cache[b]!};
  }

  @override
  Widget build(BuildContext context) {
    final seen = <String>{};
    final lemmas = [for (final l in turn.lemmas) if (seen.add(l.base)) l];
    if (lemmas.isEmpty) return const SizedBox.shrink();
    final db = context.read<AppDatabase>();
    return FutureBuilder<Map<String, VocabEntry>>(
      key: ValueKey('${turn.num}:${turn.ko}'),
      future: _lookup(db, lemmas.map((l) => l.base).toList()),
      builder: (context, snap) {
        final found = snap.data ?? const {};
        return Wrap(spacing: 6, runSpacing: 6, children: [
          for (final l in lemmas)
            _Chip(
              label: l.base,
              gloss: found[l.base]?.glossEn,
              compact: compact,
              onTap: found[l.base] == null ? null : () => _sheet(context, found[l.base]!, l.rd),
            ),
        ]);
      },
    );
  }

  static void _sheet(BuildContext context, VocabEntry v, String rd) => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(v.word, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: DramaColors.ink)),
            Text(rd, style: const TextStyle(fontSize: 14, color: DramaColors.jade)),
            const SizedBox(height: 10),
            if ((v.glossEn ?? '').isNotEmpty) Text(v.glossEn!, style: const TextStyle(fontSize: 16, color: DramaColors.body)),
            const SizedBox(height: 10),
            Text(trf('빈도 {0}위', [v.rank]), style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
          ]),
        ),
      );
}

class _Chip extends StatelessWidget {
  final String label;
  final String? gloss;
  final bool compact;
  final VoidCallback? onTap;
  const _Chip({required this.label, this.gloss, this.compact = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    final on = onTap != null;
    final g = (gloss ?? '').split(RegExp(r'[,;·/(]')).first.trim();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? 7 : 9, vertical: compact ? 3 : 4),
        decoration: BoxDecoration(
          color: on ? Colors.white : DramaColors.bg,
          border: Border.all(color: on ? DramaColors.jade.withValues(alpha: 0.7) : DramaColors.line),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: TextStyle(fontSize: compact ? 12 : 13.5, fontWeight: FontWeight.w800, color: on ? DramaColors.ink : DramaColors.muted)),
          if (g.isNotEmpty) ...[
            const SizedBox(width: 5),
            Text(g, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: compact ? 10 : 11, color: DramaColors.body)),
          ],
        ]),
      ),
    );
  }
}
