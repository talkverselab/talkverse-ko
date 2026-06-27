import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart' show rootBundle;
import 'package:k_universe/db/database.dart';

/// Loads bundled JSON seeds into the local drift DB on first launch.
///
/// Idempotent: if `content_seed_version` in `app_meta` matches the current
/// hard-coded version, the seed step is skipped. Bumping `seedVersion` clears
/// all content tables and re-seeds — useful when content schema or data
/// changes during dev.
class SeedLoader {
  final AppDatabase db;
  SeedLoader(this.db);

  /// Bump this when seed content changes — triggers re-seed on next launch.
  static const seedVersion = '7';
  static const _versionKey = 'content_seed_version';

  Future<void> ensureSeeded() async {
    final current = await db.getMeta(_versionKey);
    if (current == seedVersion) return;

    await db.transaction(() async {
      // Clear content tables (user_progress is preserved — it's user state).
      await db.delete(db.annotations).go();
      await db.delete(db.turns).go();
      await db.delete(db.scenarios).go();
      await db.delete(db.vocab).go();
      await db.delete(db.particles).go();
      await db.delete(db.hanja).go(); // legacy table; cleared but no longer seeded

      await _seedScenarios();
      await _seedTurns();
      await _seedAnnotations();
      await _seedVocab();
      await _seedParticles();
    });

    await db.setMeta(_versionKey, seedVersion);
  }

  Future<void> _seedScenarios() async {
    final raw = await rootBundle.loadString('assets/seed/scenarios.json');
    final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
    for (final m in list) {
      await db.into(db.scenarios).insert(
            ScenariosCompanion.insert(
              id: m['id'] as String,
              titleEn: m['title_en'] as String,
              settingEn: m['setting_en'] as String,
              summaryEn: m['summary_en'] as String,
              turnCount: m['turn_count'] as int,
              source: m['source'] as String,
              sourceRef: Value(m['source_ref'] as String?),
              createdAt: DateTime.parse(m['created_at'] as String),
              difficulty: Value(m['difficulty'] as int? ?? 1),
            ),
          );
    }
  }

  Future<void> _seedTurns() async {
    final raw = await rootBundle.loadString('assets/seed/turns.json');
    final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
    for (final m in list) {
      await db.into(db.turns).insert(
            TurnsCompanion.insert(
              scenarioId: m['scenario_id'] as String,
              turnOrder: m['turn_order'] as int,
              speaker: m['speaker'] as String,
              koText: m['ko_text'] as String,
              romanization: m['romanization'] as String,
              enGloss: m['en_gloss'] as String,
              learnerNoteEn: Value(m['learner_note_en'] as String?),
            ),
          );
    }
  }

  Future<void> _seedAnnotations() async {
    final raw = await rootBundle.loadString('assets/seed/annotations.json');
    final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();

    // Annotations in JSON reference (scenario_id, turn_order); resolve to turn id.
    final turnMap = <String, int>{};
    for (final t in await db.select(db.turns).get()) {
      turnMap['${t.scenarioId}:${t.turnOrder}'] = t.id;
    }

    for (final m in list) {
      final key = '${m['scenario_id']}:${m['turn_order']}';
      final turnId = turnMap[key];
      if (turnId == null) continue;
      await db.into(db.annotations).insert(
            AnnotationsCompanion.insert(
              turnId: turnId,
              startOffset: m['start_offset'] as int,
              endOffset: m['end_offset'] as int,
              kind: m['kind'] as String,
              target: m['target'] as String,
              glossEn: m['gloss_en'] as String,
              color: Value(m['color'] as String?),
            ),
          );
    }
  }

  Future<void> _seedVocab() async {
    final raw = await rootBundle.loadString('assets/seed/vocab.json');
    final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
    for (final m in list) {
      await db.into(db.vocab).insert(
            VocabCompanion.insert(
              word: m['word'] as String,
              rank: m['rank'] as int,
              freq: Value((m['freq'] as num?)?.toDouble()),
              cumPct: Value((m['cum_pct'] as num?)?.toDouble()),
              glossEn: Value(m['gloss_en'] as String?),
              pos: Value(m['pos'] as String?),
            ),
          );
    }
  }

  Future<void> _seedParticles() async {
    final raw = await rootBundle.loadString('assets/seed/particles.json');
    final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
    for (final m in list) {
      await db.into(db.particles).insert(
            ParticlesCompanion.insert(
              morph: m['morph'] as String,
              rank: m['rank'] as int,
              cumPct: Value((m['cum_pct'] as num?)?.toDouble()),
              category: m['category'] as String,
              glossEn: m['gloss_en'] as String,
              notesEn: Value(m['notes_en'] as String?),
            ),
          );
    }
  }

}
