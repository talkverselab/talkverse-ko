import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:k_universe/app.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/db/seed_loader.dart';
import 'package:k_universe/state/app_state.dart';
import 'core/l10n.dart';
import 'data/account.dart';
import 'data/purchase.dart';
import 'services/content_sync.dart';
import 'services/learner_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await SeedLoader(db).ensureSeeded();

  await AppLangPrefs.load();
  await LearnerPrefs.load();
  // 그림 기기 내려받기(2026-11-04) — 매니페스트가 바뀌었으면 시작 때 로딩 화면, 오프라인이면 바로 홈.
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final shortest = view.physicalSize.shortestSide / view.devicePixelRatio;
  var syncFirst = false;
  try {
    syncFirst = await ContentSync.instance.init(large: shortest >= 600).timeout(const Duration(seconds: 10));
  } catch (_) {}
  Account.load(); // 저장된 로그인 표시 + 뒤에서 토큰 갱신(기다리지 않음) — Talkverse ID
  Purchase.configure({'ko': ('com.kuniverse.kUniverse.lifetime', 'lang_ko')}); // 평생 이용권(스토어)

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
