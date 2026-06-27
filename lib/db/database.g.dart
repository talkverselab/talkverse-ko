// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ScenariosTable extends Scenarios
    with TableInfo<$ScenariosTable, Scenario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScenariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleEnMeta = const VerificationMeta(
    'titleEn',
  );
  @override
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
    'title_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingEnMeta = const VerificationMeta(
    'settingEn',
  );
  @override
  late final GeneratedColumn<String> settingEn = GeneratedColumn<String>(
    'setting_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryEnMeta = const VerificationMeta(
    'summaryEn',
  );
  @override
  late final GeneratedColumn<String> summaryEn = GeneratedColumn<String>(
    'summary_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _turnCountMeta = const VerificationMeta(
    'turnCount',
  );
  @override
  late final GeneratedColumn<int> turnCount = GeneratedColumn<int>(
    'turn_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceRefMeta = const VerificationMeta(
    'sourceRef',
  );
  @override
  late final GeneratedColumn<String> sourceRef = GeneratedColumn<String>(
    'source_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titleEn,
    settingEn,
    summaryEn,
    difficulty,
    turnCount,
    source,
    sourceRef,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scenarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Scenario> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title_en')) {
      context.handle(
        _titleEnMeta,
        titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta),
      );
    } else if (isInserting) {
      context.missing(_titleEnMeta);
    }
    if (data.containsKey('setting_en')) {
      context.handle(
        _settingEnMeta,
        settingEn.isAcceptableOrUnknown(data['setting_en']!, _settingEnMeta),
      );
    } else if (isInserting) {
      context.missing(_settingEnMeta);
    }
    if (data.containsKey('summary_en')) {
      context.handle(
        _summaryEnMeta,
        summaryEn.isAcceptableOrUnknown(data['summary_en']!, _summaryEnMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryEnMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('turn_count')) {
      context.handle(
        _turnCountMeta,
        turnCount.isAcceptableOrUnknown(data['turn_count']!, _turnCountMeta),
      );
    } else if (isInserting) {
      context.missing(_turnCountMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('source_ref')) {
      context.handle(
        _sourceRefMeta,
        sourceRef.isAcceptableOrUnknown(data['source_ref']!, _sourceRefMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Scenario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Scenario(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      titleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_en'],
      )!,
      settingEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_en'],
      )!,
      summaryEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_en'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      turnCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}turn_count'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_ref'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ScenariosTable createAlias(String alias) {
    return $ScenariosTable(attachedDatabase, alias);
  }
}

class Scenario extends DataClass implements Insertable<Scenario> {
  final String id;
  final String titleEn;
  final String settingEn;
  final String summaryEn;
  final int difficulty;
  final int turnCount;
  final String source;
  final String? sourceRef;
  final DateTime createdAt;
  const Scenario({
    required this.id,
    required this.titleEn,
    required this.settingEn,
    required this.summaryEn,
    required this.difficulty,
    required this.turnCount,
    required this.source,
    this.sourceRef,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title_en'] = Variable<String>(titleEn);
    map['setting_en'] = Variable<String>(settingEn);
    map['summary_en'] = Variable<String>(summaryEn);
    map['difficulty'] = Variable<int>(difficulty);
    map['turn_count'] = Variable<int>(turnCount);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || sourceRef != null) {
      map['source_ref'] = Variable<String>(sourceRef);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScenariosCompanion toCompanion(bool nullToAbsent) {
    return ScenariosCompanion(
      id: Value(id),
      titleEn: Value(titleEn),
      settingEn: Value(settingEn),
      summaryEn: Value(summaryEn),
      difficulty: Value(difficulty),
      turnCount: Value(turnCount),
      source: Value(source),
      sourceRef: sourceRef == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceRef),
      createdAt: Value(createdAt),
    );
  }

  factory Scenario.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Scenario(
      id: serializer.fromJson<String>(json['id']),
      titleEn: serializer.fromJson<String>(json['titleEn']),
      settingEn: serializer.fromJson<String>(json['settingEn']),
      summaryEn: serializer.fromJson<String>(json['summaryEn']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      turnCount: serializer.fromJson<int>(json['turnCount']),
      source: serializer.fromJson<String>(json['source']),
      sourceRef: serializer.fromJson<String?>(json['sourceRef']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'titleEn': serializer.toJson<String>(titleEn),
      'settingEn': serializer.toJson<String>(settingEn),
      'summaryEn': serializer.toJson<String>(summaryEn),
      'difficulty': serializer.toJson<int>(difficulty),
      'turnCount': serializer.toJson<int>(turnCount),
      'source': serializer.toJson<String>(source),
      'sourceRef': serializer.toJson<String?>(sourceRef),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Scenario copyWith({
    String? id,
    String? titleEn,
    String? settingEn,
    String? summaryEn,
    int? difficulty,
    int? turnCount,
    String? source,
    Value<String?> sourceRef = const Value.absent(),
    DateTime? createdAt,
  }) => Scenario(
    id: id ?? this.id,
    titleEn: titleEn ?? this.titleEn,
    settingEn: settingEn ?? this.settingEn,
    summaryEn: summaryEn ?? this.summaryEn,
    difficulty: difficulty ?? this.difficulty,
    turnCount: turnCount ?? this.turnCount,
    source: source ?? this.source,
    sourceRef: sourceRef.present ? sourceRef.value : this.sourceRef,
    createdAt: createdAt ?? this.createdAt,
  );
  Scenario copyWithCompanion(ScenariosCompanion data) {
    return Scenario(
      id: data.id.present ? data.id.value : this.id,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      settingEn: data.settingEn.present ? data.settingEn.value : this.settingEn,
      summaryEn: data.summaryEn.present ? data.summaryEn.value : this.summaryEn,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      turnCount: data.turnCount.present ? data.turnCount.value : this.turnCount,
      source: data.source.present ? data.source.value : this.source,
      sourceRef: data.sourceRef.present ? data.sourceRef.value : this.sourceRef,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Scenario(')
          ..write('id: $id, ')
          ..write('titleEn: $titleEn, ')
          ..write('settingEn: $settingEn, ')
          ..write('summaryEn: $summaryEn, ')
          ..write('difficulty: $difficulty, ')
          ..write('turnCount: $turnCount, ')
          ..write('source: $source, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    titleEn,
    settingEn,
    summaryEn,
    difficulty,
    turnCount,
    source,
    sourceRef,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Scenario &&
          other.id == this.id &&
          other.titleEn == this.titleEn &&
          other.settingEn == this.settingEn &&
          other.summaryEn == this.summaryEn &&
          other.difficulty == this.difficulty &&
          other.turnCount == this.turnCount &&
          other.source == this.source &&
          other.sourceRef == this.sourceRef &&
          other.createdAt == this.createdAt);
}

class ScenariosCompanion extends UpdateCompanion<Scenario> {
  final Value<String> id;
  final Value<String> titleEn;
  final Value<String> settingEn;
  final Value<String> summaryEn;
  final Value<int> difficulty;
  final Value<int> turnCount;
  final Value<String> source;
  final Value<String?> sourceRef;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ScenariosCompanion({
    this.id = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.settingEn = const Value.absent(),
    this.summaryEn = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.turnCount = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceRef = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScenariosCompanion.insert({
    required String id,
    required String titleEn,
    required String settingEn,
    required String summaryEn,
    this.difficulty = const Value.absent(),
    required int turnCount,
    required String source,
    this.sourceRef = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       titleEn = Value(titleEn),
       settingEn = Value(settingEn),
       summaryEn = Value(summaryEn),
       turnCount = Value(turnCount),
       source = Value(source),
       createdAt = Value(createdAt);
  static Insertable<Scenario> custom({
    Expression<String>? id,
    Expression<String>? titleEn,
    Expression<String>? settingEn,
    Expression<String>? summaryEn,
    Expression<int>? difficulty,
    Expression<int>? turnCount,
    Expression<String>? source,
    Expression<String>? sourceRef,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titleEn != null) 'title_en': titleEn,
      if (settingEn != null) 'setting_en': settingEn,
      if (summaryEn != null) 'summary_en': summaryEn,
      if (difficulty != null) 'difficulty': difficulty,
      if (turnCount != null) 'turn_count': turnCount,
      if (source != null) 'source': source,
      if (sourceRef != null) 'source_ref': sourceRef,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScenariosCompanion copyWith({
    Value<String>? id,
    Value<String>? titleEn,
    Value<String>? settingEn,
    Value<String>? summaryEn,
    Value<int>? difficulty,
    Value<int>? turnCount,
    Value<String>? source,
    Value<String?>? sourceRef,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ScenariosCompanion(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      settingEn: settingEn ?? this.settingEn,
      summaryEn: summaryEn ?? this.summaryEn,
      difficulty: difficulty ?? this.difficulty,
      turnCount: turnCount ?? this.turnCount,
      source: source ?? this.source,
      sourceRef: sourceRef ?? this.sourceRef,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (settingEn.present) {
      map['setting_en'] = Variable<String>(settingEn.value);
    }
    if (summaryEn.present) {
      map['summary_en'] = Variable<String>(summaryEn.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (turnCount.present) {
      map['turn_count'] = Variable<int>(turnCount.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceRef.present) {
      map['source_ref'] = Variable<String>(sourceRef.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScenariosCompanion(')
          ..write('id: $id, ')
          ..write('titleEn: $titleEn, ')
          ..write('settingEn: $settingEn, ')
          ..write('summaryEn: $summaryEn, ')
          ..write('difficulty: $difficulty, ')
          ..write('turnCount: $turnCount, ')
          ..write('source: $source, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TurnsTable extends Turns with TableInfo<$TurnsTable, Turn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TurnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _scenarioIdMeta = const VerificationMeta(
    'scenarioId',
  );
  @override
  late final GeneratedColumn<String> scenarioId = GeneratedColumn<String>(
    'scenario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES scenarios (id)',
    ),
  );
  static const VerificationMeta _turnOrderMeta = const VerificationMeta(
    'turnOrder',
  );
  @override
  late final GeneratedColumn<int> turnOrder = GeneratedColumn<int>(
    'turn_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speakerMeta = const VerificationMeta(
    'speaker',
  );
  @override
  late final GeneratedColumn<String> speaker = GeneratedColumn<String>(
    'speaker',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _koTextMeta = const VerificationMeta('koText');
  @override
  late final GeneratedColumn<String> koText = GeneratedColumn<String>(
    'ko_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _romanizationMeta = const VerificationMeta(
    'romanization',
  );
  @override
  late final GeneratedColumn<String> romanization = GeneratedColumn<String>(
    'romanization',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enGlossMeta = const VerificationMeta(
    'enGloss',
  );
  @override
  late final GeneratedColumn<String> enGloss = GeneratedColumn<String>(
    'en_gloss',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _learnerNoteEnMeta = const VerificationMeta(
    'learnerNoteEn',
  );
  @override
  late final GeneratedColumn<String> learnerNoteEn = GeneratedColumn<String>(
    'learner_note_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scenarioId,
    turnOrder,
    speaker,
    koText,
    romanization,
    enGloss,
    learnerNoteEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'turns';
  @override
  VerificationContext validateIntegrity(
    Insertable<Turn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scenario_id')) {
      context.handle(
        _scenarioIdMeta,
        scenarioId.isAcceptableOrUnknown(data['scenario_id']!, _scenarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scenarioIdMeta);
    }
    if (data.containsKey('turn_order')) {
      context.handle(
        _turnOrderMeta,
        turnOrder.isAcceptableOrUnknown(data['turn_order']!, _turnOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_turnOrderMeta);
    }
    if (data.containsKey('speaker')) {
      context.handle(
        _speakerMeta,
        speaker.isAcceptableOrUnknown(data['speaker']!, _speakerMeta),
      );
    } else if (isInserting) {
      context.missing(_speakerMeta);
    }
    if (data.containsKey('ko_text')) {
      context.handle(
        _koTextMeta,
        koText.isAcceptableOrUnknown(data['ko_text']!, _koTextMeta),
      );
    } else if (isInserting) {
      context.missing(_koTextMeta);
    }
    if (data.containsKey('romanization')) {
      context.handle(
        _romanizationMeta,
        romanization.isAcceptableOrUnknown(
          data['romanization']!,
          _romanizationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_romanizationMeta);
    }
    if (data.containsKey('en_gloss')) {
      context.handle(
        _enGlossMeta,
        enGloss.isAcceptableOrUnknown(data['en_gloss']!, _enGlossMeta),
      );
    } else if (isInserting) {
      context.missing(_enGlossMeta);
    }
    if (data.containsKey('learner_note_en')) {
      context.handle(
        _learnerNoteEnMeta,
        learnerNoteEn.isAcceptableOrUnknown(
          data['learner_note_en']!,
          _learnerNoteEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {scenarioId, turnOrder},
  ];
  @override
  Turn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Turn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      scenarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scenario_id'],
      )!,
      turnOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}turn_order'],
      )!,
      speaker: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speaker'],
      )!,
      koText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ko_text'],
      )!,
      romanization: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}romanization'],
      )!,
      enGloss: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}en_gloss'],
      )!,
      learnerNoteEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learner_note_en'],
      ),
    );
  }

  @override
  $TurnsTable createAlias(String alias) {
    return $TurnsTable(attachedDatabase, alias);
  }
}

class Turn extends DataClass implements Insertable<Turn> {
  final int id;
  final String scenarioId;
  final int turnOrder;
  final String speaker;
  final String koText;
  final String romanization;
  final String enGloss;
  final String? learnerNoteEn;
  const Turn({
    required this.id,
    required this.scenarioId,
    required this.turnOrder,
    required this.speaker,
    required this.koText,
    required this.romanization,
    required this.enGloss,
    this.learnerNoteEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scenario_id'] = Variable<String>(scenarioId);
    map['turn_order'] = Variable<int>(turnOrder);
    map['speaker'] = Variable<String>(speaker);
    map['ko_text'] = Variable<String>(koText);
    map['romanization'] = Variable<String>(romanization);
    map['en_gloss'] = Variable<String>(enGloss);
    if (!nullToAbsent || learnerNoteEn != null) {
      map['learner_note_en'] = Variable<String>(learnerNoteEn);
    }
    return map;
  }

  TurnsCompanion toCompanion(bool nullToAbsent) {
    return TurnsCompanion(
      id: Value(id),
      scenarioId: Value(scenarioId),
      turnOrder: Value(turnOrder),
      speaker: Value(speaker),
      koText: Value(koText),
      romanization: Value(romanization),
      enGloss: Value(enGloss),
      learnerNoteEn: learnerNoteEn == null && nullToAbsent
          ? const Value.absent()
          : Value(learnerNoteEn),
    );
  }

  factory Turn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Turn(
      id: serializer.fromJson<int>(json['id']),
      scenarioId: serializer.fromJson<String>(json['scenarioId']),
      turnOrder: serializer.fromJson<int>(json['turnOrder']),
      speaker: serializer.fromJson<String>(json['speaker']),
      koText: serializer.fromJson<String>(json['koText']),
      romanization: serializer.fromJson<String>(json['romanization']),
      enGloss: serializer.fromJson<String>(json['enGloss']),
      learnerNoteEn: serializer.fromJson<String?>(json['learnerNoteEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scenarioId': serializer.toJson<String>(scenarioId),
      'turnOrder': serializer.toJson<int>(turnOrder),
      'speaker': serializer.toJson<String>(speaker),
      'koText': serializer.toJson<String>(koText),
      'romanization': serializer.toJson<String>(romanization),
      'enGloss': serializer.toJson<String>(enGloss),
      'learnerNoteEn': serializer.toJson<String?>(learnerNoteEn),
    };
  }

  Turn copyWith({
    int? id,
    String? scenarioId,
    int? turnOrder,
    String? speaker,
    String? koText,
    String? romanization,
    String? enGloss,
    Value<String?> learnerNoteEn = const Value.absent(),
  }) => Turn(
    id: id ?? this.id,
    scenarioId: scenarioId ?? this.scenarioId,
    turnOrder: turnOrder ?? this.turnOrder,
    speaker: speaker ?? this.speaker,
    koText: koText ?? this.koText,
    romanization: romanization ?? this.romanization,
    enGloss: enGloss ?? this.enGloss,
    learnerNoteEn: learnerNoteEn.present
        ? learnerNoteEn.value
        : this.learnerNoteEn,
  );
  Turn copyWithCompanion(TurnsCompanion data) {
    return Turn(
      id: data.id.present ? data.id.value : this.id,
      scenarioId: data.scenarioId.present
          ? data.scenarioId.value
          : this.scenarioId,
      turnOrder: data.turnOrder.present ? data.turnOrder.value : this.turnOrder,
      speaker: data.speaker.present ? data.speaker.value : this.speaker,
      koText: data.koText.present ? data.koText.value : this.koText,
      romanization: data.romanization.present
          ? data.romanization.value
          : this.romanization,
      enGloss: data.enGloss.present ? data.enGloss.value : this.enGloss,
      learnerNoteEn: data.learnerNoteEn.present
          ? data.learnerNoteEn.value
          : this.learnerNoteEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Turn(')
          ..write('id: $id, ')
          ..write('scenarioId: $scenarioId, ')
          ..write('turnOrder: $turnOrder, ')
          ..write('speaker: $speaker, ')
          ..write('koText: $koText, ')
          ..write('romanization: $romanization, ')
          ..write('enGloss: $enGloss, ')
          ..write('learnerNoteEn: $learnerNoteEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scenarioId,
    turnOrder,
    speaker,
    koText,
    romanization,
    enGloss,
    learnerNoteEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Turn &&
          other.id == this.id &&
          other.scenarioId == this.scenarioId &&
          other.turnOrder == this.turnOrder &&
          other.speaker == this.speaker &&
          other.koText == this.koText &&
          other.romanization == this.romanization &&
          other.enGloss == this.enGloss &&
          other.learnerNoteEn == this.learnerNoteEn);
}

class TurnsCompanion extends UpdateCompanion<Turn> {
  final Value<int> id;
  final Value<String> scenarioId;
  final Value<int> turnOrder;
  final Value<String> speaker;
  final Value<String> koText;
  final Value<String> romanization;
  final Value<String> enGloss;
  final Value<String?> learnerNoteEn;
  const TurnsCompanion({
    this.id = const Value.absent(),
    this.scenarioId = const Value.absent(),
    this.turnOrder = const Value.absent(),
    this.speaker = const Value.absent(),
    this.koText = const Value.absent(),
    this.romanization = const Value.absent(),
    this.enGloss = const Value.absent(),
    this.learnerNoteEn = const Value.absent(),
  });
  TurnsCompanion.insert({
    this.id = const Value.absent(),
    required String scenarioId,
    required int turnOrder,
    required String speaker,
    required String koText,
    required String romanization,
    required String enGloss,
    this.learnerNoteEn = const Value.absent(),
  }) : scenarioId = Value(scenarioId),
       turnOrder = Value(turnOrder),
       speaker = Value(speaker),
       koText = Value(koText),
       romanization = Value(romanization),
       enGloss = Value(enGloss);
  static Insertable<Turn> custom({
    Expression<int>? id,
    Expression<String>? scenarioId,
    Expression<int>? turnOrder,
    Expression<String>? speaker,
    Expression<String>? koText,
    Expression<String>? romanization,
    Expression<String>? enGloss,
    Expression<String>? learnerNoteEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scenarioId != null) 'scenario_id': scenarioId,
      if (turnOrder != null) 'turn_order': turnOrder,
      if (speaker != null) 'speaker': speaker,
      if (koText != null) 'ko_text': koText,
      if (romanization != null) 'romanization': romanization,
      if (enGloss != null) 'en_gloss': enGloss,
      if (learnerNoteEn != null) 'learner_note_en': learnerNoteEn,
    });
  }

  TurnsCompanion copyWith({
    Value<int>? id,
    Value<String>? scenarioId,
    Value<int>? turnOrder,
    Value<String>? speaker,
    Value<String>? koText,
    Value<String>? romanization,
    Value<String>? enGloss,
    Value<String?>? learnerNoteEn,
  }) {
    return TurnsCompanion(
      id: id ?? this.id,
      scenarioId: scenarioId ?? this.scenarioId,
      turnOrder: turnOrder ?? this.turnOrder,
      speaker: speaker ?? this.speaker,
      koText: koText ?? this.koText,
      romanization: romanization ?? this.romanization,
      enGloss: enGloss ?? this.enGloss,
      learnerNoteEn: learnerNoteEn ?? this.learnerNoteEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scenarioId.present) {
      map['scenario_id'] = Variable<String>(scenarioId.value);
    }
    if (turnOrder.present) {
      map['turn_order'] = Variable<int>(turnOrder.value);
    }
    if (speaker.present) {
      map['speaker'] = Variable<String>(speaker.value);
    }
    if (koText.present) {
      map['ko_text'] = Variable<String>(koText.value);
    }
    if (romanization.present) {
      map['romanization'] = Variable<String>(romanization.value);
    }
    if (enGloss.present) {
      map['en_gloss'] = Variable<String>(enGloss.value);
    }
    if (learnerNoteEn.present) {
      map['learner_note_en'] = Variable<String>(learnerNoteEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TurnsCompanion(')
          ..write('id: $id, ')
          ..write('scenarioId: $scenarioId, ')
          ..write('turnOrder: $turnOrder, ')
          ..write('speaker: $speaker, ')
          ..write('koText: $koText, ')
          ..write('romanization: $romanization, ')
          ..write('enGloss: $enGloss, ')
          ..write('learnerNoteEn: $learnerNoteEn')
          ..write(')'))
        .toString();
  }
}

class $AnnotationsTable extends Annotations
    with TableInfo<$AnnotationsTable, Annotation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnnotationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _turnIdMeta = const VerificationMeta('turnId');
  @override
  late final GeneratedColumn<int> turnId = GeneratedColumn<int>(
    'turn_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES turns (id)',
    ),
  );
  static const VerificationMeta _startOffsetMeta = const VerificationMeta(
    'startOffset',
  );
  @override
  late final GeneratedColumn<int> startOffset = GeneratedColumn<int>(
    'start_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endOffsetMeta = const VerificationMeta(
    'endOffset',
  );
  @override
  late final GeneratedColumn<int> endOffset = GeneratedColumn<int>(
    'end_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _glossEnMeta = const VerificationMeta(
    'glossEn',
  );
  @override
  late final GeneratedColumn<String> glossEn = GeneratedColumn<String>(
    'gloss_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    turnId,
    startOffset,
    endOffset,
    kind,
    target,
    glossEn,
    color,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'annotations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Annotation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('turn_id')) {
      context.handle(
        _turnIdMeta,
        turnId.isAcceptableOrUnknown(data['turn_id']!, _turnIdMeta),
      );
    } else if (isInserting) {
      context.missing(_turnIdMeta);
    }
    if (data.containsKey('start_offset')) {
      context.handle(
        _startOffsetMeta,
        startOffset.isAcceptableOrUnknown(
          data['start_offset']!,
          _startOffsetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startOffsetMeta);
    }
    if (data.containsKey('end_offset')) {
      context.handle(
        _endOffsetMeta,
        endOffset.isAcceptableOrUnknown(data['end_offset']!, _endOffsetMeta),
      );
    } else if (isInserting) {
      context.missing(_endOffsetMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('gloss_en')) {
      context.handle(
        _glossEnMeta,
        glossEn.isAcceptableOrUnknown(data['gloss_en']!, _glossEnMeta),
      );
    } else if (isInserting) {
      context.missing(_glossEnMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Annotation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Annotation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      turnId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}turn_id'],
      )!,
      startOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_offset'],
      )!,
      endOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_offset'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target'],
      )!,
      glossEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gloss_en'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
    );
  }

  @override
  $AnnotationsTable createAlias(String alias) {
    return $AnnotationsTable(attachedDatabase, alias);
  }
}

class Annotation extends DataClass implements Insertable<Annotation> {
  final int id;
  final int turnId;
  final int startOffset;
  final int endOffset;
  final String kind;
  final String target;
  final String glossEn;
  final String? color;
  const Annotation({
    required this.id,
    required this.turnId,
    required this.startOffset,
    required this.endOffset,
    required this.kind,
    required this.target,
    required this.glossEn,
    this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['turn_id'] = Variable<int>(turnId);
    map['start_offset'] = Variable<int>(startOffset);
    map['end_offset'] = Variable<int>(endOffset);
    map['kind'] = Variable<String>(kind);
    map['target'] = Variable<String>(target);
    map['gloss_en'] = Variable<String>(glossEn);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    return map;
  }

  AnnotationsCompanion toCompanion(bool nullToAbsent) {
    return AnnotationsCompanion(
      id: Value(id),
      turnId: Value(turnId),
      startOffset: Value(startOffset),
      endOffset: Value(endOffset),
      kind: Value(kind),
      target: Value(target),
      glossEn: Value(glossEn),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
    );
  }

  factory Annotation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Annotation(
      id: serializer.fromJson<int>(json['id']),
      turnId: serializer.fromJson<int>(json['turnId']),
      startOffset: serializer.fromJson<int>(json['startOffset']),
      endOffset: serializer.fromJson<int>(json['endOffset']),
      kind: serializer.fromJson<String>(json['kind']),
      target: serializer.fromJson<String>(json['target']),
      glossEn: serializer.fromJson<String>(json['glossEn']),
      color: serializer.fromJson<String?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'turnId': serializer.toJson<int>(turnId),
      'startOffset': serializer.toJson<int>(startOffset),
      'endOffset': serializer.toJson<int>(endOffset),
      'kind': serializer.toJson<String>(kind),
      'target': serializer.toJson<String>(target),
      'glossEn': serializer.toJson<String>(glossEn),
      'color': serializer.toJson<String?>(color),
    };
  }

  Annotation copyWith({
    int? id,
    int? turnId,
    int? startOffset,
    int? endOffset,
    String? kind,
    String? target,
    String? glossEn,
    Value<String?> color = const Value.absent(),
  }) => Annotation(
    id: id ?? this.id,
    turnId: turnId ?? this.turnId,
    startOffset: startOffset ?? this.startOffset,
    endOffset: endOffset ?? this.endOffset,
    kind: kind ?? this.kind,
    target: target ?? this.target,
    glossEn: glossEn ?? this.glossEn,
    color: color.present ? color.value : this.color,
  );
  Annotation copyWithCompanion(AnnotationsCompanion data) {
    return Annotation(
      id: data.id.present ? data.id.value : this.id,
      turnId: data.turnId.present ? data.turnId.value : this.turnId,
      startOffset: data.startOffset.present
          ? data.startOffset.value
          : this.startOffset,
      endOffset: data.endOffset.present ? data.endOffset.value : this.endOffset,
      kind: data.kind.present ? data.kind.value : this.kind,
      target: data.target.present ? data.target.value : this.target,
      glossEn: data.glossEn.present ? data.glossEn.value : this.glossEn,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Annotation(')
          ..write('id: $id, ')
          ..write('turnId: $turnId, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('kind: $kind, ')
          ..write('target: $target, ')
          ..write('glossEn: $glossEn, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    turnId,
    startOffset,
    endOffset,
    kind,
    target,
    glossEn,
    color,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Annotation &&
          other.id == this.id &&
          other.turnId == this.turnId &&
          other.startOffset == this.startOffset &&
          other.endOffset == this.endOffset &&
          other.kind == this.kind &&
          other.target == this.target &&
          other.glossEn == this.glossEn &&
          other.color == this.color);
}

class AnnotationsCompanion extends UpdateCompanion<Annotation> {
  final Value<int> id;
  final Value<int> turnId;
  final Value<int> startOffset;
  final Value<int> endOffset;
  final Value<String> kind;
  final Value<String> target;
  final Value<String> glossEn;
  final Value<String?> color;
  const AnnotationsCompanion({
    this.id = const Value.absent(),
    this.turnId = const Value.absent(),
    this.startOffset = const Value.absent(),
    this.endOffset = const Value.absent(),
    this.kind = const Value.absent(),
    this.target = const Value.absent(),
    this.glossEn = const Value.absent(),
    this.color = const Value.absent(),
  });
  AnnotationsCompanion.insert({
    this.id = const Value.absent(),
    required int turnId,
    required int startOffset,
    required int endOffset,
    required String kind,
    required String target,
    required String glossEn,
    this.color = const Value.absent(),
  }) : turnId = Value(turnId),
       startOffset = Value(startOffset),
       endOffset = Value(endOffset),
       kind = Value(kind),
       target = Value(target),
       glossEn = Value(glossEn);
  static Insertable<Annotation> custom({
    Expression<int>? id,
    Expression<int>? turnId,
    Expression<int>? startOffset,
    Expression<int>? endOffset,
    Expression<String>? kind,
    Expression<String>? target,
    Expression<String>? glossEn,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (turnId != null) 'turn_id': turnId,
      if (startOffset != null) 'start_offset': startOffset,
      if (endOffset != null) 'end_offset': endOffset,
      if (kind != null) 'kind': kind,
      if (target != null) 'target': target,
      if (glossEn != null) 'gloss_en': glossEn,
      if (color != null) 'color': color,
    });
  }

  AnnotationsCompanion copyWith({
    Value<int>? id,
    Value<int>? turnId,
    Value<int>? startOffset,
    Value<int>? endOffset,
    Value<String>? kind,
    Value<String>? target,
    Value<String>? glossEn,
    Value<String?>? color,
  }) {
    return AnnotationsCompanion(
      id: id ?? this.id,
      turnId: turnId ?? this.turnId,
      startOffset: startOffset ?? this.startOffset,
      endOffset: endOffset ?? this.endOffset,
      kind: kind ?? this.kind,
      target: target ?? this.target,
      glossEn: glossEn ?? this.glossEn,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (turnId.present) {
      map['turn_id'] = Variable<int>(turnId.value);
    }
    if (startOffset.present) {
      map['start_offset'] = Variable<int>(startOffset.value);
    }
    if (endOffset.present) {
      map['end_offset'] = Variable<int>(endOffset.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (glossEn.present) {
      map['gloss_en'] = Variable<String>(glossEn.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnnotationsCompanion(')
          ..write('id: $id, ')
          ..write('turnId: $turnId, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('kind: $kind, ')
          ..write('target: $target, ')
          ..write('glossEn: $glossEn, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $VocabTable extends Vocab with TableInfo<$VocabTable, VocabEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _freqMeta = const VerificationMeta('freq');
  @override
  late final GeneratedColumn<double> freq = GeneratedColumn<double>(
    'freq',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cumPctMeta = const VerificationMeta('cumPct');
  @override
  late final GeneratedColumn<double> cumPct = GeneratedColumn<double>(
    'cum_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _glossEnMeta = const VerificationMeta(
    'glossEn',
  );
  @override
  late final GeneratedColumn<String> glossEn = GeneratedColumn<String>(
    'gloss_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<String> pos = GeneratedColumn<String>(
    'pos',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    word,
    rank,
    freq,
    cumPct,
    glossEn,
    pos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocab';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('freq')) {
      context.handle(
        _freqMeta,
        freq.isAcceptableOrUnknown(data['freq']!, _freqMeta),
      );
    }
    if (data.containsKey('cum_pct')) {
      context.handle(
        _cumPctMeta,
        cumPct.isAcceptableOrUnknown(data['cum_pct']!, _cumPctMeta),
      );
    }
    if (data.containsKey('gloss_en')) {
      context.handle(
        _glossEnMeta,
        glossEn.isAcceptableOrUnknown(data['gloss_en']!, _glossEnMeta),
      );
    }
    if (data.containsKey('pos')) {
      context.handle(
        _posMeta,
        pos.isAcceptableOrUnknown(data['pos']!, _posMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
      freq: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}freq'],
      ),
      cumPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cum_pct'],
      ),
      glossEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gloss_en'],
      ),
      pos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos'],
      ),
    );
  }

  @override
  $VocabTable createAlias(String alias) {
    return $VocabTable(attachedDatabase, alias);
  }
}

class VocabEntry extends DataClass implements Insertable<VocabEntry> {
  final int id;
  final String word;
  final int rank;
  final double? freq;
  final double? cumPct;
  final String? glossEn;
  final String? pos;
  const VocabEntry({
    required this.id,
    required this.word,
    required this.rank,
    this.freq,
    this.cumPct,
    this.glossEn,
    this.pos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word'] = Variable<String>(word);
    map['rank'] = Variable<int>(rank);
    if (!nullToAbsent || freq != null) {
      map['freq'] = Variable<double>(freq);
    }
    if (!nullToAbsent || cumPct != null) {
      map['cum_pct'] = Variable<double>(cumPct);
    }
    if (!nullToAbsent || glossEn != null) {
      map['gloss_en'] = Variable<String>(glossEn);
    }
    if (!nullToAbsent || pos != null) {
      map['pos'] = Variable<String>(pos);
    }
    return map;
  }

  VocabCompanion toCompanion(bool nullToAbsent) {
    return VocabCompanion(
      id: Value(id),
      word: Value(word),
      rank: Value(rank),
      freq: freq == null && nullToAbsent ? const Value.absent() : Value(freq),
      cumPct: cumPct == null && nullToAbsent
          ? const Value.absent()
          : Value(cumPct),
      glossEn: glossEn == null && nullToAbsent
          ? const Value.absent()
          : Value(glossEn),
      pos: pos == null && nullToAbsent ? const Value.absent() : Value(pos),
    );
  }

  factory VocabEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabEntry(
      id: serializer.fromJson<int>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      rank: serializer.fromJson<int>(json['rank']),
      freq: serializer.fromJson<double?>(json['freq']),
      cumPct: serializer.fromJson<double?>(json['cumPct']),
      glossEn: serializer.fromJson<String?>(json['glossEn']),
      pos: serializer.fromJson<String?>(json['pos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'word': serializer.toJson<String>(word),
      'rank': serializer.toJson<int>(rank),
      'freq': serializer.toJson<double?>(freq),
      'cumPct': serializer.toJson<double?>(cumPct),
      'glossEn': serializer.toJson<String?>(glossEn),
      'pos': serializer.toJson<String?>(pos),
    };
  }

  VocabEntry copyWith({
    int? id,
    String? word,
    int? rank,
    Value<double?> freq = const Value.absent(),
    Value<double?> cumPct = const Value.absent(),
    Value<String?> glossEn = const Value.absent(),
    Value<String?> pos = const Value.absent(),
  }) => VocabEntry(
    id: id ?? this.id,
    word: word ?? this.word,
    rank: rank ?? this.rank,
    freq: freq.present ? freq.value : this.freq,
    cumPct: cumPct.present ? cumPct.value : this.cumPct,
    glossEn: glossEn.present ? glossEn.value : this.glossEn,
    pos: pos.present ? pos.value : this.pos,
  );
  VocabEntry copyWithCompanion(VocabCompanion data) {
    return VocabEntry(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      rank: data.rank.present ? data.rank.value : this.rank,
      freq: data.freq.present ? data.freq.value : this.freq,
      cumPct: data.cumPct.present ? data.cumPct.value : this.cumPct,
      glossEn: data.glossEn.present ? data.glossEn.value : this.glossEn,
      pos: data.pos.present ? data.pos.value : this.pos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabEntry(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('rank: $rank, ')
          ..write('freq: $freq, ')
          ..write('cumPct: $cumPct, ')
          ..write('glossEn: $glossEn, ')
          ..write('pos: $pos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, word, rank, freq, cumPct, glossEn, pos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabEntry &&
          other.id == this.id &&
          other.word == this.word &&
          other.rank == this.rank &&
          other.freq == this.freq &&
          other.cumPct == this.cumPct &&
          other.glossEn == this.glossEn &&
          other.pos == this.pos);
}

class VocabCompanion extends UpdateCompanion<VocabEntry> {
  final Value<int> id;
  final Value<String> word;
  final Value<int> rank;
  final Value<double?> freq;
  final Value<double?> cumPct;
  final Value<String?> glossEn;
  final Value<String?> pos;
  const VocabCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.rank = const Value.absent(),
    this.freq = const Value.absent(),
    this.cumPct = const Value.absent(),
    this.glossEn = const Value.absent(),
    this.pos = const Value.absent(),
  });
  VocabCompanion.insert({
    this.id = const Value.absent(),
    required String word,
    required int rank,
    this.freq = const Value.absent(),
    this.cumPct = const Value.absent(),
    this.glossEn = const Value.absent(),
    this.pos = const Value.absent(),
  }) : word = Value(word),
       rank = Value(rank);
  static Insertable<VocabEntry> custom({
    Expression<int>? id,
    Expression<String>? word,
    Expression<int>? rank,
    Expression<double>? freq,
    Expression<double>? cumPct,
    Expression<String>? glossEn,
    Expression<String>? pos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (rank != null) 'rank': rank,
      if (freq != null) 'freq': freq,
      if (cumPct != null) 'cum_pct': cumPct,
      if (glossEn != null) 'gloss_en': glossEn,
      if (pos != null) 'pos': pos,
    });
  }

  VocabCompanion copyWith({
    Value<int>? id,
    Value<String>? word,
    Value<int>? rank,
    Value<double?>? freq,
    Value<double?>? cumPct,
    Value<String?>? glossEn,
    Value<String?>? pos,
  }) {
    return VocabCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      rank: rank ?? this.rank,
      freq: freq ?? this.freq,
      cumPct: cumPct ?? this.cumPct,
      glossEn: glossEn ?? this.glossEn,
      pos: pos ?? this.pos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (freq.present) {
      map['freq'] = Variable<double>(freq.value);
    }
    if (cumPct.present) {
      map['cum_pct'] = Variable<double>(cumPct.value);
    }
    if (glossEn.present) {
      map['gloss_en'] = Variable<String>(glossEn.value);
    }
    if (pos.present) {
      map['pos'] = Variable<String>(pos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('rank: $rank, ')
          ..write('freq: $freq, ')
          ..write('cumPct: $cumPct, ')
          ..write('glossEn: $glossEn, ')
          ..write('pos: $pos')
          ..write(')'))
        .toString();
  }
}

class $ParticlesTable extends Particles
    with TableInfo<$ParticlesTable, Particle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _morphMeta = const VerificationMeta('morph');
  @override
  late final GeneratedColumn<String> morph = GeneratedColumn<String>(
    'morph',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cumPctMeta = const VerificationMeta('cumPct');
  @override
  late final GeneratedColumn<double> cumPct = GeneratedColumn<double>(
    'cum_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _glossEnMeta = const VerificationMeta(
    'glossEn',
  );
  @override
  late final GeneratedColumn<String> glossEn = GeneratedColumn<String>(
    'gloss_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesEnMeta = const VerificationMeta(
    'notesEn',
  );
  @override
  late final GeneratedColumn<String> notesEn = GeneratedColumn<String>(
    'notes_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    morph,
    rank,
    cumPct,
    category,
    glossEn,
    notesEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'particles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Particle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('morph')) {
      context.handle(
        _morphMeta,
        morph.isAcceptableOrUnknown(data['morph']!, _morphMeta),
      );
    } else if (isInserting) {
      context.missing(_morphMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('cum_pct')) {
      context.handle(
        _cumPctMeta,
        cumPct.isAcceptableOrUnknown(data['cum_pct']!, _cumPctMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('gloss_en')) {
      context.handle(
        _glossEnMeta,
        glossEn.isAcceptableOrUnknown(data['gloss_en']!, _glossEnMeta),
      );
    } else if (isInserting) {
      context.missing(_glossEnMeta);
    }
    if (data.containsKey('notes_en')) {
      context.handle(
        _notesEnMeta,
        notesEn.isAcceptableOrUnknown(data['notes_en']!, _notesEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Particle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Particle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      morph: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}morph'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
      cumPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cum_pct'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      glossEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gloss_en'],
      )!,
      notesEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes_en'],
      ),
    );
  }

  @override
  $ParticlesTable createAlias(String alias) {
    return $ParticlesTable(attachedDatabase, alias);
  }
}

class Particle extends DataClass implements Insertable<Particle> {
  final int id;
  final String morph;
  final int rank;
  final double? cumPct;
  final String category;
  final String glossEn;
  final String? notesEn;
  const Particle({
    required this.id,
    required this.morph,
    required this.rank,
    this.cumPct,
    required this.category,
    required this.glossEn,
    this.notesEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['morph'] = Variable<String>(morph);
    map['rank'] = Variable<int>(rank);
    if (!nullToAbsent || cumPct != null) {
      map['cum_pct'] = Variable<double>(cumPct);
    }
    map['category'] = Variable<String>(category);
    map['gloss_en'] = Variable<String>(glossEn);
    if (!nullToAbsent || notesEn != null) {
      map['notes_en'] = Variable<String>(notesEn);
    }
    return map;
  }

  ParticlesCompanion toCompanion(bool nullToAbsent) {
    return ParticlesCompanion(
      id: Value(id),
      morph: Value(morph),
      rank: Value(rank),
      cumPct: cumPct == null && nullToAbsent
          ? const Value.absent()
          : Value(cumPct),
      category: Value(category),
      glossEn: Value(glossEn),
      notesEn: notesEn == null && nullToAbsent
          ? const Value.absent()
          : Value(notesEn),
    );
  }

  factory Particle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Particle(
      id: serializer.fromJson<int>(json['id']),
      morph: serializer.fromJson<String>(json['morph']),
      rank: serializer.fromJson<int>(json['rank']),
      cumPct: serializer.fromJson<double?>(json['cumPct']),
      category: serializer.fromJson<String>(json['category']),
      glossEn: serializer.fromJson<String>(json['glossEn']),
      notesEn: serializer.fromJson<String?>(json['notesEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'morph': serializer.toJson<String>(morph),
      'rank': serializer.toJson<int>(rank),
      'cumPct': serializer.toJson<double?>(cumPct),
      'category': serializer.toJson<String>(category),
      'glossEn': serializer.toJson<String>(glossEn),
      'notesEn': serializer.toJson<String?>(notesEn),
    };
  }

  Particle copyWith({
    int? id,
    String? morph,
    int? rank,
    Value<double?> cumPct = const Value.absent(),
    String? category,
    String? glossEn,
    Value<String?> notesEn = const Value.absent(),
  }) => Particle(
    id: id ?? this.id,
    morph: morph ?? this.morph,
    rank: rank ?? this.rank,
    cumPct: cumPct.present ? cumPct.value : this.cumPct,
    category: category ?? this.category,
    glossEn: glossEn ?? this.glossEn,
    notesEn: notesEn.present ? notesEn.value : this.notesEn,
  );
  Particle copyWithCompanion(ParticlesCompanion data) {
    return Particle(
      id: data.id.present ? data.id.value : this.id,
      morph: data.morph.present ? data.morph.value : this.morph,
      rank: data.rank.present ? data.rank.value : this.rank,
      cumPct: data.cumPct.present ? data.cumPct.value : this.cumPct,
      category: data.category.present ? data.category.value : this.category,
      glossEn: data.glossEn.present ? data.glossEn.value : this.glossEn,
      notesEn: data.notesEn.present ? data.notesEn.value : this.notesEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Particle(')
          ..write('id: $id, ')
          ..write('morph: $morph, ')
          ..write('rank: $rank, ')
          ..write('cumPct: $cumPct, ')
          ..write('category: $category, ')
          ..write('glossEn: $glossEn, ')
          ..write('notesEn: $notesEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, morph, rank, cumPct, category, glossEn, notesEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Particle &&
          other.id == this.id &&
          other.morph == this.morph &&
          other.rank == this.rank &&
          other.cumPct == this.cumPct &&
          other.category == this.category &&
          other.glossEn == this.glossEn &&
          other.notesEn == this.notesEn);
}

class ParticlesCompanion extends UpdateCompanion<Particle> {
  final Value<int> id;
  final Value<String> morph;
  final Value<int> rank;
  final Value<double?> cumPct;
  final Value<String> category;
  final Value<String> glossEn;
  final Value<String?> notesEn;
  const ParticlesCompanion({
    this.id = const Value.absent(),
    this.morph = const Value.absent(),
    this.rank = const Value.absent(),
    this.cumPct = const Value.absent(),
    this.category = const Value.absent(),
    this.glossEn = const Value.absent(),
    this.notesEn = const Value.absent(),
  });
  ParticlesCompanion.insert({
    this.id = const Value.absent(),
    required String morph,
    required int rank,
    this.cumPct = const Value.absent(),
    required String category,
    required String glossEn,
    this.notesEn = const Value.absent(),
  }) : morph = Value(morph),
       rank = Value(rank),
       category = Value(category),
       glossEn = Value(glossEn);
  static Insertable<Particle> custom({
    Expression<int>? id,
    Expression<String>? morph,
    Expression<int>? rank,
    Expression<double>? cumPct,
    Expression<String>? category,
    Expression<String>? glossEn,
    Expression<String>? notesEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (morph != null) 'morph': morph,
      if (rank != null) 'rank': rank,
      if (cumPct != null) 'cum_pct': cumPct,
      if (category != null) 'category': category,
      if (glossEn != null) 'gloss_en': glossEn,
      if (notesEn != null) 'notes_en': notesEn,
    });
  }

  ParticlesCompanion copyWith({
    Value<int>? id,
    Value<String>? morph,
    Value<int>? rank,
    Value<double?>? cumPct,
    Value<String>? category,
    Value<String>? glossEn,
    Value<String?>? notesEn,
  }) {
    return ParticlesCompanion(
      id: id ?? this.id,
      morph: morph ?? this.morph,
      rank: rank ?? this.rank,
      cumPct: cumPct ?? this.cumPct,
      category: category ?? this.category,
      glossEn: glossEn ?? this.glossEn,
      notesEn: notesEn ?? this.notesEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (morph.present) {
      map['morph'] = Variable<String>(morph.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (cumPct.present) {
      map['cum_pct'] = Variable<double>(cumPct.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (glossEn.present) {
      map['gloss_en'] = Variable<String>(glossEn.value);
    }
    if (notesEn.present) {
      map['notes_en'] = Variable<String>(notesEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParticlesCompanion(')
          ..write('id: $id, ')
          ..write('morph: $morph, ')
          ..write('rank: $rank, ')
          ..write('cumPct: $cumPct, ')
          ..write('category: $category, ')
          ..write('glossEn: $glossEn, ')
          ..write('notesEn: $notesEn')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTable extends UserProgress
    with TableInfo<$UserProgressTable, UserProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scenarioIdMeta = const VerificationMeta(
    'scenarioId',
  );
  @override
  late final GeneratedColumn<String> scenarioId = GeneratedColumn<String>(
    'scenario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES scenarios (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('not_started'),
  );
  static const VerificationMeta _lastTurnOrderMeta = const VerificationMeta(
    'lastTurnOrder',
  );
  @override
  late final GeneratedColumn<int> lastTurnOrder = GeneratedColumn<int>(
    'last_turn_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    scenarioId,
    status,
    lastTurnOrder,
    startedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scenario_id')) {
      context.handle(
        _scenarioIdMeta,
        scenarioId.isAcceptableOrUnknown(data['scenario_id']!, _scenarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scenarioIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('last_turn_order')) {
      context.handle(
        _lastTurnOrderMeta,
        lastTurnOrder.isAcceptableOrUnknown(
          data['last_turn_order']!,
          _lastTurnOrderMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scenarioId};
  @override
  UserProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressRow(
      scenarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scenario_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastTurnOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_turn_order'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $UserProgressTable createAlias(String alias) {
    return $UserProgressTable(attachedDatabase, alias);
  }
}

class UserProgressRow extends DataClass implements Insertable<UserProgressRow> {
  final String scenarioId;
  final String status;
  final int lastTurnOrder;
  final DateTime? startedAt;
  final DateTime? completedAt;
  const UserProgressRow({
    required this.scenarioId,
    required this.status,
    required this.lastTurnOrder,
    this.startedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scenario_id'] = Variable<String>(scenarioId);
    map['status'] = Variable<String>(status);
    map['last_turn_order'] = Variable<int>(lastTurnOrder);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  UserProgressCompanion toCompanion(bool nullToAbsent) {
    return UserProgressCompanion(
      scenarioId: Value(scenarioId),
      status: Value(status),
      lastTurnOrder: Value(lastTurnOrder),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory UserProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressRow(
      scenarioId: serializer.fromJson<String>(json['scenarioId']),
      status: serializer.fromJson<String>(json['status']),
      lastTurnOrder: serializer.fromJson<int>(json['lastTurnOrder']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scenarioId': serializer.toJson<String>(scenarioId),
      'status': serializer.toJson<String>(status),
      'lastTurnOrder': serializer.toJson<int>(lastTurnOrder),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  UserProgressRow copyWith({
    String? scenarioId,
    String? status,
    int? lastTurnOrder,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
  }) => UserProgressRow(
    scenarioId: scenarioId ?? this.scenarioId,
    status: status ?? this.status,
    lastTurnOrder: lastTurnOrder ?? this.lastTurnOrder,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  UserProgressRow copyWithCompanion(UserProgressCompanion data) {
    return UserProgressRow(
      scenarioId: data.scenarioId.present
          ? data.scenarioId.value
          : this.scenarioId,
      status: data.status.present ? data.status.value : this.status,
      lastTurnOrder: data.lastTurnOrder.present
          ? data.lastTurnOrder.value
          : this.lastTurnOrder,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressRow(')
          ..write('scenarioId: $scenarioId, ')
          ..write('status: $status, ')
          ..write('lastTurnOrder: $lastTurnOrder, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(scenarioId, status, lastTurnOrder, startedAt, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressRow &&
          other.scenarioId == this.scenarioId &&
          other.status == this.status &&
          other.lastTurnOrder == this.lastTurnOrder &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class UserProgressCompanion extends UpdateCompanion<UserProgressRow> {
  final Value<String> scenarioId;
  final Value<String> status;
  final Value<int> lastTurnOrder;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const UserProgressCompanion({
    this.scenarioId = const Value.absent(),
    this.status = const Value.absent(),
    this.lastTurnOrder = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProgressCompanion.insert({
    required String scenarioId,
    this.status = const Value.absent(),
    this.lastTurnOrder = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : scenarioId = Value(scenarioId);
  static Insertable<UserProgressRow> custom({
    Expression<String>? scenarioId,
    Expression<String>? status,
    Expression<int>? lastTurnOrder,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scenarioId != null) 'scenario_id': scenarioId,
      if (status != null) 'status': status,
      if (lastTurnOrder != null) 'last_turn_order': lastTurnOrder,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProgressCompanion copyWith({
    Value<String>? scenarioId,
    Value<String>? status,
    Value<int>? lastTurnOrder,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return UserProgressCompanion(
      scenarioId: scenarioId ?? this.scenarioId,
      status: status ?? this.status,
      lastTurnOrder: lastTurnOrder ?? this.lastTurnOrder,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scenarioId.present) {
      map['scenario_id'] = Variable<String>(scenarioId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastTurnOrder.present) {
      map['last_turn_order'] = Variable<int>(lastTurnOrder.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressCompanion(')
          ..write('scenarioId: $scenarioId, ')
          ..write('status: $status, ')
          ..write('lastTurnOrder: $lastTurnOrder, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppMetaTable extends AppMeta with TableInfo<$AppMetaTable, AppMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetaRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $AppMetaTable createAlias(String alias) {
    return $AppMetaTable(attachedDatabase, alias);
  }
}

class AppMetaRow extends DataClass implements Insertable<AppMetaRow> {
  final String key;
  final String? value;
  const AppMetaRow({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  AppMetaCompanion toCompanion(bool nullToAbsent) {
    return AppMetaCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory AppMetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetaRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  AppMetaRow copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
  }) => AppMetaRow(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
  );
  AppMetaRow copyWithCompanion(AppMetaCompanion data) {
    return AppMetaRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetaRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppMetaCompanion extends UpdateCompanion<AppMetaRow> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const AppMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetaCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<AppMetaRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetaCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<int>? rowid,
  }) {
    return AppMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HanjaTable extends Hanja with TableInfo<$HanjaTable, HanjaEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HanjaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _koHanjaMeta = const VerificationMeta(
    'koHanja',
  );
  @override
  late final GeneratedColumn<String> koHanja = GeneratedColumn<String>(
    'ko_hanja',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yumeumMeta = const VerificationMeta('yumeum');
  @override
  late final GeneratedColumn<String> yumeum = GeneratedColumn<String>(
    'yumeum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zhSimpMeta = const VerificationMeta('zhSimp');
  @override
  late final GeneratedColumn<String> zhSimp = GeneratedColumn<String>(
    'zh_simp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zhTradMeta = const VerificationMeta('zhTrad');
  @override
  late final GeneratedColumn<String> zhTrad = GeneratedColumn<String>(
    'zh_trad',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jaKanjiMeta = const VerificationMeta(
    'jaKanji',
  );
  @override
  late final GeneratedColumn<String> jaKanji = GeneratedColumn<String>(
    'ja_kanji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meaningKoMeta = const VerificationMeta(
    'meaningKo',
  );
  @override
  late final GeneratedColumn<String> meaningKo = GeneratedColumn<String>(
    'meaning_ko',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _freqRankMeta = const VerificationMeta(
    'freqRank',
  );
  @override
  late final GeneratedColumn<int> freqRank = GeneratedColumn<int>(
    'freq_rank',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    koHanja,
    yumeum,
    zhSimp,
    zhTrad,
    jaKanji,
    meaningKo,
    freqRank,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hanja';
  @override
  VerificationContext validateIntegrity(
    Insertable<HanjaEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ko_hanja')) {
      context.handle(
        _koHanjaMeta,
        koHanja.isAcceptableOrUnknown(data['ko_hanja']!, _koHanjaMeta),
      );
    } else if (isInserting) {
      context.missing(_koHanjaMeta);
    }
    if (data.containsKey('yumeum')) {
      context.handle(
        _yumeumMeta,
        yumeum.isAcceptableOrUnknown(data['yumeum']!, _yumeumMeta),
      );
    } else if (isInserting) {
      context.missing(_yumeumMeta);
    }
    if (data.containsKey('zh_simp')) {
      context.handle(
        _zhSimpMeta,
        zhSimp.isAcceptableOrUnknown(data['zh_simp']!, _zhSimpMeta),
      );
    }
    if (data.containsKey('zh_trad')) {
      context.handle(
        _zhTradMeta,
        zhTrad.isAcceptableOrUnknown(data['zh_trad']!, _zhTradMeta),
      );
    }
    if (data.containsKey('ja_kanji')) {
      context.handle(
        _jaKanjiMeta,
        jaKanji.isAcceptableOrUnknown(data['ja_kanji']!, _jaKanjiMeta),
      );
    }
    if (data.containsKey('meaning_ko')) {
      context.handle(
        _meaningKoMeta,
        meaningKo.isAcceptableOrUnknown(data['meaning_ko']!, _meaningKoMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningKoMeta);
    }
    if (data.containsKey('freq_rank')) {
      context.handle(
        _freqRankMeta,
        freqRank.isAcceptableOrUnknown(data['freq_rank']!, _freqRankMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HanjaEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HanjaEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      koHanja: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ko_hanja'],
      )!,
      yumeum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}yumeum'],
      )!,
      zhSimp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zh_simp'],
      ),
      zhTrad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zh_trad'],
      ),
      jaKanji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ja_kanji'],
      ),
      meaningKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_ko'],
      )!,
      freqRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}freq_rank'],
      ),
    );
  }

  @override
  $HanjaTable createAlias(String alias) {
    return $HanjaTable(attachedDatabase, alias);
  }
}

class HanjaEntry extends DataClass implements Insertable<HanjaEntry> {
  final String id;
  final String koHanja;
  final String yumeum;
  final String? zhSimp;
  final String? zhTrad;
  final String? jaKanji;
  final String meaningKo;
  final int? freqRank;
  const HanjaEntry({
    required this.id,
    required this.koHanja,
    required this.yumeum,
    this.zhSimp,
    this.zhTrad,
    this.jaKanji,
    required this.meaningKo,
    this.freqRank,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ko_hanja'] = Variable<String>(koHanja);
    map['yumeum'] = Variable<String>(yumeum);
    if (!nullToAbsent || zhSimp != null) {
      map['zh_simp'] = Variable<String>(zhSimp);
    }
    if (!nullToAbsent || zhTrad != null) {
      map['zh_trad'] = Variable<String>(zhTrad);
    }
    if (!nullToAbsent || jaKanji != null) {
      map['ja_kanji'] = Variable<String>(jaKanji);
    }
    map['meaning_ko'] = Variable<String>(meaningKo);
    if (!nullToAbsent || freqRank != null) {
      map['freq_rank'] = Variable<int>(freqRank);
    }
    return map;
  }

  HanjaCompanion toCompanion(bool nullToAbsent) {
    return HanjaCompanion(
      id: Value(id),
      koHanja: Value(koHanja),
      yumeum: Value(yumeum),
      zhSimp: zhSimp == null && nullToAbsent
          ? const Value.absent()
          : Value(zhSimp),
      zhTrad: zhTrad == null && nullToAbsent
          ? const Value.absent()
          : Value(zhTrad),
      jaKanji: jaKanji == null && nullToAbsent
          ? const Value.absent()
          : Value(jaKanji),
      meaningKo: Value(meaningKo),
      freqRank: freqRank == null && nullToAbsent
          ? const Value.absent()
          : Value(freqRank),
    );
  }

  factory HanjaEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HanjaEntry(
      id: serializer.fromJson<String>(json['id']),
      koHanja: serializer.fromJson<String>(json['koHanja']),
      yumeum: serializer.fromJson<String>(json['yumeum']),
      zhSimp: serializer.fromJson<String?>(json['zhSimp']),
      zhTrad: serializer.fromJson<String?>(json['zhTrad']),
      jaKanji: serializer.fromJson<String?>(json['jaKanji']),
      meaningKo: serializer.fromJson<String>(json['meaningKo']),
      freqRank: serializer.fromJson<int?>(json['freqRank']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'koHanja': serializer.toJson<String>(koHanja),
      'yumeum': serializer.toJson<String>(yumeum),
      'zhSimp': serializer.toJson<String?>(zhSimp),
      'zhTrad': serializer.toJson<String?>(zhTrad),
      'jaKanji': serializer.toJson<String?>(jaKanji),
      'meaningKo': serializer.toJson<String>(meaningKo),
      'freqRank': serializer.toJson<int?>(freqRank),
    };
  }

  HanjaEntry copyWith({
    String? id,
    String? koHanja,
    String? yumeum,
    Value<String?> zhSimp = const Value.absent(),
    Value<String?> zhTrad = const Value.absent(),
    Value<String?> jaKanji = const Value.absent(),
    String? meaningKo,
    Value<int?> freqRank = const Value.absent(),
  }) => HanjaEntry(
    id: id ?? this.id,
    koHanja: koHanja ?? this.koHanja,
    yumeum: yumeum ?? this.yumeum,
    zhSimp: zhSimp.present ? zhSimp.value : this.zhSimp,
    zhTrad: zhTrad.present ? zhTrad.value : this.zhTrad,
    jaKanji: jaKanji.present ? jaKanji.value : this.jaKanji,
    meaningKo: meaningKo ?? this.meaningKo,
    freqRank: freqRank.present ? freqRank.value : this.freqRank,
  );
  HanjaEntry copyWithCompanion(HanjaCompanion data) {
    return HanjaEntry(
      id: data.id.present ? data.id.value : this.id,
      koHanja: data.koHanja.present ? data.koHanja.value : this.koHanja,
      yumeum: data.yumeum.present ? data.yumeum.value : this.yumeum,
      zhSimp: data.zhSimp.present ? data.zhSimp.value : this.zhSimp,
      zhTrad: data.zhTrad.present ? data.zhTrad.value : this.zhTrad,
      jaKanji: data.jaKanji.present ? data.jaKanji.value : this.jaKanji,
      meaningKo: data.meaningKo.present ? data.meaningKo.value : this.meaningKo,
      freqRank: data.freqRank.present ? data.freqRank.value : this.freqRank,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HanjaEntry(')
          ..write('id: $id, ')
          ..write('koHanja: $koHanja, ')
          ..write('yumeum: $yumeum, ')
          ..write('zhSimp: $zhSimp, ')
          ..write('zhTrad: $zhTrad, ')
          ..write('jaKanji: $jaKanji, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('freqRank: $freqRank')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    koHanja,
    yumeum,
    zhSimp,
    zhTrad,
    jaKanji,
    meaningKo,
    freqRank,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HanjaEntry &&
          other.id == this.id &&
          other.koHanja == this.koHanja &&
          other.yumeum == this.yumeum &&
          other.zhSimp == this.zhSimp &&
          other.zhTrad == this.zhTrad &&
          other.jaKanji == this.jaKanji &&
          other.meaningKo == this.meaningKo &&
          other.freqRank == this.freqRank);
}

class HanjaCompanion extends UpdateCompanion<HanjaEntry> {
  final Value<String> id;
  final Value<String> koHanja;
  final Value<String> yumeum;
  final Value<String?> zhSimp;
  final Value<String?> zhTrad;
  final Value<String?> jaKanji;
  final Value<String> meaningKo;
  final Value<int?> freqRank;
  final Value<int> rowid;
  const HanjaCompanion({
    this.id = const Value.absent(),
    this.koHanja = const Value.absent(),
    this.yumeum = const Value.absent(),
    this.zhSimp = const Value.absent(),
    this.zhTrad = const Value.absent(),
    this.jaKanji = const Value.absent(),
    this.meaningKo = const Value.absent(),
    this.freqRank = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HanjaCompanion.insert({
    required String id,
    required String koHanja,
    required String yumeum,
    this.zhSimp = const Value.absent(),
    this.zhTrad = const Value.absent(),
    this.jaKanji = const Value.absent(),
    required String meaningKo,
    this.freqRank = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       koHanja = Value(koHanja),
       yumeum = Value(yumeum),
       meaningKo = Value(meaningKo);
  static Insertable<HanjaEntry> custom({
    Expression<String>? id,
    Expression<String>? koHanja,
    Expression<String>? yumeum,
    Expression<String>? zhSimp,
    Expression<String>? zhTrad,
    Expression<String>? jaKanji,
    Expression<String>? meaningKo,
    Expression<int>? freqRank,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (koHanja != null) 'ko_hanja': koHanja,
      if (yumeum != null) 'yumeum': yumeum,
      if (zhSimp != null) 'zh_simp': zhSimp,
      if (zhTrad != null) 'zh_trad': zhTrad,
      if (jaKanji != null) 'ja_kanji': jaKanji,
      if (meaningKo != null) 'meaning_ko': meaningKo,
      if (freqRank != null) 'freq_rank': freqRank,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HanjaCompanion copyWith({
    Value<String>? id,
    Value<String>? koHanja,
    Value<String>? yumeum,
    Value<String?>? zhSimp,
    Value<String?>? zhTrad,
    Value<String?>? jaKanji,
    Value<String>? meaningKo,
    Value<int?>? freqRank,
    Value<int>? rowid,
  }) {
    return HanjaCompanion(
      id: id ?? this.id,
      koHanja: koHanja ?? this.koHanja,
      yumeum: yumeum ?? this.yumeum,
      zhSimp: zhSimp ?? this.zhSimp,
      zhTrad: zhTrad ?? this.zhTrad,
      jaKanji: jaKanji ?? this.jaKanji,
      meaningKo: meaningKo ?? this.meaningKo,
      freqRank: freqRank ?? this.freqRank,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (koHanja.present) {
      map['ko_hanja'] = Variable<String>(koHanja.value);
    }
    if (yumeum.present) {
      map['yumeum'] = Variable<String>(yumeum.value);
    }
    if (zhSimp.present) {
      map['zh_simp'] = Variable<String>(zhSimp.value);
    }
    if (zhTrad.present) {
      map['zh_trad'] = Variable<String>(zhTrad.value);
    }
    if (jaKanji.present) {
      map['ja_kanji'] = Variable<String>(jaKanji.value);
    }
    if (meaningKo.present) {
      map['meaning_ko'] = Variable<String>(meaningKo.value);
    }
    if (freqRank.present) {
      map['freq_rank'] = Variable<int>(freqRank.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HanjaCompanion(')
          ..write('id: $id, ')
          ..write('koHanja: $koHanja, ')
          ..write('yumeum: $yumeum, ')
          ..write('zhSimp: $zhSimp, ')
          ..write('zhTrad: $zhTrad, ')
          ..write('jaKanji: $jaKanji, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('freqRank: $freqRank, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScenariosTable scenarios = $ScenariosTable(this);
  late final $TurnsTable turns = $TurnsTable(this);
  late final $AnnotationsTable annotations = $AnnotationsTable(this);
  late final $VocabTable vocab = $VocabTable(this);
  late final $ParticlesTable particles = $ParticlesTable(this);
  late final $UserProgressTable userProgress = $UserProgressTable(this);
  late final $AppMetaTable appMeta = $AppMetaTable(this);
  late final $HanjaTable hanja = $HanjaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    scenarios,
    turns,
    annotations,
    vocab,
    particles,
    userProgress,
    appMeta,
    hanja,
  ];
}

typedef $$ScenariosTableCreateCompanionBuilder =
    ScenariosCompanion Function({
      required String id,
      required String titleEn,
      required String settingEn,
      required String summaryEn,
      Value<int> difficulty,
      required int turnCount,
      required String source,
      Value<String?> sourceRef,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ScenariosTableUpdateCompanionBuilder =
    ScenariosCompanion Function({
      Value<String> id,
      Value<String> titleEn,
      Value<String> settingEn,
      Value<String> summaryEn,
      Value<int> difficulty,
      Value<int> turnCount,
      Value<String> source,
      Value<String?> sourceRef,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ScenariosTableReferences
    extends BaseReferences<_$AppDatabase, $ScenariosTable, Scenario> {
  $$ScenariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TurnsTable, List<Turn>> _turnsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.turns,
    aliasName: $_aliasNameGenerator(db.scenarios.id, db.turns.scenarioId),
  );

  $$TurnsTableProcessedTableManager get turnsRefs {
    final manager = $$TurnsTableTableManager(
      $_db,
      $_db.turns,
    ).filter((f) => f.scenarioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_turnsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UserProgressTable, List<UserProgressRow>>
  _userProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userProgress,
    aliasName: $_aliasNameGenerator(
      db.scenarios.id,
      db.userProgress.scenarioId,
    ),
  );

  $$UserProgressTableProcessedTableManager get userProgressRefs {
    final manager = $$UserProgressTableTableManager(
      $_db,
      $_db.userProgress,
    ).filter((f) => f.scenarioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_userProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ScenariosTableFilterComposer
    extends Composer<_$AppDatabase, $ScenariosTable> {
  $$ScenariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingEn => $composableBuilder(
    column: $table.settingEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryEn => $composableBuilder(
    column: $table.summaryEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get turnCount => $composableBuilder(
    column: $table.turnCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceRef => $composableBuilder(
    column: $table.sourceRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> turnsRefs(
    Expression<bool> Function($$TurnsTableFilterComposer f) f,
  ) {
    final $$TurnsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.turns,
      getReferencedColumn: (t) => t.scenarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurnsTableFilterComposer(
            $db: $db,
            $table: $db.turns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userProgressRefs(
    Expression<bool> Function($$UserProgressTableFilterComposer f) f,
  ) {
    final $$UserProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userProgress,
      getReferencedColumn: (t) => t.scenarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProgressTableFilterComposer(
            $db: $db,
            $table: $db.userProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScenariosTableOrderingComposer
    extends Composer<_$AppDatabase, $ScenariosTable> {
  $$ScenariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingEn => $composableBuilder(
    column: $table.settingEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryEn => $composableBuilder(
    column: $table.summaryEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get turnCount => $composableBuilder(
    column: $table.turnCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceRef => $composableBuilder(
    column: $table.sourceRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScenariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScenariosTable> {
  $$ScenariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<String> get settingEn =>
      $composableBuilder(column: $table.settingEn, builder: (column) => column);

  GeneratedColumn<String> get summaryEn =>
      $composableBuilder(column: $table.summaryEn, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get turnCount =>
      $composableBuilder(column: $table.turnCount, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get sourceRef =>
      $composableBuilder(column: $table.sourceRef, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> turnsRefs<T extends Object>(
    Expression<T> Function($$TurnsTableAnnotationComposer a) f,
  ) {
    final $$TurnsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.turns,
      getReferencedColumn: (t) => t.scenarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurnsTableAnnotationComposer(
            $db: $db,
            $table: $db.turns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userProgressRefs<T extends Object>(
    Expression<T> Function($$UserProgressTableAnnotationComposer a) f,
  ) {
    final $$UserProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userProgress,
      getReferencedColumn: (t) => t.scenarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.userProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScenariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScenariosTable,
          Scenario,
          $$ScenariosTableFilterComposer,
          $$ScenariosTableOrderingComposer,
          $$ScenariosTableAnnotationComposer,
          $$ScenariosTableCreateCompanionBuilder,
          $$ScenariosTableUpdateCompanionBuilder,
          (Scenario, $$ScenariosTableReferences),
          Scenario,
          PrefetchHooks Function({bool turnsRefs, bool userProgressRefs})
        > {
  $$ScenariosTableTableManager(_$AppDatabase db, $ScenariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScenariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScenariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScenariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> titleEn = const Value.absent(),
                Value<String> settingEn = const Value.absent(),
                Value<String> summaryEn = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<int> turnCount = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> sourceRef = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScenariosCompanion(
                id: id,
                titleEn: titleEn,
                settingEn: settingEn,
                summaryEn: summaryEn,
                difficulty: difficulty,
                turnCount: turnCount,
                source: source,
                sourceRef: sourceRef,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String titleEn,
                required String settingEn,
                required String summaryEn,
                Value<int> difficulty = const Value.absent(),
                required int turnCount,
                required String source,
                Value<String?> sourceRef = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ScenariosCompanion.insert(
                id: id,
                titleEn: titleEn,
                settingEn: settingEn,
                summaryEn: summaryEn,
                difficulty: difficulty,
                turnCount: turnCount,
                source: source,
                sourceRef: sourceRef,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ScenariosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({turnsRefs = false, userProgressRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (turnsRefs) db.turns,
                    if (userProgressRefs) db.userProgress,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (turnsRefs)
                        await $_getPrefetchedData<
                          Scenario,
                          $ScenariosTable,
                          Turn
                        >(
                          currentTable: table,
                          referencedTable: $$ScenariosTableReferences
                              ._turnsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ScenariosTableReferences(
                                db,
                                table,
                                p0,
                              ).turnsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.scenarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userProgressRefs)
                        await $_getPrefetchedData<
                          Scenario,
                          $ScenariosTable,
                          UserProgressRow
                        >(
                          currentTable: table,
                          referencedTable: $$ScenariosTableReferences
                              ._userProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ScenariosTableReferences(
                                db,
                                table,
                                p0,
                              ).userProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.scenarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ScenariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScenariosTable,
      Scenario,
      $$ScenariosTableFilterComposer,
      $$ScenariosTableOrderingComposer,
      $$ScenariosTableAnnotationComposer,
      $$ScenariosTableCreateCompanionBuilder,
      $$ScenariosTableUpdateCompanionBuilder,
      (Scenario, $$ScenariosTableReferences),
      Scenario,
      PrefetchHooks Function({bool turnsRefs, bool userProgressRefs})
    >;
typedef $$TurnsTableCreateCompanionBuilder =
    TurnsCompanion Function({
      Value<int> id,
      required String scenarioId,
      required int turnOrder,
      required String speaker,
      required String koText,
      required String romanization,
      required String enGloss,
      Value<String?> learnerNoteEn,
    });
typedef $$TurnsTableUpdateCompanionBuilder =
    TurnsCompanion Function({
      Value<int> id,
      Value<String> scenarioId,
      Value<int> turnOrder,
      Value<String> speaker,
      Value<String> koText,
      Value<String> romanization,
      Value<String> enGloss,
      Value<String?> learnerNoteEn,
    });

final class $$TurnsTableReferences
    extends BaseReferences<_$AppDatabase, $TurnsTable, Turn> {
  $$TurnsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ScenariosTable _scenarioIdTable(_$AppDatabase db) => db.scenarios
      .createAlias($_aliasNameGenerator(db.turns.scenarioId, db.scenarios.id));

  $$ScenariosTableProcessedTableManager get scenarioId {
    final $_column = $_itemColumn<String>('scenario_id')!;

    final manager = $$ScenariosTableTableManager(
      $_db,
      $_db.scenarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scenarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AnnotationsTable, List<Annotation>>
  _annotationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.annotations,
    aliasName: $_aliasNameGenerator(db.turns.id, db.annotations.turnId),
  );

  $$AnnotationsTableProcessedTableManager get annotationsRefs {
    final manager = $$AnnotationsTableTableManager(
      $_db,
      $_db.annotations,
    ).filter((f) => f.turnId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_annotationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TurnsTableFilterComposer extends Composer<_$AppDatabase, $TurnsTable> {
  $$TurnsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get turnOrder => $composableBuilder(
    column: $table.turnOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speaker => $composableBuilder(
    column: $table.speaker,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get koText => $composableBuilder(
    column: $table.koText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get romanization => $composableBuilder(
    column: $table.romanization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enGloss => $composableBuilder(
    column: $table.enGloss,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learnerNoteEn => $composableBuilder(
    column: $table.learnerNoteEn,
    builder: (column) => ColumnFilters(column),
  );

  $$ScenariosTableFilterComposer get scenarioId {
    final $$ScenariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scenarioId,
      referencedTable: $db.scenarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScenariosTableFilterComposer(
            $db: $db,
            $table: $db.scenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> annotationsRefs(
    Expression<bool> Function($$AnnotationsTableFilterComposer f) f,
  ) {
    final $$AnnotationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annotations,
      getReferencedColumn: (t) => t.turnId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnotationsTableFilterComposer(
            $db: $db,
            $table: $db.annotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TurnsTableOrderingComposer
    extends Composer<_$AppDatabase, $TurnsTable> {
  $$TurnsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get turnOrder => $composableBuilder(
    column: $table.turnOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speaker => $composableBuilder(
    column: $table.speaker,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get koText => $composableBuilder(
    column: $table.koText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get romanization => $composableBuilder(
    column: $table.romanization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enGloss => $composableBuilder(
    column: $table.enGloss,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learnerNoteEn => $composableBuilder(
    column: $table.learnerNoteEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$ScenariosTableOrderingComposer get scenarioId {
    final $$ScenariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scenarioId,
      referencedTable: $db.scenarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScenariosTableOrderingComposer(
            $db: $db,
            $table: $db.scenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TurnsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TurnsTable> {
  $$TurnsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get turnOrder =>
      $composableBuilder(column: $table.turnOrder, builder: (column) => column);

  GeneratedColumn<String> get speaker =>
      $composableBuilder(column: $table.speaker, builder: (column) => column);

  GeneratedColumn<String> get koText =>
      $composableBuilder(column: $table.koText, builder: (column) => column);

  GeneratedColumn<String> get romanization => $composableBuilder(
    column: $table.romanization,
    builder: (column) => column,
  );

  GeneratedColumn<String> get enGloss =>
      $composableBuilder(column: $table.enGloss, builder: (column) => column);

  GeneratedColumn<String> get learnerNoteEn => $composableBuilder(
    column: $table.learnerNoteEn,
    builder: (column) => column,
  );

  $$ScenariosTableAnnotationComposer get scenarioId {
    final $$ScenariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scenarioId,
      referencedTable: $db.scenarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScenariosTableAnnotationComposer(
            $db: $db,
            $table: $db.scenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> annotationsRefs<T extends Object>(
    Expression<T> Function($$AnnotationsTableAnnotationComposer a) f,
  ) {
    final $$AnnotationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annotations,
      getReferencedColumn: (t) => t.turnId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnotationsTableAnnotationComposer(
            $db: $db,
            $table: $db.annotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TurnsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TurnsTable,
          Turn,
          $$TurnsTableFilterComposer,
          $$TurnsTableOrderingComposer,
          $$TurnsTableAnnotationComposer,
          $$TurnsTableCreateCompanionBuilder,
          $$TurnsTableUpdateCompanionBuilder,
          (Turn, $$TurnsTableReferences),
          Turn,
          PrefetchHooks Function({bool scenarioId, bool annotationsRefs})
        > {
  $$TurnsTableTableManager(_$AppDatabase db, $TurnsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TurnsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TurnsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TurnsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> scenarioId = const Value.absent(),
                Value<int> turnOrder = const Value.absent(),
                Value<String> speaker = const Value.absent(),
                Value<String> koText = const Value.absent(),
                Value<String> romanization = const Value.absent(),
                Value<String> enGloss = const Value.absent(),
                Value<String?> learnerNoteEn = const Value.absent(),
              }) => TurnsCompanion(
                id: id,
                scenarioId: scenarioId,
                turnOrder: turnOrder,
                speaker: speaker,
                koText: koText,
                romanization: romanization,
                enGloss: enGloss,
                learnerNoteEn: learnerNoteEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String scenarioId,
                required int turnOrder,
                required String speaker,
                required String koText,
                required String romanization,
                required String enGloss,
                Value<String?> learnerNoteEn = const Value.absent(),
              }) => TurnsCompanion.insert(
                id: id,
                scenarioId: scenarioId,
                turnOrder: turnOrder,
                speaker: speaker,
                koText: koText,
                romanization: romanization,
                enGloss: enGloss,
                learnerNoteEn: learnerNoteEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TurnsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({scenarioId = false, annotationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (annotationsRefs) db.annotations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (scenarioId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.scenarioId,
                                    referencedTable: $$TurnsTableReferences
                                        ._scenarioIdTable(db),
                                    referencedColumn: $$TurnsTableReferences
                                        ._scenarioIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (annotationsRefs)
                        await $_getPrefetchedData<
                          Turn,
                          $TurnsTable,
                          Annotation
                        >(
                          currentTable: table,
                          referencedTable: $$TurnsTableReferences
                              ._annotationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TurnsTableReferences(
                                db,
                                table,
                                p0,
                              ).annotationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.turnId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TurnsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TurnsTable,
      Turn,
      $$TurnsTableFilterComposer,
      $$TurnsTableOrderingComposer,
      $$TurnsTableAnnotationComposer,
      $$TurnsTableCreateCompanionBuilder,
      $$TurnsTableUpdateCompanionBuilder,
      (Turn, $$TurnsTableReferences),
      Turn,
      PrefetchHooks Function({bool scenarioId, bool annotationsRefs})
    >;
typedef $$AnnotationsTableCreateCompanionBuilder =
    AnnotationsCompanion Function({
      Value<int> id,
      required int turnId,
      required int startOffset,
      required int endOffset,
      required String kind,
      required String target,
      required String glossEn,
      Value<String?> color,
    });
typedef $$AnnotationsTableUpdateCompanionBuilder =
    AnnotationsCompanion Function({
      Value<int> id,
      Value<int> turnId,
      Value<int> startOffset,
      Value<int> endOffset,
      Value<String> kind,
      Value<String> target,
      Value<String> glossEn,
      Value<String?> color,
    });

final class $$AnnotationsTableReferences
    extends BaseReferences<_$AppDatabase, $AnnotationsTable, Annotation> {
  $$AnnotationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TurnsTable _turnIdTable(_$AppDatabase db) => db.turns.createAlias(
    $_aliasNameGenerator(db.annotations.turnId, db.turns.id),
  );

  $$TurnsTableProcessedTableManager get turnId {
    final $_column = $_itemColumn<int>('turn_id')!;

    final manager = $$TurnsTableTableManager(
      $_db,
      $_db.turns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_turnIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnnotationsTableFilterComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endOffset => $composableBuilder(
    column: $table.endOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get glossEn => $composableBuilder(
    column: $table.glossEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  $$TurnsTableFilterComposer get turnId {
    final $$TurnsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.turnId,
      referencedTable: $db.turns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurnsTableFilterComposer(
            $db: $db,
            $table: $db.turns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endOffset => $composableBuilder(
    column: $table.endOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get glossEn => $composableBuilder(
    column: $table.glossEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  $$TurnsTableOrderingComposer get turnId {
    final $$TurnsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.turnId,
      referencedTable: $db.turns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurnsTableOrderingComposer(
            $db: $db,
            $table: $db.turns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endOffset =>
      $composableBuilder(column: $table.endOffset, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get glossEn =>
      $composableBuilder(column: $table.glossEn, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  $$TurnsTableAnnotationComposer get turnId {
    final $$TurnsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.turnId,
      referencedTable: $db.turns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurnsTableAnnotationComposer(
            $db: $db,
            $table: $db.turns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnnotationsTable,
          Annotation,
          $$AnnotationsTableFilterComposer,
          $$AnnotationsTableOrderingComposer,
          $$AnnotationsTableAnnotationComposer,
          $$AnnotationsTableCreateCompanionBuilder,
          $$AnnotationsTableUpdateCompanionBuilder,
          (Annotation, $$AnnotationsTableReferences),
          Annotation,
          PrefetchHooks Function({bool turnId})
        > {
  $$AnnotationsTableTableManager(_$AppDatabase db, $AnnotationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnnotationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnnotationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnnotationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> turnId = const Value.absent(),
                Value<int> startOffset = const Value.absent(),
                Value<int> endOffset = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<String> glossEn = const Value.absent(),
                Value<String?> color = const Value.absent(),
              }) => AnnotationsCompanion(
                id: id,
                turnId: turnId,
                startOffset: startOffset,
                endOffset: endOffset,
                kind: kind,
                target: target,
                glossEn: glossEn,
                color: color,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int turnId,
                required int startOffset,
                required int endOffset,
                required String kind,
                required String target,
                required String glossEn,
                Value<String?> color = const Value.absent(),
              }) => AnnotationsCompanion.insert(
                id: id,
                turnId: turnId,
                startOffset: startOffset,
                endOffset: endOffset,
                kind: kind,
                target: target,
                glossEn: glossEn,
                color: color,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AnnotationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({turnId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (turnId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.turnId,
                                referencedTable: $$AnnotationsTableReferences
                                    ._turnIdTable(db),
                                referencedColumn: $$AnnotationsTableReferences
                                    ._turnIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnnotationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnnotationsTable,
      Annotation,
      $$AnnotationsTableFilterComposer,
      $$AnnotationsTableOrderingComposer,
      $$AnnotationsTableAnnotationComposer,
      $$AnnotationsTableCreateCompanionBuilder,
      $$AnnotationsTableUpdateCompanionBuilder,
      (Annotation, $$AnnotationsTableReferences),
      Annotation,
      PrefetchHooks Function({bool turnId})
    >;
typedef $$VocabTableCreateCompanionBuilder =
    VocabCompanion Function({
      Value<int> id,
      required String word,
      required int rank,
      Value<double?> freq,
      Value<double?> cumPct,
      Value<String?> glossEn,
      Value<String?> pos,
    });
typedef $$VocabTableUpdateCompanionBuilder =
    VocabCompanion Function({
      Value<int> id,
      Value<String> word,
      Value<int> rank,
      Value<double?> freq,
      Value<double?> cumPct,
      Value<String?> glossEn,
      Value<String?> pos,
    });

class $$VocabTableFilterComposer extends Composer<_$AppDatabase, $VocabTable> {
  $$VocabTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get freq => $composableBuilder(
    column: $table.freq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cumPct => $composableBuilder(
    column: $table.cumPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get glossEn => $composableBuilder(
    column: $table.glossEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VocabTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabTable> {
  $$VocabTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get freq => $composableBuilder(
    column: $table.freq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cumPct => $composableBuilder(
    column: $table.cumPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get glossEn => $composableBuilder(
    column: $table.glossEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VocabTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabTable> {
  $$VocabTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<double> get freq =>
      $composableBuilder(column: $table.freq, builder: (column) => column);

  GeneratedColumn<double> get cumPct =>
      $composableBuilder(column: $table.cumPct, builder: (column) => column);

  GeneratedColumn<String> get glossEn =>
      $composableBuilder(column: $table.glossEn, builder: (column) => column);

  GeneratedColumn<String> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);
}

class $$VocabTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VocabTable,
          VocabEntry,
          $$VocabTableFilterComposer,
          $$VocabTableOrderingComposer,
          $$VocabTableAnnotationComposer,
          $$VocabTableCreateCompanionBuilder,
          $$VocabTableUpdateCompanionBuilder,
          (VocabEntry, BaseReferences<_$AppDatabase, $VocabTable, VocabEntry>),
          VocabEntry,
          PrefetchHooks Function()
        > {
  $$VocabTableTableManager(_$AppDatabase db, $VocabTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<int> rank = const Value.absent(),
                Value<double?> freq = const Value.absent(),
                Value<double?> cumPct = const Value.absent(),
                Value<String?> glossEn = const Value.absent(),
                Value<String?> pos = const Value.absent(),
              }) => VocabCompanion(
                id: id,
                word: word,
                rank: rank,
                freq: freq,
                cumPct: cumPct,
                glossEn: glossEn,
                pos: pos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String word,
                required int rank,
                Value<double?> freq = const Value.absent(),
                Value<double?> cumPct = const Value.absent(),
                Value<String?> glossEn = const Value.absent(),
                Value<String?> pos = const Value.absent(),
              }) => VocabCompanion.insert(
                id: id,
                word: word,
                rank: rank,
                freq: freq,
                cumPct: cumPct,
                glossEn: glossEn,
                pos: pos,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VocabTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VocabTable,
      VocabEntry,
      $$VocabTableFilterComposer,
      $$VocabTableOrderingComposer,
      $$VocabTableAnnotationComposer,
      $$VocabTableCreateCompanionBuilder,
      $$VocabTableUpdateCompanionBuilder,
      (VocabEntry, BaseReferences<_$AppDatabase, $VocabTable, VocabEntry>),
      VocabEntry,
      PrefetchHooks Function()
    >;
typedef $$ParticlesTableCreateCompanionBuilder =
    ParticlesCompanion Function({
      Value<int> id,
      required String morph,
      required int rank,
      Value<double?> cumPct,
      required String category,
      required String glossEn,
      Value<String?> notesEn,
    });
typedef $$ParticlesTableUpdateCompanionBuilder =
    ParticlesCompanion Function({
      Value<int> id,
      Value<String> morph,
      Value<int> rank,
      Value<double?> cumPct,
      Value<String> category,
      Value<String> glossEn,
      Value<String?> notesEn,
    });

class $$ParticlesTableFilterComposer
    extends Composer<_$AppDatabase, $ParticlesTable> {
  $$ParticlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get morph => $composableBuilder(
    column: $table.morph,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cumPct => $composableBuilder(
    column: $table.cumPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get glossEn => $composableBuilder(
    column: $table.glossEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notesEn => $composableBuilder(
    column: $table.notesEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParticlesTableOrderingComposer
    extends Composer<_$AppDatabase, $ParticlesTable> {
  $$ParticlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get morph => $composableBuilder(
    column: $table.morph,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cumPct => $composableBuilder(
    column: $table.cumPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get glossEn => $composableBuilder(
    column: $table.glossEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notesEn => $composableBuilder(
    column: $table.notesEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParticlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParticlesTable> {
  $$ParticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get morph =>
      $composableBuilder(column: $table.morph, builder: (column) => column);

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<double> get cumPct =>
      $composableBuilder(column: $table.cumPct, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get glossEn =>
      $composableBuilder(column: $table.glossEn, builder: (column) => column);

  GeneratedColumn<String> get notesEn =>
      $composableBuilder(column: $table.notesEn, builder: (column) => column);
}

class $$ParticlesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParticlesTable,
          Particle,
          $$ParticlesTableFilterComposer,
          $$ParticlesTableOrderingComposer,
          $$ParticlesTableAnnotationComposer,
          $$ParticlesTableCreateCompanionBuilder,
          $$ParticlesTableUpdateCompanionBuilder,
          (Particle, BaseReferences<_$AppDatabase, $ParticlesTable, Particle>),
          Particle,
          PrefetchHooks Function()
        > {
  $$ParticlesTableTableManager(_$AppDatabase db, $ParticlesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParticlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParticlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> morph = const Value.absent(),
                Value<int> rank = const Value.absent(),
                Value<double?> cumPct = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> glossEn = const Value.absent(),
                Value<String?> notesEn = const Value.absent(),
              }) => ParticlesCompanion(
                id: id,
                morph: morph,
                rank: rank,
                cumPct: cumPct,
                category: category,
                glossEn: glossEn,
                notesEn: notesEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String morph,
                required int rank,
                Value<double?> cumPct = const Value.absent(),
                required String category,
                required String glossEn,
                Value<String?> notesEn = const Value.absent(),
              }) => ParticlesCompanion.insert(
                id: id,
                morph: morph,
                rank: rank,
                cumPct: cumPct,
                category: category,
                glossEn: glossEn,
                notesEn: notesEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ParticlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParticlesTable,
      Particle,
      $$ParticlesTableFilterComposer,
      $$ParticlesTableOrderingComposer,
      $$ParticlesTableAnnotationComposer,
      $$ParticlesTableCreateCompanionBuilder,
      $$ParticlesTableUpdateCompanionBuilder,
      (Particle, BaseReferences<_$AppDatabase, $ParticlesTable, Particle>),
      Particle,
      PrefetchHooks Function()
    >;
typedef $$UserProgressTableCreateCompanionBuilder =
    UserProgressCompanion Function({
      required String scenarioId,
      Value<String> status,
      Value<int> lastTurnOrder,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$UserProgressTableUpdateCompanionBuilder =
    UserProgressCompanion Function({
      Value<String> scenarioId,
      Value<String> status,
      Value<int> lastTurnOrder,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

final class $$UserProgressTableReferences
    extends BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressRow> {
  $$UserProgressTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ScenariosTable _scenarioIdTable(_$AppDatabase db) =>
      db.scenarios.createAlias(
        $_aliasNameGenerator(db.userProgress.scenarioId, db.scenarios.id),
      );

  $$ScenariosTableProcessedTableManager get scenarioId {
    final $_column = $_itemColumn<String>('scenario_id')!;

    final manager = $$ScenariosTableTableManager(
      $_db,
      $_db.scenarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scenarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastTurnOrder => $composableBuilder(
    column: $table.lastTurnOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ScenariosTableFilterComposer get scenarioId {
    final $$ScenariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scenarioId,
      referencedTable: $db.scenarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScenariosTableFilterComposer(
            $db: $db,
            $table: $db.scenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastTurnOrder => $composableBuilder(
    column: $table.lastTurnOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ScenariosTableOrderingComposer get scenarioId {
    final $$ScenariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scenarioId,
      referencedTable: $db.scenarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScenariosTableOrderingComposer(
            $db: $db,
            $table: $db.scenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get lastTurnOrder => $composableBuilder(
    column: $table.lastTurnOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$ScenariosTableAnnotationComposer get scenarioId {
    final $$ScenariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scenarioId,
      referencedTable: $db.scenarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScenariosTableAnnotationComposer(
            $db: $db,
            $table: $db.scenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProgressTable,
          UserProgressRow,
          $$UserProgressTableFilterComposer,
          $$UserProgressTableOrderingComposer,
          $$UserProgressTableAnnotationComposer,
          $$UserProgressTableCreateCompanionBuilder,
          $$UserProgressTableUpdateCompanionBuilder,
          (UserProgressRow, $$UserProgressTableReferences),
          UserProgressRow,
          PrefetchHooks Function({bool scenarioId})
        > {
  $$UserProgressTableTableManager(_$AppDatabase db, $UserProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> scenarioId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> lastTurnOrder = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProgressCompanion(
                scenarioId: scenarioId,
                status: status,
                lastTurnOrder: lastTurnOrder,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String scenarioId,
                Value<String> status = const Value.absent(),
                Value<int> lastTurnOrder = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProgressCompanion.insert(
                scenarioId: scenarioId,
                status: status,
                lastTurnOrder: lastTurnOrder,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({scenarioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (scenarioId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.scenarioId,
                                referencedTable: $$UserProgressTableReferences
                                    ._scenarioIdTable(db),
                                referencedColumn: $$UserProgressTableReferences
                                    ._scenarioIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProgressTable,
      UserProgressRow,
      $$UserProgressTableFilterComposer,
      $$UserProgressTableOrderingComposer,
      $$UserProgressTableAnnotationComposer,
      $$UserProgressTableCreateCompanionBuilder,
      $$UserProgressTableUpdateCompanionBuilder,
      (UserProgressRow, $$UserProgressTableReferences),
      UserProgressRow,
      PrefetchHooks Function({bool scenarioId})
    >;
typedef $$AppMetaTableCreateCompanionBuilder =
    AppMetaCompanion Function({
      required String key,
      Value<String?> value,
      Value<int> rowid,
    });
typedef $$AppMetaTableUpdateCompanionBuilder =
    AppMetaCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<int> rowid,
    });

class $$AppMetaTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetaTable,
          AppMetaRow,
          $$AppMetaTableFilterComposer,
          $$AppMetaTableOrderingComposer,
          $$AppMetaTableAnnotationComposer,
          $$AppMetaTableCreateCompanionBuilder,
          $$AppMetaTableUpdateCompanionBuilder,
          (
            AppMetaRow,
            BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaRow>,
          ),
          AppMetaRow,
          PrefetchHooks Function()
        > {
  $$AppMetaTableTableManager(_$AppDatabase db, $AppMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  AppMetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetaTable,
      AppMetaRow,
      $$AppMetaTableFilterComposer,
      $$AppMetaTableOrderingComposer,
      $$AppMetaTableAnnotationComposer,
      $$AppMetaTableCreateCompanionBuilder,
      $$AppMetaTableUpdateCompanionBuilder,
      (AppMetaRow, BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaRow>),
      AppMetaRow,
      PrefetchHooks Function()
    >;
typedef $$HanjaTableCreateCompanionBuilder =
    HanjaCompanion Function({
      required String id,
      required String koHanja,
      required String yumeum,
      Value<String?> zhSimp,
      Value<String?> zhTrad,
      Value<String?> jaKanji,
      required String meaningKo,
      Value<int?> freqRank,
      Value<int> rowid,
    });
typedef $$HanjaTableUpdateCompanionBuilder =
    HanjaCompanion Function({
      Value<String> id,
      Value<String> koHanja,
      Value<String> yumeum,
      Value<String?> zhSimp,
      Value<String?> zhTrad,
      Value<String?> jaKanji,
      Value<String> meaningKo,
      Value<int?> freqRank,
      Value<int> rowid,
    });

class $$HanjaTableFilterComposer extends Composer<_$AppDatabase, $HanjaTable> {
  $$HanjaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get koHanja => $composableBuilder(
    column: $table.koHanja,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get yumeum => $composableBuilder(
    column: $table.yumeum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zhSimp => $composableBuilder(
    column: $table.zhSimp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zhTrad => $composableBuilder(
    column: $table.zhTrad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jaKanji => $composableBuilder(
    column: $table.jaKanji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningKo => $composableBuilder(
    column: $table.meaningKo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get freqRank => $composableBuilder(
    column: $table.freqRank,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HanjaTableOrderingComposer
    extends Composer<_$AppDatabase, $HanjaTable> {
  $$HanjaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get koHanja => $composableBuilder(
    column: $table.koHanja,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get yumeum => $composableBuilder(
    column: $table.yumeum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zhSimp => $composableBuilder(
    column: $table.zhSimp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zhTrad => $composableBuilder(
    column: $table.zhTrad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jaKanji => $composableBuilder(
    column: $table.jaKanji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningKo => $composableBuilder(
    column: $table.meaningKo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get freqRank => $composableBuilder(
    column: $table.freqRank,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HanjaTableAnnotationComposer
    extends Composer<_$AppDatabase, $HanjaTable> {
  $$HanjaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get koHanja =>
      $composableBuilder(column: $table.koHanja, builder: (column) => column);

  GeneratedColumn<String> get yumeum =>
      $composableBuilder(column: $table.yumeum, builder: (column) => column);

  GeneratedColumn<String> get zhSimp =>
      $composableBuilder(column: $table.zhSimp, builder: (column) => column);

  GeneratedColumn<String> get zhTrad =>
      $composableBuilder(column: $table.zhTrad, builder: (column) => column);

  GeneratedColumn<String> get jaKanji =>
      $composableBuilder(column: $table.jaKanji, builder: (column) => column);

  GeneratedColumn<String> get meaningKo =>
      $composableBuilder(column: $table.meaningKo, builder: (column) => column);

  GeneratedColumn<int> get freqRank =>
      $composableBuilder(column: $table.freqRank, builder: (column) => column);
}

class $$HanjaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HanjaTable,
          HanjaEntry,
          $$HanjaTableFilterComposer,
          $$HanjaTableOrderingComposer,
          $$HanjaTableAnnotationComposer,
          $$HanjaTableCreateCompanionBuilder,
          $$HanjaTableUpdateCompanionBuilder,
          (HanjaEntry, BaseReferences<_$AppDatabase, $HanjaTable, HanjaEntry>),
          HanjaEntry,
          PrefetchHooks Function()
        > {
  $$HanjaTableTableManager(_$AppDatabase db, $HanjaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HanjaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HanjaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HanjaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> koHanja = const Value.absent(),
                Value<String> yumeum = const Value.absent(),
                Value<String?> zhSimp = const Value.absent(),
                Value<String?> zhTrad = const Value.absent(),
                Value<String?> jaKanji = const Value.absent(),
                Value<String> meaningKo = const Value.absent(),
                Value<int?> freqRank = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HanjaCompanion(
                id: id,
                koHanja: koHanja,
                yumeum: yumeum,
                zhSimp: zhSimp,
                zhTrad: zhTrad,
                jaKanji: jaKanji,
                meaningKo: meaningKo,
                freqRank: freqRank,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String koHanja,
                required String yumeum,
                Value<String?> zhSimp = const Value.absent(),
                Value<String?> zhTrad = const Value.absent(),
                Value<String?> jaKanji = const Value.absent(),
                required String meaningKo,
                Value<int?> freqRank = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HanjaCompanion.insert(
                id: id,
                koHanja: koHanja,
                yumeum: yumeum,
                zhSimp: zhSimp,
                zhTrad: zhTrad,
                jaKanji: jaKanji,
                meaningKo: meaningKo,
                freqRank: freqRank,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HanjaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HanjaTable,
      HanjaEntry,
      $$HanjaTableFilterComposer,
      $$HanjaTableOrderingComposer,
      $$HanjaTableAnnotationComposer,
      $$HanjaTableCreateCompanionBuilder,
      $$HanjaTableUpdateCompanionBuilder,
      (HanjaEntry, BaseReferences<_$AppDatabase, $HanjaTable, HanjaEntry>),
      HanjaEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScenariosTableTableManager get scenarios =>
      $$ScenariosTableTableManager(_db, _db.scenarios);
  $$TurnsTableTableManager get turns =>
      $$TurnsTableTableManager(_db, _db.turns);
  $$AnnotationsTableTableManager get annotations =>
      $$AnnotationsTableTableManager(_db, _db.annotations);
  $$VocabTableTableManager get vocab =>
      $$VocabTableTableManager(_db, _db.vocab);
  $$ParticlesTableTableManager get particles =>
      $$ParticlesTableTableManager(_db, _db.particles);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db, _db.userProgress);
  $$AppMetaTableTableManager get appMeta =>
      $$AppMetaTableTableManager(_db, _db.appMeta);
  $$HanjaTableTableManager get hanja =>
      $$HanjaTableTableManager(_db, _db.hanja);
}
