import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/ui/colors.dart';
import 'package:k_universe/ui/mascot.dart';
import 'package:k_universe/ui/spacing.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: SafeArea(
        child: StreamBuilder<List<Scenario>>(
          stream: db.select(db.scenarios).watch(),
          builder: (context, scenarioSnap) {
            return StreamBuilder<List<UserProgressRow>>(
              stream: db.select(db.userProgress).watch(),
              builder: (context, progressSnap) {
                final scenarios = scenarioSnap.data ?? const <Scenario>[];
                final progress =
                    progressSnap.data ?? const <UserProgressRow>[];
                final completed = progress
                    .where((p) => p.status == 'completed')
                    .toList();
                final inProgress = progress
                    .where((p) => p.status == 'in_progress')
                    .toList();
                final totalScenes = scenarios.length;
                final donePct = totalScenes == 0
                    ? 0.0
                    : completed.length / totalScenes;

                final daysSet = <String>{};
                for (final p in completed) {
                  final d = p.completedAt;
                  if (d == null) continue;
                  daysSet.add('${d.year}-${d.month}-${d.day}');
                }
                final daysActive = daysSet.length;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                      KSpace.lg, KSpace.md, KSpace.lg, KSpace.xxxl),
                  children: [
                    _OverallCard(
                        pct: donePct,
                        completed: completed.length,
                        total: totalScenes),
                    const SizedBox(height: KSpace.md),
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            emoji: '✅',
                            tile: KColors.tileMint,
                            value: '${completed.length}',
                            label: 'Scenes done',
                          ),
                        ),
                        const SizedBox(width: KSpace.md),
                        Expanded(
                          child: _StatTile(
                            emoji: '🌱',
                            tile: KColors.tileSage,
                            value: '${inProgress.length}',
                            label: 'In progress',
                          ),
                        ),
                        const SizedBox(width: KSpace.md),
                        Expanded(
                          child: _StatTile(
                            emoji: '🔥',
                            tile: KColors.tileGold,
                            value: '$daysActive',
                            label: 'Active days',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: KSpace.xl),
                    Text(
                      'Recent activity',
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: KSpace.md),
                    if (completed.isEmpty)
                      _EmptyActivity()
                    else
                      ...completed.take(8).map((p) {
                        final s = scenarios.firstWhere(
                          (s) => s.id == p.scenarioId,
                          orElse: () => _placeholder,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(bottom: KSpace.sm),
                          child: _ActivityRow(
                              scenario: s, completedAt: p.completedAt),
                        );
                      }),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  static final _placeholder = Scenario(
    id: '?',
    titleEn: 'Scenario',
    settingEn: '',
    summaryEn: '',
    difficulty: 1,
    turnCount: 0,
    source: '',
    sourceRef: null,
    createdAt: DateTime.now(),
  );
}

class _OverallCard extends StatelessWidget {
  final double pct;
  final int completed;
  final int total;
  const _OverallCard({
    required this.pct,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pctText = total == 0 ? '0%' : '${(pct * 100).toStringAsFixed(0)}%';
    return Container(
      padding: const EdgeInsets.all(KSpace.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall progress',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: KColors.inkSoft, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                pctText,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 40,
                  color: KColors.softPink,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '$completed / $total scenes',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: KColors.inkSoft, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: KSpace.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: theme.colorScheme.outlineVariant,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(KColors.softPink),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String emoji;
  final Color tile;
  final String value;
  final String label;
  const _StatTile({
    required this.emoji,
    required this.tile,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: KSpace.md, vertical: KSpace.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: tile,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: KSpace.sm),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800, fontSize: 22),
          ),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
                color: KColors.inkSoft, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final Scenario scenario;
  final DateTime? completedAt;
  const _ActivityRow({required this.scenario, required this.completedAt});

  String _dateLabel() {
    if (completedAt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(completedAt!);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visual = ScenarioVisual.forId(scenario.id);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: KSpace.md, vertical: KSpace.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: visual.tileColor,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child:
                Text(visual.emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: KSpace.md),
          Expanded(
            child: Text(
              scenario.titleEn,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _dateLabel(),
            style: theme.textTheme.labelLarge?.copyWith(
                color: KColors.inkFaint, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: KSpace.xl, vertical: KSpace.xxl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          const Mascot(MascotPose.tired, size: 120),
          const SizedBox(height: KSpace.md),
          Text(
            'No scenes completed yet',
            style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Finish your first scene and it\'ll show up here.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: KColors.inkSoft, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
