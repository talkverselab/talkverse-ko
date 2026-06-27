import 'package:flutter/material.dart';
import 'package:k_universe/features/dialogue/scenario_list_screen.dart';
import 'package:k_universe/features/particles/particles_screen.dart';
import 'package:k_universe/features/vocabulary/vocabulary_screen.dart';
import 'package:k_universe/ui/colors.dart';
import 'package:k_universe/ui/spacing.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              KSpace.lg, KSpace.sm, KSpace.lg, KSpace.xxxl),
          children: [
            Text(
              'Choose your path',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: KColors.inkSoft, fontSize: 15),
            ),
            const SizedBox(height: KSpace.lg),
            _BigLearnTile(
              emoji: '💬',
              tile: KColors.tileBlush,
              titleEn: 'Conversation',
              titleKo: '회화',
              description:
                  'Play through eight Korean scenes line by line.',
              destination: (_) => const ScenarioListScreen(),
            ),
            const SizedBox(height: KSpace.md),
            _BigLearnTile(
              emoji: '🔤',
              tile: KColors.tileLavender,
              titleEn: 'Grammar',
              titleKo: '문법',
              description:
                  'The 19 particles and endings that build 63 % of Korean speech.',
              destination: (_) => const ParticlesScreen(),
            ),
            const SizedBox(height: KSpace.md),
            _BigLearnTile(
              emoji: '📚',
              tile: KColors.tileCream,
              titleEn: 'Vocabulary',
              titleKo: '어휘',
              description:
                  'The top 100 most-used Korean words, ranked by frequency.',
              destination: (_) => const VocabularyScreen(),
            ),
            const SizedBox(height: KSpace.md),
            _BigLearnTile(
              emoji: '🎧',
              tile: KColors.tileMint,
              titleEn: 'Pronunciation',
              titleKo: '발음',
              description: 'Speak along — coming soon.',
              destination: null,
            ),
            const SizedBox(height: KSpace.md),
            _BigLearnTile(
              emoji: '🎬',
              tile: KColors.tileSage,
              titleEn: 'Culture',
              titleKo: '문화',
              description: 'K-drama scenes annotated — coming soon.',
              destination: null,
            ),
          ],
        ),
      ),
    );
  }
}

class _BigLearnTile extends StatelessWidget {
  final String emoji;
  final Color tile;
  final String titleEn;
  final String titleKo;
  final String description;
  final WidgetBuilder? destination;
  const _BigLearnTile({
    required this.emoji,
    required this.tile,
    required this.titleEn,
    required this.titleKo,
    required this.description,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = destination == null;
    return Opacity(
      opacity: disabled ? 0.55 : 1,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: disabled
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$titleEn coming soon'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(milliseconds: 1500),
                    ),
                  )
              : () => Navigator.of(context).push(
                    MaterialPageRoute(builder: destination!),
                  ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: theme.colorScheme.outlineVariant, width: 1),
            ),
            padding: const EdgeInsets.all(KSpace.lg),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: tile,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji,
                      style: const TextStyle(fontSize: 30)),
                ),
                const SizedBox(width: KSpace.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(titleEn,
                              style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(titleKo,
                              style: theme.textTheme.labelLarge?.copyWith(
                                  color: KColors.inkFaint, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: KColors.inkSoft,
                              fontSize: 13,
                              height: 1.35)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_rounded,
                    size: 22, color: KColors.inkFaint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
