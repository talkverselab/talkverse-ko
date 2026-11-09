import '../core/embed_env.dart';
import 'dart:convert';

import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/account.dart';
import '../services/content_sync.dart';
import '../services/learner_prefs.dart';

/// 드라마 회화(R0~R4 · 주제별 JSON) 로더 — 일본어앱 dialogue_service 를 한국어 필드로 옮김(2026-11-03).
/// 파일 `assets/data/dialogues/R<레벨>/<주제>/<편id>.json`, 구조는 `assets/data/dialogues/README.md`.
/// 턴: ko(한국어) · rd(로마자) · en(영어) · note(영어 메모) · art(장면 컷 키 `scene/ko/<편id>/cut<N>`, A·B 쌍의 첫 턴).
/// 문장 내용어 — [표면형, 기본형, 로마자](tools/add_lemmas.py).
class DramaLemma {
  final String surface, base, rd;
  const DramaLemma(this.surface, this.base, this.rd);
}

class DramaTurn {
  final int num;
  final String speaker;
  final String ko;
  final String rd;
  final String en;
  final String note;
  final String? at;
  final bool bubble;
  final String? art;
  final List<DramaLemma> lemmas;
  const DramaTurn({required this.num, required this.speaker, required this.ko, required this.rd, required this.en, required this.note, this.at, this.bubble = false, this.art, this.lemmas = const []});
  /// 본문만 바꾼 사본(생성 음성이 읽은 판). 영어 뜻·메모는 그대로.
  DramaTurn withText({String? ko, String? rd}) => DramaTurn(num: num, speaker: speaker, ko: ko ?? this.ko, rd: rd ?? this.rd, en: en, note: note, at: at, bubble: bubble, art: art, lemmas: lemmas);
  factory DramaTurn.fromJson(Map<String, dynamic> j) => DramaTurn(
        num: j['num'] as int? ?? 0,
        speaker: j['speaker'] as String? ?? 'A',
        ko: j['ko'] as String? ?? '',
        rd: j['rd'] as String? ?? '',
        en: j['en'] as String? ?? '',
        note: j['note'] as String? ?? '',
        at: j['at'] as String?,
        bubble: j['ui'] == 'bubble',
        art: j['art'] as String?,
        lemmas: [
          for (final l in (j['lemmas'] as List? ?? const []))
            if (l is List && l.length >= 2) DramaLemma('${l[0]}', '${l[1]}', l.length > 2 ? '${l[2]}' : ''),
        ],
      );
}

class DramaEpisode {
  final String id, region, island, kind, title, emoji, scene, register;
  final Map<String, String> speakers;
  final int twist;
  final String kdrama;
  final List<String> expressions;
  final List<DramaTurn> turns;
  const DramaEpisode({required this.id, required this.region, required this.island, required this.kind, required this.title, required this.emoji, required this.scene, required this.register, required this.speakers, required this.twist, required this.kdrama, this.expressions = const [], required this.turns});
  factory DramaEpisode.fromJson(Map<String, dynamic> j) => DramaEpisode(
        id: j['id'] as String,
        region: j['region'] as String? ?? 'R1',
        island: j['island'] as String? ?? '',
        kind: j['kind'] as String? ?? 'long',
        title: j['title'] as String? ?? '',
        emoji: j['emoji'] as String? ?? '💬',
        scene: j['scene'] as String? ?? '',
        register: j['register'] as String? ?? '',
        speakers: ((j['speakers'] as Map?) ?? const {}).map((k, v) => MapEntry(k.toString(), v.toString())),
        twist: j['twist'] as int? ?? 0,
        kdrama: j['kdrama'] as String? ?? '',
        expressions: (j['expressions'] as List?)?.cast<String>() ?? const [],
        turns: ((j['turns'] as List?) ?? const []).map((t) => DramaTurn.fromJson(t as Map<String, dynamic>)).toList(),
      );
  bool get isChat => kind == 'chat';

  /// 화면에 보일 턴: 생성 음성이 있으면 그 음성이 읽는 본문(학습자 성별판) — 듣는 말과 글이 같아야 한다.
  DramaTurn view(DramaTurn t) {
    final l = ContentSync.instance.audioIndex[id]?[t.num]?[LearnerPrefs.isFemale ? 'f' : 'm'];
    if (l == null || l.text.isEmpty) return t;
    return t.withText(ko: l.text, rd: l.rd.isEmpty ? null : l.rd);
  }

  bool get cliche => kdrama.isNotEmpty;
  int get cutCount => (turns.length + 1) ~/ 2;

  /// `{name}` 자리가 있는 편인지(있으면 이름이 빈 학습자에게 이름·성별을 묻는다).
  bool get needsName => speakers.values.any((v) => v.contains('{name}')) || turns.any((t) => t.ko.contains('{name}'));

  /// 학습자 자리(`{name}`)에 들어갈 이름 — 「나」 설정 이름 → 로그인 계정 이름 → 「나」.
  static String learnerName() {
    if (LearnerPrefs.name.value.isNotEmpty) return LearnerPrefs.name.value;
    final n = Account.user.value?['display_name'] as String?;
    return (n != null && n.trim().isNotEmpty) ? n.trim() : '나';
  }

  String speakerName(String sp) {
    final raw = speakers[sp] ?? sp;
    return raw.contains('{name}') ? learnerName() : raw.replaceAll(RegExp(r'[{}]'), '');
  }

  /// 화면에 보일 문장 — 변수 채우기.
  static String fill(String s) => s.replaceAll('{name}', learnerName()).replaceAll(RegExp(r'\{[a-z_]+\}'), '…');

  /// 편 순서: survival(s) → 짧은(a) → 긴(b) → 채팅(c), 번호 순.
  String get orderKey {
    final m = RegExp(r'_([abcs])(\d+)$').firstMatch(id);
    if (m == null) return id;
    const o = {'s': 0, 'a': 1, 'b': 2, 'c': 3};
    return '${o[m.group(1)]}${m.group(2)!.padLeft(2, '0')}';
  }
}

class DramaService {
  DramaService._();
  static final DramaService instance = DramaService._();

  static const islands = ['survival', 'love', 'friends', 'life', 'travel', 'culture', 'work', 'study'];
  static const islandKo = {'survival': '서바이벌', 'love': '사랑', 'friends': '친구', 'life': '생활', 'travel': '여행', 'culture': '문화', 'work': '일', 'study': '학업'};
  static const islandEmoji = {'survival': '🆘', 'love': '💘', 'friends': '🤝', 'life': '🏠', 'travel': '✈️', 'culture': '🎬', 'work': '💼', 'study': '🎓'};
  static const levels = ['R0', 'R1', 'R2', 'R3', 'R4'];
  static const levelKo = {'R0': '왕초보', 'R1': '초보', 'R2': '중급', 'R3': '고급', 'R4': '최상급'};

  final Map<String, DramaEpisode> _byId = {};
  bool _loaded = false;
  String? lastOpened;
  final Set<String> watched = {};

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    lastOpened = prefs.getString(pk('drama_last'));
    watched.addAll(prefs.getStringList(pk('drama_watched')) ?? const []);
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest.listAssets().map(unpackAsset).whereType<String>().where((p) => RegExp(r'^assets/data/dialogues/R[0-4]/[^/]+/[^/]+\.json$').hasMatch(p));
    for (final p in paths) {
      try {
        final e = DramaEpisode.fromJson(json.decode(await rootBundle.loadString(assetPath(p))) as Map<String, dynamic>);
        if (e.turns.isNotEmpty) _byId[e.id] = e;
      } catch (_) {}
    }
    _loaded = true;
  }

  Future<void> markOpened(String id) async {
    lastOpened = id;
    (await SharedPreferences.getInstance()).setString(pk('drama_last'), id);
  }

  Future<bool> markWatched(String id) async {
    final first = watched.add(id);
    if (first) (await SharedPreferences.getInstance()).setStringList(pk('drama_watched'), watched.toList());
    return first;
  }

  DramaEpisode? byId(String id) => _byId[id];
  List<DramaEpisode> get all => _byId.values.toList();

  /// 단어(기본형) → 로마자. 회화 레마에서 모은다 — 복습 카드·단어 시트의 읽기.
  late final Map<String, String> romanOf = () {
    final m = <String, String>{};
    for (final e in _byId.values) {
      for (final t in e.turns) {
        for (final l in t.lemmas) {
          if (l.rd.isNotEmpty) m.putIfAbsent(l.base, () => l.rd);
        }
      }
    }
    return m;
  }();
  int get total => _byId.length;

  List<DramaEpisode> list(String region, {String? island}) {
    final out = _byId.values.where((e) => e.region == region && (island == null || e.island == island)).toList()
      ..sort((a, b) => a.orderKey.compareTo(b.orderKey));
    return out;
  }

  List<String> islandsOf(String region) {
    final has = _byId.values.where((e) => e.region == region).map((e) => e.island).toSet();
    return islands.where(has.contains).toList();
  }

  int count(String region) => _byId.values.where((e) => e.region == region).length;

  /// 같은 레벨·주제의 다음 편(「다음 회 예고」). 없으면 같은 주제의 다음 레벨 첫 편.
  DramaEpisode? next(DramaEpisode e) {
    final same = list(e.region, island: e.island);
    final i = same.indexWhere((x) => x.id == e.id);
    if (i >= 0 && i + 1 < same.length) return same[i + 1];
    final li = levels.indexOf(e.region);
    for (var k = li + 1; k < levels.length; k++) {
      final up = list(levels[k], island: e.island);
      if (up.isNotEmpty) return up.first;
    }
    return null;
  }

  /// 편 안에서의 회차 번호(EP.n) — 같은 레벨·주제 안의 순서.
  int epNumber(DramaEpisode e) => list(e.region, island: e.island).indexWhere((x) => x.id == e.id) + 1;
}
