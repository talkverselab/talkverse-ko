import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:k_universe/app.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/db/seed_loader.dart';
import 'package:k_universe/state/app_state.dart';
import 'core/l10n.dart';
import 'data/account.dart';
import 'data/purchase.dart';
import 'review/review_service.dart';
import 'review/review_ui.dart';
import 'services/content_sync.dart';
import 'services/learner_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await SeedLoader(db).ensureSeeded();

  await AppLangPrefs.load();
  await LearnerPrefs.load();
  await ReviewService.instance.load();
  ReviewText.en = !AppLangPrefs.isKo;
  // 그림 기기 내려받기(2026-11-04) — 매니페스트가 바뀌었으면 시작 때 로딩 화면, 오프라인이면 바로 홈.
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final shortest = view.physicalSize.shortestSide / view.devicePixelRatio;
  var syncFirst = false;
  try {
    syncFirst = await ContentSync.instance.init(large: shortest >= 600, female: LearnerPrefs.isFemale).timeout(const Duration(seconds: 10));
  } catch (_) {}
  Account.load(); // 저장된 로그인 표시 + 뒤에서 토큰 갱신(기다리지 않음) — Talkverse ID
  // 가격표 = ~/talkverse/PRICING.md(사용자 확정 2026-11-09) — 앱 할인가(30%)·앱 정가. 스토어 등록 목록 docs/STORE_PRODUCTS.md
  Purchase.configure('ko', const [
    Plan('lang_ko_1m', 1, 3900, listKrw: 5500),
    Plan('lang_ko_3m', 3, 9000, listKrw: 12900),
    Plan('lang_ko_1y', 12, 19900, listKrw: 28500),
    Plan('lang_ko_life', 0, 49000, listKrw: 69900),
    Plan('all_1y', 12, 79000, listKrw: 112900, bundle: true),
    Plan('all_life', 0, 329000, listKrw: 469000, bundle: true),
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: KUniverseApp(syncFirst: syncFirst),
    ),
  );
}
