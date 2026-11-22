import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart' show ValueNotifier, visibleForTesting;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/embed_env.dart';
import '../drama/drama_service.dart';

/// 토크버스 커리큘럼 — 전 언어 공통 기준 `~/talkverse/CURRICULUM_SPEC.md`(uk, 2026-11-22).
/// 회화 레벨에서 편을 골라 코스를 만들고 → 편마다 듣기·확인 문제 → 틀린 줄은 1·3·7일 간격 복습 →
/// 코스 시험 80% 이상이면 통과, 레벨의 편을 다 통과하면 다음 레벨. 하루 목표 = 새 편 1·2·3 + 복습.
/// 저장 키 `curriculum_v1`(전 언어 같은 형식, §7). `today` 는 하루 분량 계산용으로 더한 칸.

const kCurriculumKey = 'curriculum_v1';
const kReviewSteps = [1, 3, 7]; // 간격 반복(일)
const kPassPercent = 80;
const kCourseSizes = [3, 5, 10];
const kDailyGoals = [1, 2, 3]; // 가볍게 · 보통 · 집중 = 하루 새 편 수
const kReviewPerDay = 20; // 하루 복습 문제 상한

String dayOf(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
DateTime _parseDay(String s) => DateTime.parse(s);
String addDays(String day, int n) => dayOf(_parseDay(day).add(Duration(days: n, hours: 12)));

/// 점수 = 정답 수 / 문제 수, 소수점 버림(§5).
int scorePercent(int correct, int total) => total <= 0 ? 0 : (correct * 100) ~/ total;
bool isPass(int correct, int total) => scorePercent(correct, total) >= kPassPercent;

class ReviewItem {
  final String lineId; // '<편id>#<턴번호>'
  String due; // yyyy-MM-dd
  int step; // kReviewSteps 의 몇 번째 간격을 기다리는 중
  ReviewItem(this.lineId, this.due, this.step);
  Map<String, dynamic> toJson() => {'lineId': lineId, 'due': due, 'step': step};
  factory ReviewItem.fromJson(Map<String, dynamic> j) => ReviewItem(j['lineId'] as String, j['due'] as String, (j['step'] as num?)?.toInt() ?? 0);
}

class Course {
  final String id;
  final List<String> dialogueIds;
  final List<String> practiced;
  final List<int> examScores;
  String? passedAt;
  Course({required this.id, required this.dialogueIds, List<String>? practiced, List<int>? examScores, this.passedAt})
      : practiced = practiced ?? [],
        examScores = examScores ?? [];
  bool get allPracticed => dialogueIds.every(practiced.contains);
  Map<String, dynamic> toJson() => {'id': id, 'dialogueIds': dialogueIds, 'practiced': practiced, 'examScores': examScores, 'passedAt': passedAt};
  factory Course.fromJson(Map<String, dynamic> j) => Course(
        id: j['id'] as String,
        dialogueIds: (j['dialogueIds'] as List).cast<String>().toList(),
        practiced: ((j['practiced'] as List?) ?? const []).cast<String>().toList(),
        examScores: ((j['examScores'] as List?) ?? const []).map((e) => (e as num).toInt()).toList(),
        passedAt: j['passedAt'] as String?,
      );
}

/// 저장되는 상태 전체(§7 형식).
class CurriculumState {
  String? level;
  int dailyGoal;
  Course? course;
  final Set<String> passedDialogues;
  final List<ReviewItem> review;
  int streakCount;
  String? streakLastDay;
  // 하루 분량(더한 칸): 그날 새로 연습한 편 · 푼 복습 수
  String todayDay;
  int todayNew, todayReview;

  CurriculumState({this.level, this.dailyGoal = 2, this.course, Set<String>? passedDialogues, List<ReviewItem>? review, this.streakCount = 0, this.streakLastDay, this.todayDay = '', this.todayNew = 0, this.todayReview = 0})
      : passedDialogues = passedDialogues ?? {},
        review = review ?? [];

  Map<String, dynamic> toJson() => {
        'level': level,
        'dailyGoal': dailyGoal,
        'course': course?.toJson(),
        'passedDialogues': passedDialogues.toList(),
        'review': review.map((r) => r.toJson()).toList(),
        'streak': {'count': streakCount, 'lastDay': streakLastDay},
        'today': {'day': todayDay, 'new': todayNew, 'review': todayReview},
      };

  factory CurriculumState.fromJson(Map<String, dynamic> j) {
    final s = (j['streak'] as Map?) ?? const {};
    final t = (j['today'] as Map?) ?? const {};
    return CurriculumState(
      level: j['level'] as String?,
      dailyGoal: (j['dailyGoal'] as num?)?.toInt() ?? 2,
      course: j['course'] == null ? null : Course.fromJson((j['course'] as Map).cast<String, dynamic>()),
      passedDialogues: ((j['passedDialogues'] as List?) ?? const []).cast<String>().toSet(),
      review: ((j['review'] as List?) ?? const []).map((e) => ReviewItem.fromJson((e as Map).cast<String, dynamic>())).toList(),
      streakCount: (s['count'] as num?)?.toInt() ?? 0,
      streakLastDay: s['lastDay'] as String?,
      todayDay: t['day'] as String? ?? '',
      todayNew: (t['new'] as num?)?.toInt() ?? 0,
      todayReview: (t['review'] as num?)?.toInt() ?? 0,
    );
  }

  /// 날이 바뀌었으면 하루 칸을 비운다.
  void rollDay(String today) {
    if (todayDay == today) return;
    todayDay = today;
    todayNew = 0;
    todayReview = 0;
  }

  List<ReviewItem> dueOn(String today) => review.where((r) => r.due.compareTo(today) <= 0).toList();

  /// 오늘 남은 복습 수(상한 [kReviewPerDay] 안에서).
  int reviewLeft(String today) {
    rollDay(today);
    return max(0, min(dueOn(today).length, kReviewPerDay - todayReview));
  }

  int newLeft(String today) {
    rollDay(today);
    return max(0, dailyGoal - todayNew);
  }

  bool dailyDone(String today) => reviewLeft(today) == 0 && newLeft(today) == 0;

  /// 줄을 복습 대기열에 넣는다(이미 있으면 그대로) — 첫 복습은 내일.
  void enqueue(String lineId, String today) {
    if (review.any((r) => r.lineId == lineId)) return;
    review.add(ReviewItem(lineId, addDays(today, kReviewSteps.first), 0));
  }

  /// 복습 답 반영: 맞히면 다음 간격(마지막 간격까지 맞히면 졸업), 틀리면 1일로.
  void answerReview(String lineId, bool correct, String today) {
    final i = review.indexWhere((r) => r.lineId == lineId);
    if (i < 0) return;
    final r = review[i];
    if (!correct) {
      r.step = 0;
      r.due = addDays(today, kReviewSteps.first);
      return;
    }
    final next = r.step + 1;
    if (next >= kReviewSteps.length) {
      review.removeAt(i);
    } else {
      r.step = next;
      r.due = addDays(today, kReviewSteps[next]);
    }
  }

  /// 하루 분량을 처음 다 했을 때 연속 일수를 올린다.
  void touchStreak(String today) {
    if (!dailyDone(today) || streakLastDay == today) return;
    streakCount = streakLastDay == addDays(today, -1) ? streakCount + 1 : 1;
    streakLastDay = today;
  }

  /// 보이는 연속 일수(어제·오늘 이어지지 않으면 0).
  int streakShown(String today) => (streakLastDay == today || streakLastDay == addDays(today, -1)) ? streakCount : 0;
}

/// 문제 하나 — 뜻 고르기(한국어 줄 → 영어 뜻 4지선다) · 빈칸 낱말 고르기.
class CQuestion {
  final String lineId, episodeId;
  final int turn;
  final String kind; // 'meaning' | 'blank'
  final String prompt; // 화면에 보일 줄(빈칸은 ＿＿)
  final String sub; // 보조(빈칸 문제의 영어 뜻)
  final List<String> options;
  final int answer;
  const CQuestion({required this.lineId, required this.episodeId, required this.turn, required this.kind, required this.prompt, required this.sub, required this.options, required this.answer});
}

String lineIdOf(String ep, int turn) => '$ep#$turn';

/// 문제로 쓸 수 있는 줄(뜻이 있고 지문·채팅 표시만이 아닌 것).
List<DramaTurn> quizTurns(DramaEpisode e) => e.turns.where((t) => t.en.trim().isNotEmpty && RegExp(r'[가-힣]').hasMatch(t.ko.replaceAll(RegExp(r'\([^)]*\)'), ''))).toList();

String _clean(String s) => DramaEpisode.fill(s).replaceAll(RegExp(r'\([^)]*\)'), '').replaceAll(RegExp(r'\s+'), ' ').trim();

/// 줄 하나로 문제를 만든다. [pool] = 오답 보기를 뽑을 다른 줄들.
CQuestion? makeQuestion(DramaEpisode e, DramaTurn t, List<DramaTurn> pool, Random rnd, {String? kind}) {
  final ko = _clean(t.ko);
  final lemmas = t.lemmas.where((l) => l.surface.length >= 2 && ko.contains(l.surface)).toList();
  final wantBlank = kind == 'blank' || (kind == null && lemmas.isNotEmpty && rnd.nextBool());
  if (wantBlank && lemmas.isNotEmpty) {
    final l = lemmas[rnd.nextInt(lemmas.length)];
    final others = <String>{for (final p in pool) for (final x in p.lemmas) if (x.surface.length >= 2 && x.surface != l.surface) x.surface}.toList()..shuffle(rnd);
    if (others.length >= 3) {
      final opts = [l.surface, ...others.take(3)]..shuffle(rnd);
      return CQuestion(lineId: lineIdOf(e.id, t.num), episodeId: e.id, turn: t.num, kind: 'blank', prompt: ko.replaceFirst(l.surface, '＿＿'), sub: t.en, options: opts, answer: opts.indexOf(l.surface));
    }
  }
  final wrong = <String>{for (final p in pool) if (p.en.trim().isNotEmpty && p.en != t.en) p.en.trim()}.toList()..shuffle(rnd);
  if (wrong.length < 3) return null;
  final opts = [t.en.trim(), ...wrong.take(3)]..shuffle(rnd);
  return CQuestion(lineId: lineIdOf(e.id, t.num), episodeId: e.id, turn: t.num, kind: 'meaning', prompt: ko, sub: '', options: opts, answer: opts.indexOf(t.en.trim()));
}

/// 편 연습 문제: 줄 수만큼, 최대 10(§3).
List<CQuestion> practiceQuestions(DramaEpisode e, List<DramaTurn> pool, {Random? rnd, int maxN = 10}) {
  final r = rnd ?? Random();
  final ts = quizTurns(e)..shuffle(r);
  final allPool = [...quizTurns(e), ...pool];
  return [for (final t in ts.take(maxN)) makeQuestion(e, t, allPool, r)].whereType<CQuestion>().toList();
}

/// 시험 편당 문제 수: 편당 최소 3, 전체 최대 30(§5).
@visibleForTesting
int examPerEpisode(int episodes) => episodes <= 0 ? 0 : max(3, min(10, 30 ~/ episodes));

/// 코스 시험.
List<CQuestion> examQuestions(List<DramaEpisode> eps, List<DramaTurn> pool, {Random? rnd}) {
  final r = rnd ?? Random();
  final per = examPerEpisode(eps.length);
  final out = <CQuestion>[for (final e in eps) ...practiceQuestions(e, pool, rnd: r, maxN: per)]..shuffle(r);
  return out.take(30).toList();
}

/// 「추천으로 채우기」: 안 한 편에서 주제가 겹치지 않게(주제를 돌아가며) [n] 개.
List<String> recommend(List<DramaEpisode> levelEps, Set<String> exclude, int n) {
  final byIsland = <String, List<DramaEpisode>>{};
  for (final e in levelEps.where((e) => !exclude.contains(e.id))) {
    byIsland.putIfAbsent(e.island, () => []).add(e);
  }
  final keys = byIsland.keys.toList();
  final out = <String>[];
  var round = 0;
  while (out.length < n && keys.isNotEmpty) {
    var any = false;
    for (final k in keys) {
      final l = byIsland[k]!;
      if (round < l.length && out.length < n) {
        out.add(l[round].id);
        any = true;
      }
    }
    if (!any) break;
    round++;
  }
  return out;
}

/// 기기 저장 + 화면 갱신 알림.
class CurriculumStore {
  CurriculumStore._();
  static final CurriculumStore instance = CurriculumStore._();

  CurriculumState state = CurriculumState();
  final ValueNotifier<int> changed = ValueNotifier(0);
  bool _loaded = false;

  /// 테스트에서 날짜를 고정할 때.
  DateTime Function() now = DateTime.now;
  String get today => dayOf(now());

  Future<void> load() async {
    if (_loaded) return;
    final raw = (await SharedPreferences.getInstance()).getString(pk(kCurriculumKey));
    if (raw != null) {
      try {
        state = CurriculumState.fromJson((json.decode(raw) as Map).cast<String, dynamic>());
      } catch (_) {}
    }
    state.rollDay(today);
    _loaded = true;
  }

  Future<void> save() async {
    state.touchStreak(today);
    changed.value++;
    await (await SharedPreferences.getInstance()).setString(pk(kCurriculumKey), json.encode(state.toJson()));
  }

  Future<void> setLevel(String level) async {
    state.level = level;
    await save();
  }

  Future<void> setDailyGoal(int g) async {
    state.dailyGoal = g;
    await save();
  }

  Future<void> startCourse(List<String> ids) async {
    state.course = Course(id: 'c${now().millisecondsSinceEpoch}', dialogueIds: ids);
    await save();
  }

  Future<void> dropCourse() async {
    state.course = null;
    await save();
  }

  /// 편 연습을 마침: 연습한 줄을 모두 복습 대기열에(틀린 줄도 포함), 오늘 새 편 +1.
  Future<void> finishPractice(DramaEpisode e) async {
    final c = state.course;
    final t = today;
    state.rollDay(t);
    for (final turn in quizTurns(e)) {
      state.enqueue(lineIdOf(e.id, turn.num), t);
    }
    if (c != null && !c.practiced.contains(e.id)) {
      c.practiced.add(e.id);
      state.todayNew++;
    }
    await save();
  }

  /// 시험 결과: 80% 이상이면 코스 통과(편 모두 통과 표시), 아니면 틀린 편만 다시 연습.
  Future<bool> finishExam(int correct, int total, Set<String> wrongEpisodes) async {
    final c = state.course;
    if (c == null) return false;
    final pct = scorePercent(correct, total);
    c.examScores.add(pct);
    final pass = pct >= kPassPercent;
    if (pass) {
      c.passedAt = today;
      state.passedDialogues.addAll(c.dialogueIds);
    } else {
      c.practiced.removeWhere(wrongEpisodes.contains);
    }
    await save();
    return pass;
  }

  Future<void> answerReview(String lineId, bool correct) async {
    final t = today;
    state.rollDay(t);
    state.answerReview(lineId, correct, t);
    state.todayReview++;
    await save();
  }

  /// 레벨의 편을 모두 통과했으면 다음 레벨로 올린다. 올렸으면 새 레벨.
  Future<String?> advanceLevelIfDone(DramaService svc) async {
    final lv = state.level;
    if (lv == null) return null;
    final eps = svc.list(lv);
    if (eps.isEmpty || !eps.every((e) => state.passedDialogues.contains(e.id))) return null;
    final i = DramaService.levels.indexOf(lv);
    for (var k = i + 1; k < DramaService.levels.length; k++) {
      if (svc.count(DramaService.levels[k]) > 0) {
        state.level = DramaService.levels[k];
        await save();
        return state.level;
      }
    }
    return null;
  }

  /// 오늘 복습할 문제(기한 지난 것, 상한 안에서).
  List<CQuestion> reviewQuestions(DramaService svc, {Random? rnd}) {
    final r = rnd ?? Random();
    final t = today;
    final left = state.reviewLeft(t);
    final due = state.dueOn(t)..sort((a, b) => a.due.compareTo(b.due));
    final out = <CQuestion>[];
    for (final it in due) {
      if (out.length >= left) break;
      final parts = it.lineId.split('#');
      final e = svc.byId(parts.first);
      final n = int.tryParse(parts.length > 1 ? parts[1] : '');
      if (e == null || n == null) {
        state.review.remove(it); // 원고에서 사라진 줄
        continue;
      }
      final turn = e.turns.where((x) => x.num == n).firstOrNull;
      if (turn == null) {
        state.review.remove(it);
        continue;
      }
      final pool = [...quizTurns(e), ...svc.list(e.region).take(6).expand(quizTurns)];
      final q = makeQuestion(e, turn, pool, r);
      if (q != null) out.add(q);
    }
    return out;
  }
}
