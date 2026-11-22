import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k_universe/features/sense/sense_course_screen.dart';
import 'package:k_universe/services/script_sync.dart';

/// 문법(언어감각) 스텝은 데이터 — 서버 원고가 있으면 그것, 없으면 앱에 묶은 것, 빈 스텝은 숨김(사용자 지시 2026-11-23).
String sha(String s) => sha1.convert(utf8.encode(s)).toString().substring(0, 12);
const rel = 'grammar/sense_course.json';

Map<String, dynamic> lesson(String id, {List<String> sentences = const ['문장']}) =>
    {'id': id, 'title': id, 'kind': 'memorize', 'video': '', 'sentences': sentences, 'footnotes': []};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory dir;
  setUp(() {
    dir = Directory.systemTemp.createTempSync('sense_sync');
    SenseCourse.resetCache();
  });
  tearDown(() {
    SenseCourse.syncForTest = null;
    SenseCourse.resetCache();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  test('서버 것이 없으면 앱에 묶은 10스텝', () async {
    SenseCourse.syncForTest = ScriptSync.forTest(dir: dir, fetch: (_) async => null, baseline: {'rev': 1, 'files': {}});
    final d = await SenseCourse.load();
    expect(SenseCourse.visibleLevels(d).length, 10);
  });

  test('서버 rev 가 크면 서버 스텝 목록 그대로 — 빠진 스텝(L5~L10)·빈 스텝은 안 보이고 새 스텝(L16)은 보임', () async {
    final server = json.encode({
      'title': 't',
      'levels': [
        {'id': 'L1', 'title': '서버 스텝 1', 'lessons': [lesson('L1-talk')]},
        {'id': 'L2', 'title': '아직 빈 스텝', 'lessons': []},
        {'id': 'L3', 'title': '문장 없는 회차만', 'lessons': [lesson('L3-talk', sentences: const [])]},
        {'id': 'L4', 'title': '서버 스텝 4', 'lessons': [lesson('L4-talk'), lesson('L4-empty', sentences: const [])]},
        {'id': 'L16', 'title': '묶음에 없던 새 스텝', 'lessons': [lesson('L16-talk')]},
      ],
    });
    final s = ScriptSync.forTest(
      dir: dir,
      baseline: {'rev': 1, 'files': {rel: 'old'}},
      fetch: (url) async => url.endsWith('/index.json') ? json.encode({'rev': 2, 'files': {rel: sha(server)}}) : (url.contains(rel) ? server : null),
    );
    SenseCourse.syncForTest = s;
    expect(await s.refresh(), isTrue);
    final d = await SenseCourse.load();
    final lv = SenseCourse.visibleLevels(d);
    expect(lv.map((e) => e['id']), ['L1', 'L4', 'L16']);
    expect(lv.first['title'], '서버 스텝 1');
    expect((lv[1]['lessons'] as List).length, 1);
    expect(SenseCourse.flat(d).map((e) => e.$2['id']), ['L1-talk', 'L4-talk', 'L16-talk']);
  });
}
