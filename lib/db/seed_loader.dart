import '../core/embed_env.dart';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart' show rootBundle;
import 'package:k_universe/db/database.dart';

/// Loads bundled JSON seeds into the local drift DB on first launch.
///
/// DB 업데이트 번호(2026-11-04, 모든 언어앱 공통): 번들 `assets/data/version.json` 의 `db` 번호가
/// 저장된 번호(app_meta `content_seed_version`)와 다르면 내용 표를 전부 지우고 다시 채운다(user_progress 는 남김).
/// 데이터를 바꾸면 version.json 의 `db` 번호만 올리고 `log` 에 한 줄.
class SeedLoader {
  final AppDatabase db;
  SeedLoader(this.db);

  static const _versionKey = 'content_seed_version'; // app_meta(DB) 키 — DB 파일이 이미 언어별

  static Future<String> bundledVersion() async {
    try {
      final j = json.decode(await rootBundle.loadString(assetPath('assets/data/version.json'))) as Map<String, dynamic>;
      return '${j['db']}';
    } catch (_) {
      return '0';
    }
  }

  Future<void> ensureSeeded() async {
    final seedVersion = await bundledVersion();
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
    final raw = await rootBundle.loadString(assetPath('assets/seed/scenarios.json'));
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
    final raw = await rootBundle.loadString(assetPath('assets/seed/turns.json'));
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
    final raw = await rootBundle.loadString(assetPath('assets/seed/annotations.json'));
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
    final raw = await rootBundle.loadString(assetPath('assets/seed/vocab.json'));
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
    final raw = await rootBundle.loadString(assetPath('assets/seed/particles.json'));
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
