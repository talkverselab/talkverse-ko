import 'package:flutter/material.dart';
import 'package:k_universe/features/home_shell.dart';
import 'package:k_universe/ui/theme.dart';
import 'core/l10n.dart';

class KUniverseApp extends StatelessWidget {
  const KUniverseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 표시 언어가 바뀌면 key 가 바뀌어 앱 전체가 새로 그려진다 (홈으로 돌아감).
    return ValueListenableBuilder<AppLang>(
      valueListenable: AppLangPrefs.lang,
      builder: (context, lang, _) => MaterialApp(
        key: ValueKey(lang),
        title: 'Korean-Universe',
        debugShowCheckedModeBanner: false,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        home: const HomeShell(),
        // 아이폰 Dynamic Type·갤럭시 글자 크기 설정이 커도 타일이 깨지지 않게 1.2배까지만
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          return MediaQuery(
            data: mq.copyWith(
              textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
