// 폰·아이패드 크기에서 메인 탭과 학습 화면을 그려 넘침·예외가 없는지 본다(시뮬레이터 없이). SHOTS=<폴더> 를 주면 PNG 도 남긴다.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k_universe/app.dart';
import 'package:k_universe/core/l10n.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/db/seed_loader.dart';
import 'package:k_universe/drama/card_screen.dart';
import 'package:k_universe/features/hangul/hangul_chart_screen.dart';
import 'package:k_universe/drama/drama_service.dart';
import 'package:k_universe/drama/episode_screen.dart';
import 'package:k_universe/review/review_service.dart';
import 'package:k_universe/screens/about_screen.dart';
import 'package:k_universe/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

NavigatorState nav0(WidgetTester t) => t.state<NavigatorState>(find.byType(Navigator).first);

const _sizes = {'phone': Size(390, 844), 'fold': Size(740, 900), 'ipad': Size(1180, 820)};

Future<void> _shot(WidgetTester t, String name) async {
  final dir = Platform.environment['SHOTS'];
  if (dir == null) return;
  await t.runAsync(() async {
    final b = t.renderObject<RenderRepaintBoundary>(find.byKey(const ValueKey('shot')));
    final img = await b.toImage(pixelRatio: 1.5);
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
    File('$dir/$name.png').writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}

Future<void> _settle(WidgetTester t, [int n = 12]) async {
  for (var i = 0; i < n; i++) {
    await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await t.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final dir = Directory.systemTemp.createTempSync('kotest');
    const pp = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(pp, (_) async => dir.path);
    SharedPreferences.setMockInitialValues({});
    final font = File('/System/Library/Fonts/Supplemental/Arial Unicode.ttf');
    if (font.existsSync()) {
      final bytes = font.readAsBytesSync();
      for (final fam in ['Roboto', 'Pretendard', 'NotoSansKR', '']) {
        await (FontLoader(fam.isEmpty ? 'sans' : fam)..addFont(Future.value(ByteData.sublistView(bytes)))).load();
      }
    }
  });

  for (final e in _sizes.entries) {
    testWidgets('화면 ${e.key}', (t) async {
      t.view.physicalSize = e.value;
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await AppLangPrefs.set(AppLang.ko);
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(() => t.runAsync(db.close));
      await t.runAsync(() async {
        await SeedLoader(db).ensureSeeded();
        await ReviewService.instance.load();
        await DramaService.instance.ensureLoaded();
      });
      await t.pumpWidget(RepaintBoundary(
        key: const ValueKey('shot'),
        child: MultiProvider(
          providers: [Provider<AppDatabase>.value(value: db), ChangeNotifierProvider(create: (_) => AppState())],
          child: const KUniverseApp(),
        ),
      ));
      await _settle(t, 25);
      await _shot(t, '${e.key}_1_learn');

      Future<void> tap(String s) async {
        await t.tap(find.text(s).last);
        await _settle(t);
      }

      await tap('복습');
      expect(find.textContaining('오늘 할 카드'), findsOneWidget);
      await _shot(t, '${e.key}_2_review');
      await tap('시작');
      expect(find.text('정답 보기'), findsOneWidget);
      await _shot(t, '${e.key}_3_session');
      await tap('정답 보기');
      await _shot(t, '${e.key}_4_answer');
      await tap('맞음');
      t.state<NavigatorState>(find.byType(Navigator).first).pop();
      await _settle(t);

      await tap('탐색');
      await _shot(t, '${e.key}_5_explore');
      await tap('프로필');
      await _settle(t, 15);
      await _shot(t, '${e.key}_6_me');
      await tap('탐색');
      await tap('절벽 단어 R1~R5');
      var tries = 0;
      while (find.textContaining('1단원', skipOffstage: false).evaluate().isEmpty && tries++ < 30) {
        await _settle(t, 2);
      }
      expect(find.textContaining('1단원', skipOffstage: false), findsWidgets);
      await _shot(t, '${e.key}_6b_vocab');
      // 회화 단어 목록(에셋)은 두 번째 시험부터 flutter_test 가 돌려주지 않는다 — 있을 때만 「회화」 구간을 확인
      final convBtn = find.textContaining(RegExp(r'^회화 단어 포함 \(\+\d+\)$'));
      final hasConv = !find.text('회화 단어 포함 (+0)').evaluate().isNotEmpty;
      await t.tap(convBtn);
      await _settle(t);
      if (hasConv) {
        await t.drag(find.widgetWithText(ChoiceChip, 'R3'), const Offset(-300, 0));
        await _settle(t, 4);
        await t.tap(find.widgetWithText(ChoiceChip, '회화'));
        await _settle(t, 10);
        expect(find.textContaining('회화 · 1-20', skipOffstage: false), findsOneWidget);
      }
      await _shot(t, '${e.key}_6c_vocab_conv');
      t.state<NavigatorState>(find.byType(Navigator).first).maybePop();
      await _settle(t);
      nav0(t).push(MaterialPageRoute(builder: (_) => const AboutScreen()));
      await _settle(t, 10);
      await _shot(t, '${e.key}_6d_about');
      nav0(t).pop();
      await _settle(t);
      await tap('배우기');
      await tap('한글과 발음');
      await _settle(t, 8);
      await _shot(t, '${e.key}_h1_hangul');
      await t.tap(find.text('ㄱ').first);
      await _settle(t, 15);
      await _shot(t, '${e.key}_h2_sheet');
      t.state<NavigatorState>(find.ancestor(of: find.byType(DraggableScrollableSheet), matching: find.byType(Navigator)).first).pop();
      await _settle(t);
      await t.tap(find.text('모음 21'));
      await _settle(t);
      await t.tap(find.text('ㅡ').first);
      await _settle(t, 15);
      await _shot(t, '${e.key}_h3_vowel');
      t.state<NavigatorState>(find.ancestor(of: find.byType(DraggableScrollableSheet), matching: find.byType(Navigator)).first).pop();
      await _settle(t);
      await t.tap(find.text('음절표'));
      await _settle(t, 8);
      await _shot(t, '${e.key}_h4_syll');
      t.state<NavigatorState>(find.ancestor(of: find.byType(HangulChartScreen), matching: find.byType(Navigator)).first).maybePop();
      await _settle(t);

      final nav = t.state<NavigatorState>(find.byType(Navigator).first);
      final ep = DramaService.instance.list('R1').first;
      nav.push(MaterialPageRoute(builder: (_) => PictureCardScreen.episode(ep)));
      await _settle(t);
      await _shot(t, '${e.key}_7_card');
      await t.tap(find.text('탭해서 확인'));
      await _settle(t);
      await _shot(t, '${e.key}_8_card_back');
      for (var i = 0; i < ep.turns.length; i++) {
        await t.tap(find.text('맞았어요'));
        await _settle(t, 3);
      }
      expect(find.textContaining('끝! 맞음'), findsOneWidget);
      nav.pop();
      await _settle(t);

      nav.push(MaterialPageRoute(builder: (_) => EpisodeScreen(ep: ep)));
      await _settle(t);
      if (find.text('나중에').evaluate().isNotEmpty) await tap('나중에');
      await _shot(t, '${e.key}_9_episode');
      nav.pop();
      await _settle(t);
    });
  }
}
