import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

import '../../core/pane.dart';
import '../../screens/about_screen.dart';
import 'package:k_universe/ui/colors.dart';
import 'package:k_universe/ui/spacing.dart';
import '../../core/l10n.dart';
import '../../drama/learner_setup_dialog.dart';
import '../../drama/roman_toggle.dart';
import '../../services/learner_prefs.dart';
import 'account_section.dart';

class ProfileScreen extends StatelessWidget {
  final bool embedded; // 「나」 탭 안에 넣을 때 — 앱바·스크롤 없이 내용만
  const ProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = <Widget>[
      _SectionLabel(label: tr('계정')),
      const AccountSection(),
      const SizedBox(height: KSpace.lg),
      _SectionLabel(label: tr('학습자 프로필')),
      const _LearnerRow(),
      const SizedBox(height: KSpace.lg),
      _SectionLabel(label: tr('설정')),
      InkWell(
        onTap: AppLangPrefs.next,
        child: _SettingRow(
          emoji: '🌐',
          tile: KColors.tileLavender,
          title: tr('Language / 언어'),
          subtitle: 'Tap to switch: ${AppLangPrefs.peekNext().label}',
          trailing: Text(AppLangPrefs.lang.value.label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ),
      ValueListenableBuilder<bool>(
        valueListenable: LearnerPrefs.roman,
        builder: (context, on, _) => InkWell(
          onTap: () => RomanToggleAction.toggle(context),
          child: _SettingRow(
            emoji: 'Aa',
            tile: KColors.tileMint,
            title: tr('로마자(읽기 보조)'),
            subtitle: tr('기본 미표시 · 회화·카드·단어에 함께 적용'),
            trailing: Switch.adaptive(value: on, onChanged: (_) => RomanToggleAction.toggle(context)),
          ),
        ),
      ),
      const SizedBox(height: KSpace.lg),
      _SectionLabel(label: tr('정보')),
      InkWell(
        onTap: () => openPane(context, (_) => const AboutScreen()),
        child: _SettingRow(
          emoji: 'ⓘ',
          tile: KColors.tileMint,
          title: tr('앱 소개'),
          subtitle: tr('절벽 구간 · 산출 방식'),
          trailing: Icon(Icons.arrow_forward_rounded, size: 18, color: KColors.inkFaint),
        ),
      ),
      FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, s) => _SettingRow(
          emoji: '🌸',
          tile: KColors.tileLavender,
          title: 'Talkverse Korean',
          subtitle: s.data == null ? '' : '${s.data!.version} (${s.data!.buildNumber}) · © Talkverse',
          trailing: null,
        ),
      ),
    ];
    if (embedded) return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: items);
    return Scaffold(
      appBar: AppBar(title: Text(tr('프로필'))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              KSpace.lg, KSpace.md, KSpace.lg, KSpace.xxxl),
          children: items,
        ),
      ),
    );
  }
}

/// 회화 속 「나」 — 이름·성별(장면 컷·음성 판).
class _LearnerRow extends StatelessWidget {
  const _LearnerRow();
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
        valueListenable: LearnerPrefs.name,
        builder: (context, name, _) => ValueListenableBuilder<String>(
          valueListenable: LearnerPrefs.gender,
          builder: (context, gender, _) => InkWell(
            onTap: () => editLearner(context),
            child: _SettingRow(
              emoji: '🙂',
              tile: KColors.tileBlush,
              title: tr('회화 속 「나」'),
              subtitle: '${name.isEmpty ? tr('나') : name} · ${tr(gender == 'female' ? '여' : '남')}',
              trailing: Icon(Icons.arrow_forward_rounded, size: 18, color: KColors.inkFaint),
            ),
          ),
        ),
      );
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
