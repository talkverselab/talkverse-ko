import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/features/dialogue/dialogue_player_screen.dart';
import 'package:k_universe/features/dialogue/scenario_list_screen.dart';
import 'package:k_universe/features/particles/particles_screen.dart';
import 'package:k_universe/features/vocabulary/vocabulary_screen.dart';
import 'package:k_universe/ui/colors.dart';
import 'package:k_universe/ui/mascot.dart';
import 'package:k_universe/ui/spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final theme = Theme.of(context);

    return Scaffold(
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
                final progressById = {for (final p in progress) p.scenarioId: p};
                final completed =
                    progress.where((p) => p.status == 'completed').length;

                // Pick the most recent in_progress, else the first not_started
                Scenario? today;
                UserProgressRow? todayProgress;
                for (final s in scenarios) {
                  final p = progressById[s.id];
                  if (p?.status == 'in_progress') {
                    today = s;
                    todayProgress = p;
                    break;
                  }
                }
                today ??= scenarios.firstWhere(
                  (s) => progressById[s.id] == null,
                  orElse: () => scenarios.isNotEmpty
                      ? scenarios.first
                      : _emptyScenario,
                );
                todayProgress ??= progressById[today.id];

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                      KSpace.lg, KSpace.md, KSpace.lg, KSpace.xxxl),
                  children: [
                    _GreetingRow(completedCount: completed),
                    const SizedBox(height: KSpace.lg),
                    if (today.id.isNotEmpty)
                      _TodaysSceneCard(
                          scenario: today, progress: todayProgress),
                    const SizedBox(height: KSpace.xl),
                    Text('Main Menu',
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface)),
                    const SizedBox(height: KSpace.md),
                    _MainMenuGrid(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  static final _emptyScenario = Scenario(
    id: '',
    titleEn: '',
    settingEn: '',
    summaryEn: '',
    difficulty: 1,
    turnCount: 0,
    source: '',
    sourceRef: null,
    createdAt: DateTime.now(),
  );
}

class _GreetingRow extends StatelessWidget {
  final int completedCount;
  const _GreetingRow({required this.completedCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi there! 🌸',
                style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800, fontSize: 26),
              ),
              const SizedBox(height: 2),
              Text(
                'Ready for today\'s Korean scene?',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: KColors.inkSoft, fontSize: 15),
              ),
            ],
          ),
        ),
        _StreakChip(count: completedCount),
        const SizedBox(width: KSpace.sm),
        _AvatarPlaceholder(),
      ],
    );
  }
}

class _StreakChip extends StatelessWidget {
  final int count;
  const _StreakChip({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: KColors.tileGold,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF8B5A0F),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Mascot(MascotPose.happy, size: 48);
  }
}

class _TodaysSceneCard extends StatelessWidget {
  final Scenario scenario;
  final UserProgressRow? progress;
  const _TodaysSceneCard({required this.scenario, required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visual = ScenarioVisual.forId(scenario.id);
    final pct = progress == null
        ? 0.0
        : (progress!.lastTurnOrder / scenario.turnCount).clamp(0.0, 1.0);
    final inProgress = progress?.status == 'in_progress';

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  DialoguePlayerScreen(scenarioId: scenario.id),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(
              KSpace.xl, KSpace.xl, KSpace.xl, KSpace.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                KColors.softPink.withValues(alpha: 0.95),
                KColors.lilac.withValues(alpha: 0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      inProgress ? 'Continue' : 'Today\'s Scene',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(visual.emoji,
                      style: const TextStyle(fontSize: 40)),
                ],
              ),
              const SizedBox(height: KSpace.md),
              Text(
                scenario.titleEn,
                style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    height: 1.2),
              ),
              const SizedBox(height: 4),
              Text(
                scenario.settingEn,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: KSpace.lg),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: pct == 0.0 ? null : pct,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                progress == null
                    ? 'New scene · ${scenario.turnCount} lines'
                    : '${progress!.lastTurnOrder} / ${scenario.turnCount}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainMenuGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      _MenuItem(
        emoji: '💬',
        labelEn: 'Conversation',
        labelKo: '회화',
        tile: KColors.tileBlush,
        builder: (_) => const ScenarioListScreen(),
      ),
      _MenuItem(
        emoji: '🔤',
        labelEn: 'Grammar',
        labelKo: '문법',
        tile: KColors.tileLavender,
        builder: (_) => const ParticlesScreen(),
      ),
      _MenuItem(
        emoji: '📚',
        labelEn: 'Vocabulary',
        labelKo: '어휘',
        tile: KColors.tileCream,
        builder: (_) => const VocabularyScreen(),
      ),
      _MenuItem(
        emoji: '🎧',
        labelEn: 'Pronunciation',
        labelKo: '발음',
        tile: KColors.tileMint,
        builder: null,
      ),
      _MenuItem(
        emoji: '🎬',
        labelEn: 'Culture',
        labelKo: '문화',
        tile: KColors.tileSage,
        builder: null,
      ),
      _MenuItem(
        emoji: '🔁',
        labelEn: 'Review',
        labelKo: '복습',
        tile: KColors.tileLilac,
        builder: null,
      ),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: KSpace.md,
      mainAxisSpacing: KSpace.md,
      childAspectRatio: 0.95,
      children: items.map((it) => _MenuCard(item: it)).toList(),
    );
  }
}

class _MenuItem {
  final String emoji;
  final String labelEn;
  final String labelKo;
  final Color tile;
  final WidgetBuilder? builder;
  _MenuItem({
    required this.emoji,
    required this.labelEn,
    required this.labelKo,
    required this.tile,
    required this.builder,
  });
}

class _MenuCard extends StatelessWidget {
  final _MenuItem item;
  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = item.builder == null;
    return Opacity(
      opacity: disabled ? 0.55 : 1,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: disabled
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.labelEn} coming soon'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(milliseconds: 1500),
                    ),
                  )
              : () => Navigator.of(context).push(
                    MaterialPageRoute(builder: item.builder!),
                  ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                  color: theme.colorScheme.outlineVariant, width: 1),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: KSpace.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item.tile,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(item.emoji,
                      style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(height: KSpace.sm),
                Text(
                  item.labelEn,
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 13, fontWeight: FontWeight.w800),
                ),
                Text(
                  item.labelKo,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: KColors.inkSoft, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
