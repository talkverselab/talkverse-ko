// 스토어 스크린샷(STORE_DIFFERENTIATION: 첫 두 장 = 한국어 고유 화면). 실행: python3 tools/pane_shots.py <UDID> <폴더> integration_test/store_shots_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:k_universe/app.dart';
import 'package:k_universe/core/l10n.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/db/seed_loader.dart';
import 'package:k_universe/drama/card_screen.dart';
import 'package:k_universe/drama/drama_service.dart';
import 'package:k_universe/drama/episode_screen.dart';
import 'package:k_universe/features/hangul/hangul_chart_screen.dart';
import 'package:k_universe/features/hangul/hangul_phonetics.dart';
import 'package:k_universe/features/hangul/hangul_sound_sheet.dart';
import 'package:k_universe/features/particles/particles_screen.dart';
import 'package:k_universe/features/vocabulary/vocabulary_screen.dart';
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
    await wait(t, 2500);
    // ignore: avoid_print
    print('SHOT:$name');
    await wait(t, 2500);
  }

  testWidgets('store shots', timeout: const Timeout(Duration(minutes: 15)), (t) async {
    final db = AppDatabase();
    await SeedLoader(db).ensureSeeded();
    await AppLangPrefs.set(AppLang.en);
    await LearnerPrefs.load();
    await LearnerPrefs.setName('Alex');
    await ReviewService.instance.load();
    await ContentSync.instance.init(large: true).timeout(const Duration(seconds: 30), onTimeout: () => false);
    await DramaService.instance.ensureLoaded();
    await t.pumpWidget(MultiProvider(
      providers: [Provider<AppDatabase>.value(value: db), ChangeNotifierProvider(create: (_) => AppState())],
      child: const KUniverseApp(),
    ));
    await wait(t, 3000);
    final nav = t.state<NavigatorState>(find.byType(Navigator).first);
    BuildContext ctx() => t.element(find.byType(Scaffold).last);

    // 1. 회화 장면(점토 컷 + 스크립트)
    final ep = DramaService.instance.byId('r1_love_a1') ?? DramaService.instance.list('R1').first;
    nav.push(MaterialPageRoute(builder: (_) => EpisodeScreen(ep: ep)));
    await wait(t, 6000);
    await shot(t, '01_dialogue');
    nav.pop();
    await wait(t, 1000);

    // 2. 한글과 발음 + 발음 시트
    nav.push(MaterialPageRoute(builder: (_) => const HangulChartScreen()));
    await wait(t, 2000);
    await shot(t, '02_hangul');
    showHangulSoundSheet(ctx(), vowels.firstWhere((j) => j.ch == 'ㅡ'));
    await wait(t, 2000);
    await shot(t, '03_hangul_sound');
    nav.pop();
    await wait(t, 600);
    nav.pop();
    await wait(t, 1000);

    // 4. 조사·어미
    nav.push(MaterialPageRoute(builder: (_) => const ParticlesScreen()));
    await shot(t, '04_particles');
    nav.pop();
    await wait(t, 800);

    // 5. 그림 카드
    nav.push(MaterialPageRoute(builder: (_) => PictureCardScreen.episode(ep)));
    await wait(t, 2000);
    await t.tap(find.textContaining('Tap').first, warnIfMissed: false);
    await shot(t, '05_card');
    nav.pop();
    await wait(t, 800);

    // 6. 절벽 단어
    nav.push(MaterialPageRoute(builder: (_) => const VocabularyScreen()));
    await wait(t, 3000);
    await shot(t, '06_words');
    nav.pop();
    await wait(t, 800);

    // 7. 홈
    await shot(t, '07_home');
  });
}
