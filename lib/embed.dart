import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/embed_env.dart';
import 'core/l10n.dart';
import 'data/account.dart';
import 'data/purchase.dart';
import 'db/database.dart';
import 'db/seed_loader.dart';
import 'review/review_service.dart';
import 'review/review_ui.dart';
import 'services/content_sync.dart';
import 'services/learner_prefs.dart';
import 'state/app_state.dart';

/// 임베드 약속(talkverse-uk docs/talkverse-app/DESIGN.md, 2026-11-09) — 단독 앱 main() 과 통합 앱이 같은 두 함수를 쓴다.
/// 통합 앱: `await embedInit(embedded: true); … embedApp(onSwitchLanguage: …)`. 단독: main.dart.
late AppDatabase _db;
bool _syncFirst = false;

/// 가격표 = ~/talkverse/PRICING.md(사용자 확정 2026-11-09) — 앱 할인가(30%)·앱 정가. 스토어 등록 목록 docs/STORE_PRODUCTS.md
const plans = [
  Plan('lang_ko_1m', 1, 3900, listKrw: 5500),
  Plan('lang_ko_3m', 3, 9000, listKrw: 12900),
  Plan('lang_ko_1y', 12, 19900, listKrw: 28500),
  Plan('lang_ko_life', 0, 49000, listKrw: 69900),
  Plan('all_1y', 12, 79000, listKrw: 112900, bundle: true),
  Plan('all_life', 0, 329000, listKrw: 469000, bundle: true),
];

/// 지금까지의 main() 초기화 전부(runApp·화면 방향 제외).
Future<void> embedInit({bool embedded = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  Embed.embedded = embedded;
  ReviewService.keyPrefix = '${Embed.code}_';
  await migrateStorage();
  _db = AppDatabase();
  await SeedLoader(_db).ensureSeeded();
  await AppLangPrefs.load();
  await LearnerPrefs.load();
  await ReviewService.instance.load(file: File('${(await getApplicationDocumentsDirectory()).path}/${pk('review_items.json')}'));
  ReviewText.en = !AppLangPrefs.isKo;
  // 그림 기기 내려받기 — 매니페스트가 바뀌었으면 시작 때 로딩 화면, 오프라인이면 바로 홈.
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final shortest = view.physicalSize.shortestSide / view.devicePixelRatio;
  try {
    _syncFirst = await ContentSync.instance.init(large: shortest >= 600, female: LearnerPrefs.isFemale).timeout(const Duration(seconds: 10));
  } catch (_) {}
  Account.load(); // 저장된 로그인 표시 + 뒤에서 토큰 갱신(기다리지 않음) — Talkverse ID
  Purchase.configure(Embed.code, plans);
}

/// runApp 에 넘기는 위젯. onSwitchLanguage 가 있으면 프로필에 「다른 언어 배우기」.
Widget embedApp({VoidCallback? onSwitchLanguage}) {
  Embed.onSwitchLanguage = onSwitchLanguage;
  return MultiProvider(
    providers: [
      Provider<AppDatabase>.value(value: _db),
      ChangeNotifierProvider(create: (_) => AppState()),
    ],
    child: KUniverseApp(syncFirst: _syncFirst),
  );
}

/// 설계 문서 이름(init/app)으로도 부를 수 있게.
Future<void> init() => embedInit(embedded: true);
Widget app({VoidCallback? onSwitchLanguage}) => embedApp(onSwitchLanguage: onSwitchLanguage);

/// 옛 저장 이름(접두 없음) → `ko_` 접두로 한 번 옮긴다: SharedPreferences 키·DB 파일·그림 폴더·복습 기록.
/// 학습자 이름·성별(learner_*)·표시 언어(app_lang)·로그인(보안 저장소 tv_*)은 언어 공통이라 그대로.
Future<void> migrateStorage() async {
  final p = await SharedPreferences.getInstance();
  if (p.getBool(pk('storage_migrated_v1')) ?? false) return;
  const keys = ['drama_last', 'drama_watched', 'iap_owned2', 'iap_owned', 'iap_pending', 'achievements_v1', 'roman_show',
    'art_audio_manifest_v1', 'art_words_manifest_v1', 'art_version_v1', 'art_scene_manifest_v1',
    'review_new_per_day', 'review_direction', 'review_reminder', 'review_migrated_v1'];
  for (final k in keys) {
    final v = p.get(k);
    if (v == null || p.containsKey(pk(k))) continue;
    switch (v) {
      case String s: await p.setString(pk(k), s);
      case bool b: await p.setBool(pk(k), b);
      case int i: await p.setInt(pk(k), i);
      case double d: await p.setDouble(pk(k), d);
      case List l: await p.setStringList(pk(k), l.cast<String>());
    }
    await p.remove(k);
  }
  try {
    final docs = (await getApplicationDocumentsDirectory()).path;
    for (final ext in ['', '-wal', '-shm']) {
      final old = File('$docs/k_universe.sqlite$ext'), neu = File('$docs/ko_k_universe.sqlite$ext');
      if (await old.exists() && !await neu.exists()) await old.rename(neu.path);
    }
    final rv = File('$docs/review_items.json'), rvn = File('$docs/${pk('review_items.json')}');
    if (await rv.exists() && !await rvn.exists()) await rv.rename(rvn.path);
    final sup = (await getApplicationSupportDirectory()).path;
    final art = Directory('$sup/art'), artn = Directory('$sup/${pk('art')}');
    if (await art.exists() && !await artn.exists()) await art.rename(artn.path);
  } catch (e) {
    debugPrint('migrateStorage: $e');
  }
  await p.setBool(pk('storage_migrated_v1'), true);
}
