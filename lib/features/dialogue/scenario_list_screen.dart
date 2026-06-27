import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/features/dialogue/dialogue_player_screen.dart';
import 'package:k_universe/ui/colors.dart';
import 'package:k_universe/ui/spacing.dart';

class ScenarioListScreen extends StatelessWidget {
  const ScenarioListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('K-Universe'),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Scenario>>(
          stream: db.select(db.scenarios).watch(),
          builder: (context, scenarioSnap) {
            if (!scenarioSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final scenarios = scenarioSnap.data!;
            if (scenarios.isEmpty) {
              return const Center(child: Text('No scenarios yet.'));
            }

            return StreamBuilder<List<UserProgressRow>>(
              stream: db.select(db.userProgress).watch(),
              builder: (context, progressSnap) {
                final progressById = <String, UserProgressRow>{
                  for (final p in progressSnap.data ?? const <UserProgressRow>[])
                    p.scenarioId: p,
                };
                final completed = progressById.values
                    .where((p) => p.status == 'completed')
                    .length;

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                      KSpace.lg, KSpace.sm, KSpace.lg, KSpace.xxl),
                  itemCount: scenarios.length + 1,
                  separatorBuilder: (_, _x) =>
                      const SizedBox(height: KSpace.md),
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return _Header(
                        completed: completed,
                        total: scenarios.length,
                        theme: theme,
                      );
                    }
                    final scenario = scenarios[i - 1];
                    return _ScenarioCard(
                      scenario: scenario,
                      progress: progressById[scenario.id],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int completed;
  final int total;
  final ThemeData theme;
  const _Header({
    required this.completed,
    required this.total,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final headline = completed == 0
        ? 'A scene with you 🌸'
        : completed >= total
            ? 'Run, Korea, run — you did it!'
            : 'One more scene, one more day';
    final sub = completed == 0
        ? 'Pick a Korean moment and play it through, one line at a time.'
        : '$completed of $total scenes lived through.';

    return Padding(
      padding: const EdgeInsets.only(top: KSpace.md, bottom: KSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headline,
            style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: theme.textTheme.bodyMedium?.copyWith(
                color: KColors.inkSoft, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final Scenario scenario;
  final UserProgressRow? progress;
  const _ScenarioCard({required this.scenario, required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visual = ScenarioVisual.forId(scenario.id);
    final status = progress?.status ?? 'not_started';
    final isInProgress = status == 'in_progress';
    final isComplete = status == 'completed';

    final borderColor = isInProgress
        ? KColors.softPink
        : theme.colorScheme.outlineVariant;
    final borderWidth = isInProgress ? 2.0 : 1.0;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  DialoguePlayerScreen(scenarioId: scenario.id),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          padding: const EdgeInsets.fromLTRB(
              KSpace.lg, KSpace.lg, KSpace.lg, KSpace.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Illustration tile
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: visual.tileColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text(
                  visual.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(width: KSpace.lg),

              // Text block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      scenario.titleEn,
                      style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scenario.settingEn,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: KColors.inkSoft, fontSize: 14, height: 1.35),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: KSpace.sm),
                    Row(
                      children: [
                        _DifficultyStars(level: scenario.difficulty),
                        const SizedBox(width: KSpace.sm),
                        Text(
                          '·   ${scenario.turnCount} turns',
                          style: theme.textTheme.labelLarge?.copyWith(
                              color: KColors.inkFaint, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: KSpace.sm),
              _StatusBadge(
                  status: status,
                  inProgress: isInProgress,
                  complete: isComplete),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyStars extends StatelessWidget {
  final int level;
  const _DifficultyStars({required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final filled = i < level;
        return Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 16,
          color: filled ? KColors.buttercream : KColors.inkFaint,
        );
      }),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final bool inProgress;
  final bool complete;
  const _StatusBadge({
    required this.status,
    required this.inProgress,
    required this.complete,
  });

  @override
  Widget build(BuildContext context) {
    if (complete) {
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: KColors.sage,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.favorite_rounded,
            color: Colors.white, size: 18),
      );
    }
    if (inProgress) {
      return const Icon(Icons.arrow_forward_rounded,
          size: 24, color: KColors.softPink);
    }
    return Icon(Icons.arrow_forward_rounded,
        size: 22, color: KColors.inkFaint);
  }
}
