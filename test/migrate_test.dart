import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k_universe/embed.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('옛 저장 이름 → ko_ 접두로 한 번 이전', () async {
    final dir = Directory.systemTemp.createTempSync('kmig');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('plugins.flutter.io/path_provider'), (_) async => dir.path);
    File('${dir.path}/k_universe.sqlite').writeAsStringSync('db');
    File('${dir.path}/review_items.json').writeAsStringSync('{}');
    Directory('${dir.path}/art').createSync();
    SharedPreferences.setMockInitialValues({'drama_watched': ['a', 'b'], 'achievements_v1': '{"x":1}', 'roman_show': true, 'learner_name': 'Mina', 'review_new_per_day': 30});
    await migrateStorage();
    final p = await SharedPreferences.getInstance();
    expect(p.getStringList('ko_drama_watched'), ['a', 'b']);
    expect(p.getString('ko_achievements_v1'), '{"x":1}');
    expect(p.getBool('ko_roman_show'), true);
    expect(p.getInt('ko_review_new_per_day'), 30);
    expect(p.containsKey('drama_watched'), false);
    expect(p.getString('learner_name'), 'Mina'); // 공유 값은 그대로
    expect(File('${dir.path}/ko_k_universe.sqlite').existsSync(), true);
    expect(File('${dir.path}/ko_review_items.json').existsSync(), true);
    expect(Directory('${dir.path}/ko_art').existsSync(), true);
    // 두 번째는 아무것도 안 한다
    await p.setString('drama_last', 'new');
    await migrateStorage();
    expect(p.getString('drama_last'), 'new');
  });
}
