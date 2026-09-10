import 'package:flutter/material.dart';

import '../../screens/update_screen.dart';
import 'package:k_universe/ui/colors.dart';
import 'package:k_universe/ui/mascot.dart';
import 'package:k_universe/ui/spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              KSpace.lg, KSpace.md, KSpace.lg, KSpace.xxxl),
          children: [
            const UpdateEntryTile(),
            _ProfileHeader(),
            const SizedBox(height: KSpace.xl),
            _SectionLabel(label: 'Learning'),
            _SettingRow(
              emoji: '🎧',
              tile: KColors.tileMint,
              title: 'Voice speed',
              subtitle: 'Korean TTS reads at a natural pace',
              trailing: const Text('Normal',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            _SettingRow(
              emoji: '💬',
              tile: KColors.tileBlush,
              title: 'Reveal English by default',
              subtitle: 'Show English gloss without tapping',
              trailing: Switch.adaptive(value: false, onChanged: null),
            ),
            const SizedBox(height: KSpace.lg),
            _SectionLabel(label: 'About'),
            _SettingRow(
              emoji: '🌸',
              tile: KColors.tileLavender,
              title: 'K-Universe',
              subtitle: 'Version 0.1 · MVP',
              trailing: null,
            ),
            _SettingRow(
              emoji: '✉️',
              tile: KColors.tileCream,
              title: 'Send feedback',
              subtitle: 'Tell us what to add next',
              trailing: Icon(Icons.arrow_forward_rounded,
                  size: 18, color: KColors.inkFaint),
            ),
            const SizedBox(height: KSpace.xxl),
            Center(
              child: Text(
                'Made with 🌸 for Korean learners',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: KColors.inkFaint, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(KSpace.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          const Mascot(MascotPose.normal, size: 88),
          const SizedBox(width: KSpace.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi, learner',
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800, fontSize: 19)),
                const SizedBox(height: 2),
                Text(
                  'Studying Korean since today 🌱',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: KColors.inkSoft, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: KSpace.md, bottom: KSpace.sm),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w800,
          color: KColors.inkFaint,
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String emoji;
  final Color tile;
  final String title;
  final String subtitle;
  final Widget? trailing;
  const _SettingRow({
    required this.emoji,
    required this.tile,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: KSpace.sm),
      child: Container(
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
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: tile,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: KSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  Text(subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: KColors.inkSoft,
                          fontSize: 12,
                          height: 1.3)),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
