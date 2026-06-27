import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/ui/spacing.dart';
import 'package:k_universe/ui/typography.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Korean Words'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<VocabEntry>>(
          future: (db.select(db.vocab)
                ..orderBy([(t) => OrderingTerm.asc(t.rank)]))
              .get(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final words = snap.data!;
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                  KSpace.lg, KSpace.sm, KSpace.lg, KSpace.lg),
              itemCount: words.length + 1,
              separatorBuilder: (_, _x) => const SizedBox(height: KSpace.sm),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: KSpace.sm, bottom: KSpace.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Top 100 Korean lemmas',
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          'Sorted by frequency. The first 100 cover roughly 48 % of everyday Korean speech.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  );
                }
                return _VocabRow(entry: words[i - 1]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _VocabRow extends StatelessWidget {
  final VocabEntry entry;
  const _VocabRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: KSpace.lg, vertical: KSpace.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 36,
              child: Text(
                '${entry.rank}',
                style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            Text(entry.word, style: KType.koHero.copyWith(fontSize: 22)),
            const SizedBox(width: KSpace.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.glossEn ?? '—',
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (entry.pos != null && entry.pos!.isNotEmpty)
                    Text(
                      entry.pos!,
                      style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11),
                    ),
                ],
              ),
            ),
            if (entry.cumPct != null)
              Text(
                '${entry.cumPct!.toStringAsFixed(1)}%',
                style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary),
              ),
          ],
        ),
      ),
    );
  }
}
