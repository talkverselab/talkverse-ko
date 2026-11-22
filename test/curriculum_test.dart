import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:k_universe/curriculum/curriculum_store.dart';
import 'package:k_universe/drama/drama_service.dart';

DramaEpisode ep(String id, String island, int n) => DramaEpisode.fromJson({
      'id': id,
      'region': 'R1',
      'island': island,
      'turns': [
        for (var i = 1; i <= n; i++) {'num': i, 'speaker': i.isOdd ? 'A' : 'B', 'ko': '문장 $id $i 이에요', 'rd': '', 'en': 'Line $id $i', 'note': ''},
      ],
    });

void main() {
  test('점수 80% 경계 — 소수점 버림', () {
    expect(scorePercent(8, 10), 80);
    expect(isPass(8, 10), isTrue);
    expect(isPass(7, 10), isFalse);
    expect(scorePercent(23, 29), 79); // 79.3 → 79
    expect(isPass(23, 29), isFalse);
    expect(isPass(24, 30), isTrue);
    expect(scorePercent(0, 0), 0);
  });

  test('간격 반복 1·3·7일, 틀리면 1일로', () {
    final s = CurriculumState();
    s.enqueue('a#1', '2026-11-22');
    expect(s.review.single.due, '2026-11-23');
    s.answerReview('a#1', true, '2026-11-23');
    expect(s.review.single.due, '2026-11-26');
    expect(s.review.single.step, 1);
    s.answerReview('a#1', true, '2026-11-26');
    expect(s.review.single.due, '2026-12-03');
    s.answerReview('a#1', false, '2026-12-03');
    expect(s.review.single.due, '2026-12-04');
    expect(s.review.single.step, 0);
    s.answerReview('a#1', true, '2026-12-04');
    s.answerReview('a#1', true, '2026-12-07');
    s.answerReview('a#1', true, '2026-12-14');
    expect(s.review, isEmpty); // 7일 간격까지 맞히면 졸업
  });

  test('하루 분량·연속 일수', () {
    final s = CurriculumState(dailyGoal: 1);
    expect(s.newLeft('2026-11-22'), 1);
    s.todayNew = 1;
    expect(s.dailyDone('2026-11-22'), isTrue);
    s.touchStreak('2026-11-22');
    expect(s.streakCount, 1);
    s.rollDay('2026-11-23');
    s.todayNew = 1;
    s.touchStreak('2026-11-23');
    expect(s.streakCount, 2);
    expect(s.streakShown('2026-11-25'), 0);
  });

  test('저장 형식 왕복(curriculum_v1)', () {
    final s = CurriculumState(level: 'R1', course: Course(id: 'c1', dialogueIds: ['x', 'y'], practiced: ['x'], examScores: [70]));
    s.enqueue('x#2', '2026-11-22');
    final j = s.toJson();
    expect(j.keys, containsAll(['level', 'dailyGoal', 'course', 'passedDialogues', 'review', 'streak']));
    final b = CurriculumState.fromJson(j);
    expect(b.course!.practiced, ['x']);
    expect(b.review.single.lineId, 'x#2');
  });

  test('추천은 주제를 돌아가며, 시험 문제 수 편당 3~10·최대 30', () {
    final eps = [ep('l1', 'love', 4), ep('l2', 'love', 4), ep('f1', 'friends', 4), ep('w1', 'work', 4)];
    final r = recommend(eps, {}, 3);
    expect(r.toSet(), {'l1', 'f1', 'w1'});
    expect(examPerEpisode(10), 3);
    expect(examPerEpisode(5), 6);
    expect(examPerEpisode(3), 10);
    final qs = examQuestions(eps, const [], rnd: Random(1));
    expect(qs.length, lessThanOrEqualTo(30));
    for (final q in qs) {
      expect(q.options.length, 4);
      expect(q.options[q.answer], startsWith('Line'));
    }
  });
}
