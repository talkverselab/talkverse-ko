import 'dart:convert';

import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/account.dart';

/// 드라마 회화(R0~R4 · 주제별 JSON) 로더 — 일본어앱 dialogue_service 를 한국어 필드로 옮김(2026-11-03).
/// 파일 `assets/data/dialogues/R<레벨>/<주제>/<편id>.json`, 구조는 `assets/data/dialogues/README.md`.
/// 턴: ko(한국어) · rd(로마자) · en(영어) · note(영어 메모) · art(장면 컷 키 `scene/ko/<편id>/cut<N>`, A·B 쌍의 첫 턴).
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
  const DramaTurn({required this.num, required this.speaker, required this.ko, required this.rd, required this.en, required this.note, this.at, this.bubble = false, this.art});
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
      );
}

class DramaEpisode {
  final String id, region, island, kind, title, emoji, scene, register;
  final Map<String, String> speakers;
  final int twist;
  final String kdrama;
  final List<DramaTurn> turns;
  const DramaEpisode({required this.id, required this.region, required this.island, required this.kind, required this.title, required this.emoji, required this.scene, required this.register, required this.speakers, required this.twist, required this.kdrama, required this.turns});
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
        turns: ((j['turns'] as List?) ?? const []).map((t) => DramaTurn.fromJson(t as Map<String, dynamic>)).toList(),
      );
  bool get isChat => kind == 'chat';
  bool get cliche => kdrama.isNotEmpty;
  int get cutCount => (turns.length + 1) ~/ 2;

  /// 학습자 자리(`{name}`)에 들어갈 이름 — 로그인했으면 계정 이름, 아니면 「나」.
  static String learnerName() {
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
    lastOpened = prefs.getString('drama_last');
    watched.addAll(prefs.getStringList('drama_watched') ?? const []);
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest.listAssets().where((p) => RegExp(r'^assets/data/dialogues/R[0-4]/[^/]+/[^/]+\.json$').hasMatch(p));
    for (final p in paths) {
      try {
        final e = DramaEpisode.fromJson(json.decode(await rootBundle.loadString(p)) as Map<String, dynamic>);
        if (e.turns.isNotEmpty) _byId[e.id] = e;
      } catch (_) {}
    }
    _loaded = true;
  }

  Future<void> markOpened(String id) async {
    lastOpened = id;
    (await SharedPreferences.getInstance()).setString('drama_last', id);
  }

  Future<bool> markWatched(String id) async {
    final first = watched.add(id);
    if (first) (await SharedPreferences.getInstance()).setStringList('drama_watched', watched.toList());
    return first;
  }

  DramaEpisode? byId(String id) => _byId[id];
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
