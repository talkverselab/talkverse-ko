// 메인 탭·두 화면 확인용 스크린샷 흐름. 실행: python3 tools/pane_shots.py <UDID> <출력폴더> integration_test/main_shell_test.dart
// 넘침은 로그에 "overflowed by" 로 보인다 — 0 이어야 한다.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:k_universe/app.dart';
import 'package:k_universe/core/l10n.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/db/seed_loader.dart';
import 'package:k_universe/review/review_service.dart';
import 'package:k_universe/services/content_sync.dart';
import 'package:k_universe/services/learner_prefs.dart';
import 'package:k_universe/state/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  Future<void> wait(WidgetTester t, int ms) async {
    final end = DateTime.now().add(Duration(milliseconds: ms));
    while (DateTime.now().isBefore(end)) {
      await t.pump(const Duration(milliseconds: 100));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> shot(WidgetTester t, String name) async {
    await wait(t, 2000);
    // ignore: avoid_print
    print('SHOT:$name');
    await wait(t, 2500);
  }

  testWidgets('main shell', timeout: const Timeout(Duration(minutes: 10)), (t) async {
    final db = AppDatabase();
    await SeedLoader(db).ensureSeeded();
    await AppLangPrefs.set(AppLang.ko);
    await LearnerPrefs.load();
    await ReviewService.instance.load();
    await ContentSync.instance.init(large: true).timeout(const Duration(seconds: 20), onTimeout: () => false);
    await t.pumpWidget(MultiProvider(
      providers: [Provider<AppDatabase>.value(value: db), ChangeNotifierProvider(create: (_) => AppState())],
      child: const KUniverseApp(),
    ));
    await wait(t, 2500);
    await shot(t, '01_learn');

    await t.tap(find.text('복습').last);
    await shot(t, '02_review');
    await t.tap(find.text('시작').first);
    await wait(t, 1500);
    await shot(t, '03_review_session');
    await t.tap(find.text('정답 보기').first);
    await shot(t, '04_review_answer');
    await t.pageBack();
    await wait(t, 1000);

    await t.tap(find.text('문장 카드'));
    await wait(t, 1500);
    await shot(t, '05_sentence_card');
    await t.tap(find.text('탭해서 확인'));
    await shot(t, '06_sentence_card_back');
    await t.pageBack();
    await wait(t, 1000);

    await t.tap(find.text('탐색').last);
    await shot(t, '07_explore');
    await t.tap(find.text('단어 빈도'));
    await shot(t, '08_vocab');
    if (find.byType(BackButton).evaluate().isNotEmpty) {
      await t.pageBack();
      await wait(t, 800);
    }

    await t.tap(find.text('나').last);
    await shot(t, '09_me');

    await t.tap(find.text('배우기').last);
    await wait(t, 800);
    await t.tap(find.text('주제별 회화 R0~R4').first);
    await shot(t, '10_series');
    await t.tap(find.textContaining('EP.1').first);
    await wait(t, 2500);
    await shot(t, '11_episode');
    await t.tap(find.byIcon(Icons.style_outlined).first);
    await wait(t, 1500);
    await shot(t, '12_episode_card');
  });
}
