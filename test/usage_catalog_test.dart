import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:k_universe/data/entitlement.dart';
import 'package:k_universe/data/usage_pages.dart';
import 'package:k_universe/drama/drama_service.dart';
import 'package:k_universe/features/sense/sense_course_screen.dart';

/// tool/usage_catalog.json(tools/usage_catalog.py)이 앱이 보내는 화면 ID·잠금 기준과 같은가.
void main() {
  final cat = {
    for (final p in (jsonDecode(File('tool/usage_catalog.json').readAsStringSync())['pages'] as List).cast<Map<String, dynamic>>()) p['page'] as String: p['tier'] as String,
  };
  setUp(() => Entitlement.premiumForTest = false);
  tearDown(() => Entitlement.premiumForTest = null);

  test('회화 편 — ID·tier 가 canOpenEpisode 와 같다', () {
    final files = Directory('assets/data/dialogues').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.json') && RegExp(r'/R[0-4]/[^/]+/[^/]+\.json$').hasMatch(f.path));
    var n = 0;
    for (final f in files) {
      final e = DramaEpisode.fromJson(jsonDecode(f.readAsStringSync()) as Map<String, dynamic>);
      expect(cat[UsagePages.episode(e.id)], Entitlement.canOpenEpisode(e) ? 'free' : 'pro', reason: e.id);
      n++;
    }
    expect(n, greaterThan(200));
  });

  test('언어감각 회차 — 보이는 급 순서로 freeSenseLevels(1)까지 free', () {
    final d = jsonDecode(File('assets/data/grammar/sense_course.json').readAsStringSync()) as Map<String, dynamic>;
    final levels = SenseCourse.visibleLevels(d);
    for (final (lv, ls) in SenseCourse.flat(d)) {
      final i = levels.indexWhere((x) => x['id'] == lv['id']);
      expect(cat[UsagePages.sense(ls['id'] as String)], i < 1 ? 'free' : 'pro', reason: ls['id'] as String);
    }
  });

  test('고정 화면 ID 가 목록에 있다', () {
    for (final p in [UsagePages.vocab, UsagePages.particles, UsagePages.loanwords, UsagePages.loanwordQuiz, UsagePages.hanja, UsagePages.hangul]) {
      expect(cat[p], 'free', reason: p);
    }
  });
}
