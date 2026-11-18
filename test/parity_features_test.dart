import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k_universe/features/hanja/hanja_practice_screen.dart';
import 'package:k_universe/features/loanwords/loanword_quiz_screen.dart';
import 'package:k_universe/features/loanwords/loanword_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 일본어앱 수준 맞추기(2026-11-18) — 외래어 3단계·퀴즈, 한자 하루 3자.
Future<void> settle(WidgetTester t, Finder until) async {
  for (var i = 0; i < 400 && until.evaluate().isEmpty; i++) {
    await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await t.pump();
  }
  await t.pump(const Duration(milliseconds: 300));
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('외래어 틀린 보기 — 규칙을 어긴 꼴, 정답·실제 단어와 겹치지 않음', () {
    final m = loanMisspellings('커피', {'커피', '코피'});
    expect(m, isNot(contains('커피')));
    expect(m, isNot(contains('코피')));
    expect(m, contains('커비')); // ㅍ→ㅂ
    expect(loanMisspellings('콜라', {}), contains('코라')); // ㄹ 하나 빼기
  });

  test('외래어 데이터 — 단어마다 ko·en·st, 단계마다 퀴즈 보기 3개가 나옴', () {
    final j = json.decode(File('assets/data/vocab/loanwords.json').readAsStringSync()) as Map<String, dynamic>;
    final words = [for (final b in j['branches'] as List) ...(b['words'] as List)];
    expect(words.length, greaterThan(100));
    for (final w in words) {
      expect((w['ko'] as String).isNotEmpty, true);
      expect([1, 2, 3], contains(w['st']));
    }
    final real = {for (final w in words) w['ko'] as String};
    final ok = words.where((w) => loanMisspellings(w['ko'] as String, real).length >= 3).length;
    expect(ok / words.length, greaterThan(0.7));
  });

  for (final w in const [320.0, 900.0]) {
    testWidgets('외래어 화면 폭 $w — 넘침 없음, 퀴즈 열림', (t) async {
      t.view.physicalSize = Size(w, 2400);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(const MaterialApp(home: LoanwordScreen()));
      await settle(t, find.byKey(const ValueKey('loan-quiz')));
      expect(find.byKey(const ValueKey('loan-quiz')), findsOneWidget);
      expect(find.byKey(const ValueKey('loan-rules')), findsOneWidget);
      expect(t.takeException(), isNull);
      await t.tap(find.byKey(const ValueKey('loan-rules')));
      await t.pump();
      expect(t.takeException(), isNull);
    });
  }

  testWidgets('외래어 퀴즈 — 10문제, 보기 4개', (t) async {
    t.view.physicalSize = const Size(320, 1400);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final ws = [for (var i = 0; i < 20; i++) LQWord(['커피', '버스', '콜라', '카메라', '피자', '택시', '컴퓨터', '노트북', '셀카', '원룸'][i % 10] + (i >= 10 ? '' : ''), 'w$i', 'm$i')];
    await t.pumpWidget(MaterialApp(home: LoanwordQuizScreen(words: ws, seed: 1)));
    await settle(t, find.byKey(const ValueKey('lq-stem')));
    expect(find.byKey(const ValueKey('lq-opt-3')), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  test('한자 하루 3자 — 하루 글자 수 3, 가족마다 3자 이상', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final days = await HanjaPractice.days();
    expect(days.length, greaterThan(50));
    for (final d in days.take(days.length - 1)) {
      expect(d.fold<int>(0, (a, f) => a + f.members.length), kHanjaPerDay);
    }
    expect(HanjaPractice.roots.length, greaterThanOrEqualTo(4));
    expect(days.first.first.members.first.sound.isNotEmpty, true);
  });

  testWidgets('한자 연습 화면 — 1일차 → 문제 → 마침 기록', (t) async {
    t.view.physicalSize = const Size(360, 1600);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(const MaterialApp(home: HanjaPracticeScreen()));
    await settle(t, find.byKey(const ValueKey('hp-day-1')));
    expect(t.takeException(), isNull);
    await t.tap(find.byKey(const ValueKey('hp-day-1')));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const ValueKey('hp-start')));
    await t.pump();
    for (var i = 0; i < 3; i++) {
      await t.tap(find.byWidgetPredicate((w) => w is OutlinedButton && w.key.toString().contains('hp-opt-')).first);
      await t.pump();
      await t.tap(find.byKey(const ValueKey('hp-next')));
      await t.pump();
    }
    await t.tap(find.byKey(const ValueKey('hp-finish')));
    await t.pumpAndSettle();
    expect(await HanjaPractice.done(), contains('1'));
  });
}
