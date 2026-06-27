import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/ui/colors.dart';
import 'package:k_universe/ui/spacing.dart';
import 'package:k_universe/ui/typography.dart';

class ParticlesScreen extends StatelessWidget {
  const ParticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Particles & Endings'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Particle>>(
          future: (db.select(db.particles)
                ..orderBy([(t) => OrderingTerm.asc(t.rank)]))
              .get(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final list = snap.data!;
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                  KSpace.lg, KSpace.sm, KSpace.lg, KSpace.lg),
              itemCount: list.length + 1,
              separatorBuilder: (_, _x) => const SizedBox(height: KSpace.md),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: KSpace.sm, bottom: KSpace.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Top 19 functional morphemes',
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          'These 19 particles and endings cover about 63 % of everyday Korean speech.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  );
                }
                return _ParticleCard(entry: list[i - 1]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _ParticleCard extends StatelessWidget {
  final Particle entry;
  const _ParticleCard({required this.entry});

  Color _categoryColor() {
    if (entry.category.startsWith('particle')) return KColors.annParticle;
    if (entry.category.contains('honorific')) return KColors.annHonorific;
    if (entry.category.startsWith('ending')) return KColors.annEnding;
    if (entry.category.startsWith('verb-stem')) return KColors.annVocab;
    return KColors.softPink;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _categoryColor();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(KSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '${entry.rank}',
                    style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
                Text(entry.morph,
                    style: KType.koHero.copyWith(color: color)),
                const SizedBox(width: KSpace.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    entry.category,
                    style: theme.textTheme.labelLarge?.copyWith(
                        color: color, fontSize: 10),
                  ),
                ),
                const Spacer(),
                if (entry.cumPct != null)
                  Text(
                    '${entry.cumPct!.toStringAsFixed(1)}%',
                    style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary),
                  ),
              ],
            ),
            const SizedBox(height: KSpace.sm),
            Text(entry.glossEn, style: theme.textTheme.bodyLarge),
            if (entry.notesEn != null) ...[
              const SizedBox(height: KSpace.sm),
              Text(
                entry.notesEn!,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
