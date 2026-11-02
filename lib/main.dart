import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:k_universe/app.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/db/seed_loader.dart';
import 'package:k_universe/state/app_state.dart';
import 'core/l10n.dart';
import 'data/account.dart';
import 'data/purchase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await SeedLoader(db).ensureSeeded();

  await AppLangPrefs.load();
  Account.load(); // 저장된 로그인 표시 + 뒤에서 토큰 갱신(기다리지 않음) — Talkverse ID
  Purchase.configure({'ko': ('com.kuniverse.kUniverse.lifetime', 'lang_ko')}); // 평생 이용권(스토어)

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const KUniverseApp(),
    ),
  );
}
