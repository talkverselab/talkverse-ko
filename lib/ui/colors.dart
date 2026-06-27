import 'package:flutter/material.dart';

/// K-Universe color palette — "Lovely Runner" / first-love K-drama mood.
///
/// Dusty rose for the brand. Warm buttercream and golden-hour gold for that
/// late-afternoon sun feeling. Lilac as the time-travel/dream accent. Sage
/// for the school-uniform memory tone. Everything sits on a soft cream
/// background — never pure white.
class KColors {
  // Brand / primary
  static const softPink = Color(0xFFF08CA7);   // dusty rose — Lovely Runner signature
  static const lilac = Color(0xFFB9A4E6);      // dreamy violet
  static const sage = Color(0xFFB5DAB3);       // school-uniform mint
  static const buttercream = Color(0xFFF2CA82);// golden hour
  static const coral = Color(0xFFF6A48C);      // sunset coral

  // Surfaces / ink
  static const ink = Color(0xFF3A2C4F);        // deep plum
  static const inkSoft = Color(0xFF7A6E8C);
  static const inkFaint = Color(0xFFB8AEC6);
  static const bgCream = Color(0xFFFFF6E9);    // warm cream app bg
  static const surface = Color(0xFFFFFDF8);    // off-white card
  static const surfaceTint = Color(0xFFFCEFE8);

  // Dark variant
  static const darkBg = Color(0xFF2A1F3D);
  static const darkSurface = Color(0xFF3A2D52);

  // Pastel tile backgrounds — golden-hour / first-love palette
  static const tileCream = Color(0xFFFFF1DE);
  static const tileLilac = Color(0xFFECDEFC);
  static const tileBlush = Color(0xFFFFE2EA);
  static const tilePeach = Color(0xFFFFE6D0);
  static const tileGold = Color(0xFFFFF2CB);
  static const tileMint = Color(0xFFDEF0DC);
  static const tileSage = Color(0xFFE5F0DE);
  static const tileLavender = Color(0xFFE8E0FB);

  // Annotation colors
  static const annParticle = lilac;
  static const annEnding = softPink;
  static const annHonorific = buttercream;
  static const annVocab = sage;
}

class ScenarioVisual {
  final String emoji;
  final Color tileColor;
  const ScenarioVisual(this.emoji, this.tileColor);

  static const _map = <String, ScenarioVisual>{
    'cafe-ordering-01':
        ScenarioVisual('☕', KColors.tileCream),
    'taxi-guesthouse-01':
        ScenarioVisual('🚖', KColors.tileGold),
    'convenience-store-01':
        ScenarioVisual('🏪', KColors.tileBlush),
    'first-meeting-01':
        ScenarioVisual('🌸', KColors.tileLavender),
    'restaurant-recommend-01':
        ScenarioVisual('🍱', KColors.tilePeach),
    'subway-asking-01':
        ScenarioVisual('🚇', KColors.tileLilac),
    'market-haggling-01':
        ScenarioVisual('🥬', KColors.tileSage),
    'pharmacy-cold-01':
        ScenarioVisual('💊', KColors.tileMint),
  };

  static ScenarioVisual forId(String id) =>
      _map[id] ?? const ScenarioVisual('💫', KColors.tileLilac);
}
