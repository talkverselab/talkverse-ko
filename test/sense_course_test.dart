import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k_universe/features/sense/sense_course_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 언어감각 과정(일본어앱 옮김 2026-11-18) — 목록·암기 회차·참고.
Future<void> settle(WidgetTester t, Finder until) async {
  for (var i = 0; i < 100 && until.evaluate().isEmpty; i++) {
    await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await t.pump();
  }
  await t.pump(const Duration(milliseconds: 300));
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final w in const [320.0, 900.0]) {
    testWidgets('목록 폭 $w — 급마다 암기 1회 + 참고, 넘침 없음', (t) async {
      t.view.physicalSize = Size(w, 6000);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(const MaterialApp(home: SenseCourseScreen()));
      await settle(t, find.byKey(const ValueKey('sense-L1-talk')));
      expect(t.takeException(), isNull);
      for (var n = 1; n <= 10; n++) {
        expect(find.byKey(ValueKey('sense-L$n-talk')), findsOneWidget);
        expect(find.byKey(ValueKey('sense-L$n-ref')), findsOneWidget);
      }
      expect(find.text('0/10회 마침'), findsOneWidget);
    });
  }

  testWidgets('암기 회차 — 영상 없으면 칸 숨김, 표시 기호가 글자에 안 남음, 마침 → 다음 급', (t) async {
    t.view.physicalSize = const Size(320, 4000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(const MaterialApp(home: SenseLessonScreen(index: 0)));
    await settle(t, find.byKey(const ValueKey('sense-finish')));
    expect(t.takeException(), isNull);
    expect(find.byKey(const ValueKey('memorize-video')), findsNothing); // 1회차 영상 주소 비어 있음
    expect(find.textContaining('{', findRichText: true), findsNothing);
    expect(plainMarked('빵{을|1} 샀어'), '빵을 샀어');
    await t.tap(find.byKey(const ValueKey('sense-finish')));
    await t.pump(const Duration(milliseconds: 500));
    await t.pump(const Duration(milliseconds: 500));
    expect(await SenseCourse.done(), contains('L1-talk'));
  });

  testWidgets('참고 회차 — 넘침 없음, 닫기는 기록 안 함', (t) async {
    t.view.physicalSize = const Size(320, 12000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(const MaterialApp(home: SenseLessonScreen(index: 1)));
    await settle(t, find.byKey(const ValueKey('sense-finish')));
    expect(t.takeException(), isNull);
    await t.tap(find.byKey(const ValueKey('sense-finish')));
    await t.pump();
    expect(await SenseCourse.done(), isEmpty);
  });
}
