import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k_universe/curriculum/curriculum_screen.dart';
import 'package:k_universe/curriculum/curriculum_service.dart';
import 'package:k_universe/drama/drama_service.dart';

DramaEpisode _d(String id, String island, int n) => DramaEpisode.fromJson({
      'id': id,
      'region': 'R1',
      'island': island,
      'turns': [
        for (var i = 1; i <= n; i++) {'num': i, 'speaker': i.isOdd ? 'A' : 'B', 'ko': '문장$id$i', 'rd': '', 'en': 'mean$id$i', 'note': ''}
      ],
    });

void main() {
  group('점수 80% 경계', () {
    test('소수점 버림', () {
      expect(scorePercent(7, 9), 77);
      expect(scorePercent(2, 3), 66);
      expect(scorePercent(0, 0), 0);
    });
    test('80% 이상만 통과', () {
      expect(isPass(8, 10), isTrue);
      expect(isPass(79, 100), isFalse);
      expect(isPass(4, 5), isTrue);
      expect(isPass(23, 29), isFalse); // 79.3 → 79
      expect(isPass(24, 30), isTrue);
    });
    test('시험 기록 — 통과면 편 통과, 아니면 틀린 편 연습 다시', () {
      final st = CurriculumState(course: Course('c', ['a', 'b'], practiced: ['a', 'b']));
      expect(st.recordExam(7, 10, {'b'}, '2026-11-22'), isFalse);
      expect(st.course!.practiced, ['a']);
      expect(st.passedDialogues, isEmpty);
      st.course!.practiced.add('b');
      expect(st.recordExam(8, 10, {}, '2026-11-23'), isTrue);
      expect(st.course!.passedAt, '2026-11-23');
      expect(st.passedDialogues, ['a', 'b']);
      expect(st.course!.examScores, [70, 80]);
    });
  });

  group('간격 반복 날짜', () {
    test('1일 → 3일 → 7일 → 졸업', () {
      final st = CurriculumState();
      st.enqueue('x#1', '2026-11-22');
      expect(st.review.single.due, '2026-11-23');
      st.grade('x#1', true, '2026-11-23');
      expect(st.review.single.due, '2026-11-26');
      st.grade('x#1', true, '2026-11-26');
      expect(st.review.single.due, '2026-12-03');
      st.grade('x#1', true, '2026-12-03');
      expect(st.review, isEmpty);
    });
    test('틀리면 1일 뒤 처음 간격으로', () {
      final st = CurriculumState();
      st.enqueue('x#1', '2026-11-22');
      st.grade('x#1', true, '2026-11-23');
      st.grade('x#1', false, '2026-11-26');
      expect(st.review.single.step, 0);
      expect(st.review.single.due, '2026-11-27');
    });
    test('달·해 넘김', () {
      expect(addDays('2026-12-30', 3), '2027-01-02');
      expect(addDays('2028-02-28', 1), '2028-02-29');
    });
  });

  group('하루 분량·연속', () {
    test('새 편 목표를 채우고 복습이 없으면 끝, 연속 일수', () {
      final st = CurriculumState(dailyGoal: 1, course: Course('c', ['a', 'b']));
      expect(st.dayDone('2026-11-22'), isFalse);
      st.markPracticed('a', [1, 2], '2026-11-22');
      expect(st.dayDone('2026-11-22'), isTrue);
      expect(st.streakShown('2026-11-22'), 1);
      // 다음 날: 복습 2줄 + 새 편 1
      expect(st.dueReview('2026-11-23').length, 2);
      st.grade('a#1', true, '2026-11-23');
      st.grade('a#2', true, '2026-11-23');
      st.markPracticed('b', [1], '2026-11-23');
      expect(st.todayReview, 2);
      expect(st.streakShown('2026-11-23'), 2);
      expect(st.streakShown('2026-11-25'), 0);
    });
    test('저장 형식 왕복', () {
      final st = CurriculumState(level: 'R1', course: Course('c', ['a']));
      st.markPracticed('a', [1], '2026-11-22');
      final back = CurriculumState.fromJson(st.toJson());
      expect(back.toJson(), st.toJson());
      expect(st.toJson().keys, containsAll(['level', 'dailyGoal', 'course', 'passedDialogues', 'review', 'streak']));
    });
  });

  group('문제·추천', () {
    test('편마다 줄 수만큼, 최대 10, 보기 4개 중 정답 1', () {
      final a = _d('a', 'friends', 12), b = _d('b', 'life', 4);
      final qs = buildQuestions(a, limit: 10, pool: [b]);
      expect(qs.length, 10);
      for (final q in qs) {
        expect(q.choices.length, 4);
        expect(q.choices.toSet().length, 4);
        expect(q.choices[q.answer], 'meana${q.turn}');
      }
      expect(buildQuestions(b, limit: 10, pool: [a]).length, 4);
    });
    test('시험 문제 수: 편당 최소 3, 전체 최대 30', () {
      expect(examPerDialogue(3), 10);
      expect(examPerDialogue(5), 6);
      expect(examPerDialogue(10), 3);
    });
    test('추천 = 안 한 편, 주제 겹치지 않게', () {
      final list = [_d('f1', 'friends', 2), _d('f2', 'friends', 2), _d('l1', 'life', 2), _d('w1', 'work', 2)];
      final r = recommend(list, {'l1'}, {}, 3);
      expect(r, ['f1', 'w1', 'f2']);
    });
  });

  testWidgets('시험 화면 — 고르고 결과까지', (t) async {
    final a = _d('a', 'friends', 5);
    final qs = buildQuestions(a, limit: 2);
    await t.pumpWidget(MaterialApp(home: CurriculumQuizScreen(title: 'T', questions: qs, mode: QuizMode.exam)));
    for (var i = 0; i < 2; i++) {
      await t.tap(find.text(qs[i].choices[qs[i].answer]));
      await t.pump();
      await t.tap(find.byType(FilledButton).last);
      await t.pump();
    }
    expect(find.textContaining('100'), findsOneWidget);
  });

  // 코스 고르기의 3·5·10 칩 + 「추천으로 채우기」 줄 — 폰 폭·300px(아이패드 분할 왼쪽)에서 넘치지 않음(uk 전달 2026-11-22)
  for (final w in [390.0, 300.0]) {
    testWidgets('코스 고르기 칩 줄 넘침 없음 — 폭 $w', (t) async {
      SharedPreferences.setMockInitialValues({'ko_curriculum_v1': '{"level":"R0","dailyGoal":2}'});
      CurriculumService.network = false;
      t.view.physicalSize = Size(w, 800);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(const MaterialApp(home: CurriculumScreen()));
      await t.runAsync(() async {
        await CurriculumService.instance.ensureLoaded();
        await Future<void>.delayed(const Duration(milliseconds: 300));
      });
      for (var i = 0; i < 5; i++) {
        await t.pump(const Duration(milliseconds: 100));
      }
      expect(find.byType(ChoiceChip), findsNWidgets(3));
      expect(t.takeException(), isNull);
    });
  }

  group('§12 단계표(서버 → 기기 → 묶음)', () {
    test('형식 읽기·옛 R 값 → 단계', () {
      final p = parsePlan('{"rev":3,"stages":[{"n":2,"title":"2단계","dialogueIds":["b"]},{"n":1,"title":"1단계","desc":"d","dialogueIds":["a","없는편"]}]}')!;
      expect(p.rev, 3);
      expect(p.stages.map((s) => s.n), [1, 2]);
      expect(parsePlan('깨진 글'), isNull);
      expect(stageOfLegacy('R0'), '1');
      expect(stageOfLegacy('R1'), '1');
      expect(stageOfLegacy('R3'), '3');
      expect(stageOfLegacy('2'), '2');
    });

    test('서버 rev 가 크면 바꾸고, 작거나 같으면 그대로', () async {
      SharedPreferences.setMockInitialValues({});
      final svc = CurriculumService.instance;
      svc.setStagesForTest(const [CurStage(1, '1단계', '', ['x'])], rev: 2);
      expect(await svc.refreshPlan(fetch: (_) async => '{"rev":2,"stages":[{"n":1,"title":"옛","dialogueIds":["y"]}]}'), isFalse);
      expect(svc.stage('1')!.ids, ['x']);
      expect(await svc.refreshPlan(fetch: (_) async => '{"rev":5,"stages":[{"n":1,"title":"새 1단계","dialogueIds":["y"]},{"n":2,"title":"2단계","dialogueIds":[]}]}'), isTrue);
      expect(svc.planRev, 5);
      expect(svc.stageTitle('1'), '새 1단계');
      expect(await svc.refreshPlan(fetch: (_) async => null), isFalse); // 서버 못 받음 → 그대로
      expect(svc.stageTitle('1'), '새 1단계');
    });
  });

  test('§12 덧붙임 — 단계표 pick·pass·daily 를 읽고, 없으면 기본값', () {
    final p = parsePlan('{"rev":1,"stages":[{"n":1,"dialogueIds":[],"pick":[4,8],"pass":70,"daily":{"light":2,"normal":3,"focus":5}},{"n":2,"dialogueIds":[],"pick":3},{"n":3,"dialogueIds":[]}]}')!;
    final a = p.stages[0], b = p.stages[1], c = p.stages[2];
    expect(a.pick, [4, 8]);
    expect(a.pass, 70);
    expect(a.daily, [2, 3, 5]);
    expect(b.pickDefault, 3);
    expect(b.pick, [3, 5, 10]);
    expect(c.pass, 80);
    expect(c.daily, [1, 2, 3]);
    // 통과 점수는 시험 판정에도
    final st = CurriculumState(course: Course('c', ['x']));
    expect(st.recordExam(7, 10, {}, '2026-11-23', pass: 70), isTrue);
    final st2 = CurriculumState(course: Course('c', ['x']));
    expect(st2.recordExam(7, 10, {}, '2026-11-23'), isFalse);
    // 하루 새 편 수 = 단계표 daily
    final st3 = CurriculumState(dailyGoal: 3)..dailyCounts = const [2, 3, 5];
    expect(st3.newLeft('2026-11-23'), 5);
  });
}
