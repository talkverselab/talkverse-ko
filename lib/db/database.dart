import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// =============================================================================
// Content tables (seeded once from bundled JSON, read-only at runtime)
// =============================================================================

@DataClassName('Scenario')
class Scenarios extends Table {
  TextColumn get id => text()();
  TextColumn get titleEn => text().named('title_en')();
  TextColumn get settingEn => text().named('setting_en')();
  TextColumn get summaryEn => text().named('summary_en')();
  IntColumn get difficulty => integer().withDefault(const Constant(1))();
  IntColumn get turnCount => integer().named('turn_count')();
  TextColumn get source => text()();
  TextColumn get sourceRef => text().named('source_ref').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Turn')
class Turns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get scenarioId =>
      text().named('scenario_id').references(Scenarios, #id)();
  IntColumn get turnOrder => integer().named('turn_order')();
  TextColumn get speaker => text()();
  TextColumn get koText => text().named('ko_text')();
  TextColumn get romanization => text()();
  TextColumn get enGloss => text().named('en_gloss')();
  TextColumn get learnerNoteEn => text().named('learner_note_en').nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {scenarioId, turnOrder},
  ];
}

@DataClassName('Annotation')
class Annotations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get turnId => integer().named('turn_id').references(Turns, #id)();
  IntColumn get startOffset => integer().named('start_offset')();
  IntColumn get endOffset => integer().named('end_offset')();
  TextColumn get kind => text()(); // particle | ending | honorific | vocab
  TextColumn get target => text()();
  TextColumn get glossEn => text().named('gloss_en')();
  TextColumn get color => text().nullable()();
}

@DataClassName('VocabEntry')
class Vocab extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get word => text().unique()();
  IntColumn get rank => integer()();
  RealColumn get freq => real().nullable()();
  RealColumn get cumPct => real().named('cum_pct').nullable()();
  TextColumn get glossEn => text().named('gloss_en').nullable()();
  TextColumn get pos => text().nullable()();
}

@DataClassName('Particle')
class Particles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get morph => text().unique()();
  IntColumn get rank => integer()();
  RealColumn get cumPct => real().named('cum_pct').nullable()();
  TextColumn get category => text()();
  TextColumn get glossEn => text().named('gloss_en')();
  TextColumn get notesEn => text().named('notes_en').nullable()();
}

// =============================================================================
// User-state tables (read-write at runtime)
// =============================================================================

@DataClassName('UserProgressRow')
class UserProgress extends Table {
  TextColumn get scenarioId =>
      text().named('scenario_id').references(Scenarios, #id)();
  TextColumn get status =>
      text().withDefault(const Constant('not_started'))();
  IntColumn get lastTurnOrder =>
      integer().named('last_turn_order').withDefault(const Constant(0))();
  DateTimeColumn get startedAt => dateTime().named('started_at').nullable()();
  DateTimeColumn get completedAt =>
      dateTime().named('completed_at').nullable()();

  @override
  Set<Column> get primaryKey => {scenarioId};
}

@DataClassName('AppMetaRow')
class AppMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('HanjaEntry')
class Hanja extends Table {
  TextColumn get id => text()(); // e.g. hanja:0001
  TextColumn get koHanja => text().named('ko_hanja')();
  TextColumn get yumeum => text()(); // Korean reading
  TextColumn get zhSimp => text().named('zh_simp').nullable()();
  TextColumn get zhTrad => text().named('zh_trad').nullable()();
  TextColumn get jaKanji => text().named('ja_kanji').nullable()();
  TextColumn get meaningKo => text().named('meaning_ko')();
  IntColumn get freqRank => integer().named('freq_rank').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// =============================================================================
// Database
// =============================================================================

@DriftDatabase(
  tables: [
    Scenarios,
    Turns,
    Annotations,
    Vocab,
    Particles,
    UserProgress,
    AppMeta,
    Hanja,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(hanja);
          }
        },
      );

  Future<String?> getMeta(String key) async {
    final row = await (select(appMeta)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setMeta(String key, String? value) async {
    await into(appMeta).insertOnConflictUpdate(
      AppMetaCompanion(
        key: Value(key),
        value: Value(value),
      ),
    );
  }
}

QueryExecutor _openConnection() => driftDatabase(name: 'k_universe');
