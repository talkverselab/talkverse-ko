import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../services/learner_prefs.dart';
import 'drama_theme.dart';

/// 로마자(읽기 보조) 표시/미표시 버튼(앱바용) — 전역 `LearnerPrefs.roman` 하나를 바꾼다. 기본 미표시.
/// 표시로 켤 때는 「힘들어도 로마자를 보지 않고 익혀보세요」를 한 번 알린다(사용자 지시 2026-11-07, 일본어앱 후리가나 토글과 같음).
class RomanToggleAction extends StatelessWidget {
  const RomanToggleAction({super.key});

  static Future<void> toggle(BuildContext context) async {
    final on = !LearnerPrefs.roman.value;
    await LearnerPrefs.setRoman(on);
    if (on && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(tr('힘들어도 로마자를 보지 않고 익혀보세요')), duration: const Duration(seconds: 3), backgroundColor: DramaColors.ink));
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;
    return ValueListenableBuilder<bool>(
      valueListenable: LearnerPrefs.roman,
      builder: (context, on, _) {
        final color = on ? DramaColors.jade : base.withValues(alpha: 0.45);
        return IconButton(
          tooltip: on ? tr('로마자 숨기기') : tr('로마자 표시'),
          onPressed: () => toggle(context),
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(border: Border.all(color: color, width: 1.2), borderRadius: BorderRadius.circular(6)),
            child: Text('Aa', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color, decoration: on ? null : TextDecoration.lineThrough)),
          ),
        );
      },
    );
  }
}
