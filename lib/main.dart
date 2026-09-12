import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:k_universe/app.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/db/seed_loader.dart';
import 'package:k_universe/state/app_state.dart';
import 'core/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await SeedLoader(db).ensureSeeded();

  await AppLangPrefs.load();

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
