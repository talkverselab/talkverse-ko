import 'package:flutter/material.dart';
import 'package:k_universe/features/home_shell.dart';
import 'package:k_universe/ui/theme.dart';

class KUniverseApp extends StatelessWidget {
  const KUniverseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'K-Universe',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      home: const HomeShell(),
    );
  }
}
