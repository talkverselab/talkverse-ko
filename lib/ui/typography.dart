import 'package:flutter/material.dart';

/// K-Universe text styles.
///
/// `koHero` is for the headline Korean line in a dialogue turn — generous size,
/// medium weight, comfortable line height.
/// `koRoman` is the romanization underneath — slightly muted, italic.
class KType {
  static const headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.15,
  );
  static const headlineMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.2,
  );
  static const titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static const titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );
  static const bodyLarge = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  static const bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );
  static const labelLarge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.3,
  );
  static const koHero = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  static const koRoman = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    fontStyle: FontStyle.italic,
    height: 1.3,
  );
}
