import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/database.dart';
import '../drama/drama_service.dart';
import '../review/review_service.dart';

/// 성과 기록·집계 — 일본어앱 `achievement_service.dart` 를 옮김(시안 02 §5).
/// **센다**: 편 완주 · 라이트너 단계/졸업 · 핵심 표현(그림 카드 맞음) · 빈도 커버율.
/// **안 센다**: 앱 오픈 · 스트릭 · 포인트 · 순위. 저장은 SharedPreferences `achievements_v1`(JSON 하나).
class AchievementService {
  AchievementService._();
  static final AchievementService instance = AchievementService._();
  static const _key = 'achievements_v1';

  /// 한국어 절벽(누적 55/60/70/80% 에 처음 닿는 순위).
  static const cliffs = [75, 104, 215, 521];

  final Map<String, String> _episodes = {}; // 편 id → 완주 날짜(처음)
  final Map<String, List<int>> _cards = {}; // 편 id → [맞음, 전체] (마지막 세션)
  final Map<String, Map<String, int>> _daily = {}; // 날짜 → {episodes, cards}
  final ValueNotifier<int> changes = ValueNotifier(0);
  bool _loaded = false;

  String get today => _ymd(DateTime.now());
  static String _ymd(DateTime t) => '${t.year.toString().padLeft(4, '0')}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';

  Future<void> load() async {
    if (_loaded) return;
    try {
      final raw = (await SharedPreferences.getInstance()).getString(_key);
      if (raw != null) {
        final j = json.decode(raw) as Map<String, dynamic>;
        (j['episodes'] as Map<String, dynamic>? ?? {}).forEach((k, v) => _episodes[k] = v.toString());
        (j['cards'] as Map<String, dynamic>? ?? {}).forEach((k, v) => _cards[k] = (v as List).cast<int>());
        (j['daily'] as Map<String, dynamic>? ?? {}).forEach((k, v) => _daily[k] = (v as Map).map((a, b) => MapEntry(a.toString(), (b as num).toInt())));
      }
    } catch (e) {
      debugPrint('Achievement: load 실패 $e');
    }
    _loaded = true;
  }

  Future<void> _save() async {
    changes.value++;
    (await SharedPreferences.getInstance()).setString(_key, json.encode({'episodes': _episodes, 'cards': _cards, 'daily': _daily}));
  }

  void _bump(String what, [int n = 1]) {
    final d = _daily.putIfAbsent(today, () => {});
    d[what] = (d[what] ?? 0) + n;
  }

  /// 편을 끝까지 들었다. 처음 완주한 날만 기록.
  Future<bool> markEpisodeDone(String id) async {
    await load();
    final first = !_episodes.containsKey(id);
    if (first) {
      _episodes[id] = today;
      _bump('episodes');
      await _save();
    }
    return first;
  }

  /// 그림 카드 세션 결과(편별 마지막 세션). 문장 카드처럼 편이 섞인 세션은 하루 합계만 센다.
  Future<void> markCards(String? episodeId, int right, int total) async {
    await load();
    if (episodeId != null) _cards[episodeId] = [right, total];
    _bump('cards', right);
    await _save();
  }

  List<int>? cardsOf(String id) => _cards[id];

  /// 주제·레벨별 완주 수 / 전체 수. 이 기능 전에 본 편(DramaService.watched)도 친다.
  (int, int) progress({required String island, required String region}) {
    final s = DramaService.instance;
    final all = s.list(region, island: island);
    return (all.where((e) => _episodes.containsKey(e.id) || s.watched.contains(e.id)).length, all.length);
  }

  /// 최근 7일(오늘 포함, 오래된 날부터) 완주 편 수.
  List<(String, int)> week() {
    final now = DateTime.now();
    return [for (var i = 6; i >= 0; i--) (_ymd(now.subtract(Duration(days: i))), _daily[_ymd(now.subtract(Duration(days: i)))]?['episodes'] ?? 0)];
  }

  Map<String, int> get thisWeek {
    final out = {'episodes': 0, 'cards': 0};
    for (final (d, _) in week()) {
      final m = _daily[d];
      if (m == null) continue;
      for (final k in out.keys) {
        out[k] = out[k]! + (m[k] ?? 0);
      }
    }
    return out;
  }

  /// 라이트너 분포(1~7단계, 8 = 졸업).
  Map<int, int> leitnerLevels() {
    final m = <int, int>{};
    for (final it in ReviewService.instance.items.values) {
      if (it.level <= 0) continue;
      final lv = it.level >= 8 ? 8 : it.level;
      m[lv] = (m[lv] ?? 0) + 1;
    }
    return m;
  }

  /// 빈도 커버율: 라이트너 3단계 이상(4일 이상 기억)인 단어 카드(`word:<단어>`)가 사용 빈도의 몇 %를 덮는가 + 다음 절벽까지 남은 단어 수.
  Future<({double pct, int known, int nextCliff, int toNext})> coverage(AppDatabase db) async {
    final words = [
      for (final it in ReviewService.instance.items.values)
        if (it.level >= 3 && it.id.startsWith('word:')) it.id.substring(5),
    ];
    final rows = words.isEmpty ? const <VocabEntry>[] : await (db.select(db.vocab)..where((v) => v.word.isIn(words))).get();
    final sum = rows.fold<double>(0, (a, r) => a + (r.freq ?? 0));
    final known = rows.length;
    final next = cliffs.firstWhere((c) => c > known, orElse: () => 2000);
    return (pct: sum * 100, known: known, nextCliff: next, toNext: (next - known).clamp(0, 9999));
  }

  /// 이번 주 가장 많이 완주한 주제(없으면 빈 문자열).
  String weekIsland() {
    final days = {for (final (d, _) in week()) d};
    final counts = <String, int>{};
    for (final e in _episodes.entries) {
      if (!days.contains(e.value)) continue;
      final ep = DramaService.instance.byId(e.key);
      if (ep != null) counts[ep.island] = (counts[ep.island] ?? 0) + 1;
    }
    var best = '';
    var n = 0;
    counts.forEach((k, v) {
      if (v > n) {
        n = v;
        best = k;
      }
    });
    return best;
  }
}
