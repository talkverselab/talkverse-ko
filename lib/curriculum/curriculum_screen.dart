import 'dart:math';

import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/platform.dart';
import '../drama/drama_audio.dart';
import '../drama/drama_service.dart';
import '../drama/drama_theme.dart';
import 'curriculum_store.dart';

/// 토크버스 커리큘럼 화면들 — 기준 `~/talkverse/CURRICULUM_SPEC.md`. 상태·규칙은 [CurriculumStore].
String levelLabel(String lv) => '$lv · ${tr(DramaService.levelKo[lv] ?? lv)}';

String goalLabel(int g) => switch (g) { 1 => tr('가볍게'), 3 => tr('집중'), _ => tr('보통') };

EdgeInsets _pad(BuildContext c) => EdgeInsets.fromLTRB(16, 12, 16, 24 + bottomInset(c));

Widget _card({required Widget child, Color color = Colors.white}) => Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12), border: Border.all(color: DramaColors.line)),
      child: child,
    );

Widget _h(String s) => Padding(
      padding: const EdgeInsets.fromLTRB(2, 12, 2, 8),
      child: Text(s, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: DramaColors.muted)),
    );

/// 오늘 분량 요약 — 홈 카드와 코스 화면이 같이 쓴다.
class TodaySummary extends StatelessWidget {
  final CurriculumState s;
  final String today;
  const TodaySummary({super.key, required this.s, required this.today});
  @override
  Widget build(BuildContext context) {
    final rv = s.reviewLeft(today), nw = s.newLeft(today);
    final done = s.todayReview + min(s.todayNew, s.dailyGoal);
    final total = done + rv + nw;
    final streak = s.streakShown(today);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        s.dailyDone(today) ? tr('오늘 분량 끝') : trf('오늘: 복습 {0} · 새 편 {1}', [rv, nw]),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: DramaColors.ink),
      ),
      const SizedBox(height: 8),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(value: total == 0 ? 1 : done / total, minHeight: 6, color: DramaColors.jade, backgroundColor: DramaColors.jadeSoft),
      ),
      if (streak > 0) ...[const SizedBox(height: 6), Text(trf('연속 {0}일', [streak]), style: const TextStyle(fontSize: 12, color: DramaColors.jade, fontWeight: FontWeight.w600))],
    ]);
  }
}

/// 홈(배우기 탭) 맨 위 카드.
class CurriculumHomeCard extends StatefulWidget {
  final VoidCallback onOpen;
  const CurriculumHomeCard({super.key, required this.onOpen});
  @override
  State<CurriculumHomeCard> createState() => _CurriculumHomeCardState();
}

class _CurriculumHomeCardState extends State<CurriculumHomeCard> {
  final st = CurriculumStore.instance;
  bool _ready = false;
  @override
  void initState() {
    super.initState();
    st.load().then((_) => mounted ? setState(() => _ready = true) : null);
    st.changed.addListener(_tick);
  }

  void _tick() => mounted ? setState(() {}) : null;
  @override
  void dispose() {
    st.changed.removeListener(_tick);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
        key: const Key('curriculum-card'),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: DramaColors.line)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onOpen,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.route, color: DramaColors.jade, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(tr('토크버스 커리큘럼'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: DramaColors.ink))),
                if (_ready && st.state.level != null) Text(levelLabel(st.state.level!), style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
                const Icon(Icons.chevron_right, color: DramaColors.muted, size: 20),
              ]),
              const SizedBox(height: 10),
              if (!_ready)
                const SizedBox(height: 36)
              else if (st.state.level == null)
                Text(tr('레벨을 고르고 다이얼로그를 골라 코스를 시작하세요'), style: const TextStyle(fontSize: 13, color: DramaColors.body))
              else
                TodaySummary(s: st.state, today: st.today),
            ]),
          ),
        ),
      );
}

/// 커리큘럼 첫 화면: 레벨이 없으면 레벨 고르기, 있으면 코스 화면.
class CurriculumScreen extends StatefulWidget {
  const CurriculumScreen({super.key});
  @override
  State<CurriculumScreen> createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumScreen> {
  final st = CurriculumStore.instance;
  final svc = DramaService.instance;
  bool _ready = false, _pickLevel = false, _confirmDrop = false;

  @override
  void initState() {
    super.initState();
    Future.wait([st.load(), svc.ensureLoaded()]).then((_) => mounted ? setState(() => _ready = true) : null);
  }

  Future<void> _push(Widget w) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));
    final up = await st.advanceLevelIfDone(svc);
    if (!mounted) return;
    setState(() {});
    if (up != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(trf('레벨을 모두 통과! 다음 레벨: {0}', [levelLabel(up)]))));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: DramaColors.bg,
        appBar: AppBar(title: Text(tr('토크버스 커리큘럼')), backgroundColor: DramaColors.bg, surfaceTintColor: Colors.transparent),
        body: !_ready
            ? const Center(child: CircularProgressIndicator())
            : (st.state.level == null || _pickLevel)
                ? _levelPicker()
                : _home(),
      );

  Widget _levelPicker() {
    final lv = DramaService.levels.where((l) => svc.count(l) > 0).toList();
    return ListView(padding: _pad(context), children: [
      Text(tr('회화 레벨을 고르세요'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: DramaColors.ink)),
      const SizedBox(height: 4),
      Text(tr('처음이면 가장 낮은 레벨부터 권합니다'), style: const TextStyle(fontSize: 13, color: DramaColors.body)),
      const SizedBox(height: 12),
      for (final l in lv)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            key: Key('level-$l'),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: l == st.state.level ? DramaColors.jade : DramaColors.line)),
            title: Text(levelLabel(l), style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(trf('{0}편 · 통과 {1}', [svc.count(l), svc.list(l).where((e) => st.state.passedDialogues.contains(e.id)).length])),
            trailing: l == lv.first && st.state.level == null ? Chip(label: Text(tr('추천')), backgroundColor: DramaColors.jadeSoft) : null,
            onTap: () async {
              await st.setLevel(l);
              setState(() => _pickLevel = false);
            },
          ),
        ),
    ]);
  }

  Widget _home() {
    final s = st.state, today = st.today, c = s.course;
    final active = c != null && c.passedAt == null;
    return ListView(padding: _pad(context), children: [
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(levelLabel(s.level!), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: DramaColors.ink))),
            TextButton(onPressed: () => setState(() => _pickLevel = true), child: Text(tr('레벨 바꾸기'))),
          ]),
          const SizedBox(height: 4),
          TodaySummary(s: s, today: today),
          const SizedBox(height: 10),
          Text(tr('하루 목표'), style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
          const SizedBox(height: 4),
          Wrap(spacing: 6, children: [
            for (final g in kDailyGoals)
              ChoiceChip(
                label: Text(trf('{0}(새 편 {1})', [goalLabel(g), g])),
                selected: s.dailyGoal == g,
                onSelected: (_) async {
                  await st.setDailyGoal(g);
                  setState(() {});
                },
              ),
          ]),
        ]),
      ),
      if (s.reviewLeft(today) > 0)
        FilledButton.icon(
          key: const Key('curriculum-review'),
          icon: const Icon(Icons.replay),
          label: Text(trf('복습 {0}문제 하기', [s.reviewLeft(today)])),
          onPressed: () {
            final qs = st.reviewQuestions(svc);
            if (qs.isEmpty) return setState(() {});
            _push(QuizScreen(title: tr('복습'), questions: qs, onAnswer: (q, ok) => st.answerReview(q.lineId, ok)));
          },
        ),
      if (active) ..._course(c) else ..._noCourse(c),
    ]);
  }

  List<Widget> _noCourse(Course? c) => [
        if (c?.passedAt != null)
          _card(color: DramaColors.jadeSoft, child: Text(trf('지난 코스 통과 · {0}점', [c!.examScores.last]), style: const TextStyle(fontWeight: FontWeight.w700, color: DramaColors.ink))),
        _h(tr('다음 코스')),
        FilledButton(
          key: const Key('curriculum-new-course'),
          onPressed: () => _push(CourseBuilderScreen(level: st.state.level!)),
          child: Text(tr('다이얼로그 골라 코스 만들기')),
        ),
      ];

  List<Widget> _course(Course c) {
    final eps = c.dialogueIds.map(svc.byId).whereType<DramaEpisode>().toList();
    return [
      _h(trf('지금 코스 · 연습 {0}/{1}', [c.practiced.where(c.dialogueIds.contains).length, c.dialogueIds.length])),
      for (final e in eps)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: DramaColors.line)),
            leading: Text(e.emoji, style: const TextStyle(fontSize: 22)),
            title: Text(DramaEpisode.fill(e.title), maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(tr(DramaService.islandKo[e.island] ?? e.island)),
            trailing: c.practiced.contains(e.id) ? const Icon(Icons.check_circle, color: DramaColors.jade) : Text(tr('연습하기'), style: const TextStyle(color: DramaColors.jade, fontWeight: FontWeight.w700)),
            onTap: () => _push(PracticeScreen(episode: e)),
          ),
        ),
      if (c.examScores.isNotEmpty) Text(trf('지난 시험 {0}점 — 80점 이상이면 통과', [c.examScores.last]), style: const TextStyle(fontSize: 12.5, color: DramaColors.body)),
      const SizedBox(height: 8),
      FilledButton(
        key: const Key('curriculum-exam'),
        onPressed: c.allPracticed && eps.isNotEmpty
            ? () {
                final pool = svc.list(st.state.level!).take(8).expand(quizTurns).toList();
                final qs = examQuestions(eps, pool);
                _push(QuizScreen(title: tr('코스 시험'), questions: qs, exam: true));
              }
            : null,
        child: Text(c.allPracticed ? tr('코스 시험 보기') : tr('모든 편을 연습하면 코스 시험')),
      ),
      const SizedBox(height: 16),
      if (!_confirmDrop)
        TextButton(onPressed: () => setState(() => _confirmDrop = true), child: Text(tr('새 코스 시작'))),
      if (_confirmDrop)
        _card(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tr('지금 코스를 버리고 새 코스를 만들까요? 연습 기록은 복습에 남습니다.'), style: const TextStyle(color: DramaColors.ink)),
            const SizedBox(height: 8),
            Row(children: [
              TextButton(onPressed: () => setState(() => _confirmDrop = false), child: Text(tr('취소'))),
              const Spacer(),
              FilledButton(
                key: const Key('curriculum-drop'),
                onPressed: () async {
                  await st.dropCourse();
                  setState(() => _confirmDrop = false);
                },
                child: Text(tr('버리고 새로')),
              ),
            ]),
          ]),
        ),
    ];
  }
}

/// 코스 만들기: 3·5·10편 고르기 + 「추천으로 채우기」.
class CourseBuilderScreen extends StatefulWidget {
  final String level;
  const CourseBuilderScreen({super.key, required this.level});
  @override
  State<CourseBuilderScreen> createState() => _CourseBuilderScreenState();
}

class _CourseBuilderScreenState extends State<CourseBuilderScreen> {
  final st = CurriculumStore.instance;
  int n = 5;
  final List<String> picked = [];

  @override
  Widget build(BuildContext context) {
    final eps = DramaService.instance.list(widget.level);
    final passed = st.state.passedDialogues;
    return Scaffold(
      backgroundColor: DramaColors.bg,
      appBar: AppBar(title: Text(trf('코스 만들기 · {0}', [levelLabel(widget.level)])), backgroundColor: DramaColors.bg, surfaceTintColor: Colors.transparent),
      body: ListView(padding: EdgeInsets.fromLTRB(16, 12, 16, 96 + bottomInset(context)), children: [
        Text(tr('몇 편으로 할까요?'), style: const TextStyle(fontWeight: FontWeight.w700, color: DramaColors.ink)),
        const SizedBox(height: 6),
        Wrap(spacing: 6, children: [
          for (final k in kCourseSizes)
            ChoiceChip(
              label: Text(trf('{0}편', [k])),
              selected: n == k,
              onSelected: (_) => setState(() {
                n = k;
                if (picked.length > n) picked.removeRange(n, picked.length);
              }),
            ),
        ]),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          key: const Key('curriculum-recommend'),
          icon: const Icon(Icons.auto_awesome, size: 18),
          label: Text(tr('추천으로 채우기')),
          onPressed: () => setState(() {
            final add = recommend(eps, {...passed, ...picked}, n - picked.length);
            if (add.length < n - picked.length) add.addAll(recommend(eps, picked.toSet(), n - picked.length - add.length)); // 안 한 편이 모자라면 통과한 편도
            picked.addAll(add);
          }),
        ),
        _h(trf('고른 편 {0}/{1} · 통과한 편도 다시 고를 수 있어요', [picked.length, n])),
        for (final e in eps)
          CheckboxListTile(
            key: Key('pick-${e.id}'),
            value: picked.contains(e.id),
            onChanged: (v) => setState(() {
              if (v == true && picked.length < n) picked.add(e.id);
              if (v == false) picked.remove(e.id);
            }),
            secondary: Text(e.emoji, style: const TextStyle(fontSize: 20)),
            title: Text(DramaEpisode.fill(e.title), maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text([tr(DramaService.islandKo[e.island] ?? e.island), if (passed.contains(e.id)) tr('통과')].join(' · ')),
            dense: true,
          ),
      ]),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset(context)),
        child: FilledButton(
          key: const Key('curriculum-start'),
          onPressed: picked.length == n
              ? () async {
                  await st.startCourse(List.of(picked));
                  if (context.mounted) Navigator.of(context).pop();
                }
              : null,
          child: Text(trf('코스 시작 ({0}/{1})', [picked.length, n])),
        ),
      ),
    );
  }
}

/// 편 연습: 1) 듣기·읽기(줄마다 뜻) 2) 따라 말하기(줄 반복 듣기, 채점 없음) 3) 확인 문제.
class PracticeScreen extends StatefulWidget {
  final DramaEpisode episode;
  const PracticeScreen({super.key, required this.episode});
  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  bool _meaning = false;
  int? _playing;
  bool _stopAll = false;

  DramaEpisode get e => widget.episode;

  Future<void> _playAll() async {
    _stopAll = false;
    for (final t in e.turns) {
      if (_stopAll || !mounted) break;
      setState(() => _playing = t.num);
      await speakTurn(e, e.view(t));
    }
    if (mounted) setState(() => _playing = null);
  }

  Future<void> _playOne(DramaTurn t) async {
    _stopAll = true;
    await DramaAudio.instance.stop();
    setState(() => _playing = t.num);
    await speakTurn(e, e.view(t));
    if (mounted) setState(() => _playing = null);
  }

  @override
  void dispose() {
    _stopAll = true;
    DramaAudio.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: DramaColors.bg,
        appBar: AppBar(title: Text(DramaEpisode.fill(e.title)), backgroundColor: DramaColors.bg, surfaceTintColor: Colors.transparent),
        body: ListView(padding: EdgeInsets.fromLTRB(16, 8, 16, 96 + bottomInset(context)), children: [
          Text(e.sceneShown, style: const TextStyle(fontSize: 13, color: DramaColors.body)),
          const SizedBox(height: 8),
          Row(children: [
            FilledButton.tonalIcon(onPressed: _playing == null ? _playAll : () async {
              _stopAll = true;
              await DramaAudio.instance.stop();
            }, icon: Icon(_playing == null ? Icons.play_arrow : Icons.stop), label: Text(_playing == null ? tr('전체 듣기') : tr('멈춤'))),
            const Spacer(),
            Text(tr('뜻'), style: const TextStyle(color: DramaColors.muted)),
            Switch(value: _meaning, onChanged: (v) => setState(() => _meaning = v)),
          ]),
          Text(tr('줄을 누르면 그 줄만 다시 들어요 — 따라 말해 보세요'), style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
          const SizedBox(height: 8),
          for (final t0 in e.turns)
            Builder(builder: (_) {
              final t = e.view(t0);
              final on = _playing == t.num;
              return InkWell(
                onTap: () => _playOne(t0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: on ? DramaColors.jadeSoft : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: on ? DramaColors.jade : DramaColors.line)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(e.speakerName(t.speaker), style: const TextStyle(fontSize: 11, color: DramaColors.muted)),
                    Text(DramaEpisode.fill(t.ko), style: const TextStyle(fontSize: 16, color: DramaColors.ink)),
                    if (_meaning && t.en.isNotEmpty) Text(DramaEpisode.fill(t.en), style: const TextStyle(fontSize: 12.5, color: DramaColors.body)),
                  ]),
                ),
              );
            }),
        ]),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset(context)),
          child: FilledButton(
            key: const Key('curriculum-quiz'),
            onPressed: () async {
              _stopAll = true;
              await DramaAudio.instance.stop();
              final pool = DramaService.instance.list(e.region).take(8).expand(quizTurns).toList();
              final qs = practiceQuestions(e, pool);
              if (!context.mounted) return;
              final nav = Navigator.of(context);
              await nav.push(MaterialPageRoute(builder: (_) => QuizScreen(title: tr('확인 문제'), questions: qs, practiceOf: e)));
              if (mounted) nav.pop();
            },
            child: Text(tr('확인 문제 풀기')),
          ),
        ),
      );
}

/// 문제 풀기 — 연습([practiceOf]) · 복습([onAnswer]) · 코스 시험([exam]) 공용.
class QuizScreen extends StatefulWidget {
  final String title;
  final List<CQuestion> questions;
  final DramaEpisode? practiceOf;
  final bool exam;
  final Future<void> Function(CQuestion q, bool ok)? onAnswer;
  const QuizScreen({super.key, required this.title, required this.questions, this.practiceOf, this.exam = false, this.onAnswer});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int i = 0, correct = 0;
  int? chosen;
  final Set<String> wrongEps = {};
  bool? passed;
  bool done = false;

  Future<void> _choose(int k) async {
    if (chosen != null) return;
    final q = widget.questions[i];
    final ok = k == q.answer;
    setState(() {
      chosen = k;
      if (ok) {
        correct++;
      } else {
        wrongEps.add(q.episodeId);
      }
    });
    await widget.onAnswer?.call(q, ok);
  }

  Future<void> _next() async {
    if (i + 1 < widget.questions.length) {
      setState(() {
        i++;
        chosen = null;
      });
      return;
    }
    final st = CurriculumStore.instance;
    if (widget.practiceOf != null) await st.finishPractice(widget.practiceOf!);
    if (widget.exam) passed = await st.finishExam(correct, widget.questions.length, wrongEps);
    setState(() => done = true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: DramaColors.bg,
        appBar: AppBar(title: Text(widget.title), backgroundColor: DramaColors.bg, surfaceTintColor: Colors.transparent),
        body: widget.questions.isEmpty ? _empty() : (done ? _result() : _question()),
      );

  Widget _empty() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(tr('만들 수 있는 문제가 없어요')),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                if (widget.practiceOf != null) await CurriculumStore.instance.finishPractice(widget.practiceOf!);
                if (mounted) Navigator.of(context).pop();
              },
              child: Text(tr('확인')),
            ),
          ]),
        ),
      );

  Widget _question() {
    final q = widget.questions[i];
    return ListView(padding: _pad(context), children: [
      LinearProgressIndicator(value: (i + 1) / widget.questions.length, color: DramaColors.jade, backgroundColor: DramaColors.jadeSoft),
      const SizedBox(height: 6),
      Text('${i + 1} / ${widget.questions.length}', style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
      const SizedBox(height: 12),
      Text(q.kind == 'blank' ? tr('빈칸에 알맞은 말은?') : tr('이 줄의 뜻은?'), style: const TextStyle(fontSize: 13, color: DramaColors.muted)),
      const SizedBox(height: 6),
      Row(children: [
        Expanded(child: Text(q.prompt, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: DramaColors.ink))),
        if (q.kind == 'meaning')
          IconButton(
            icon: const Icon(Icons.volume_up, color: DramaColors.jade),
            onPressed: () {
              final e = DramaService.instance.byId(q.episodeId);
              final t = e?.turns.where((x) => x.num == q.turn).firstOrNull;
              if (e != null && t != null) speakTurn(e, e.view(t));
            },
          ),
      ]),
      if (q.sub.isNotEmpty) Text(DramaEpisode.fill(q.sub), style: const TextStyle(fontSize: 13, color: DramaColors.body)),
      const SizedBox(height: 14),
      for (var k = 0; k < q.options.length; k++)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: OutlinedButton(
            key: Key('opt-$k'),
            style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(14),
              backgroundColor: chosen == null ? Colors.white : (k == q.answer ? DramaColors.jadeSoft : (k == chosen ? const Color(0xFFFDECEC) : Colors.white)),
              side: BorderSide(color: chosen != null && k == q.answer ? DramaColors.jade : DramaColors.line),
            ),
            onPressed: () => _choose(k),
            child: Text(DramaEpisode.fill(q.options[k]), style: const TextStyle(color: DramaColors.ink, fontSize: 15)),
          ),
        ),
      if (chosen != null) FilledButton(key: const Key('quiz-next'), onPressed: _next, child: Text(i + 1 < widget.questions.length ? tr('다음') : tr('끝내기'))),
    ]);
  }

  Widget _result() {
    final total = widget.questions.length;
    final pct = scorePercent(correct, total);
    final msg = widget.exam
        ? (passed == true ? tr('통과! 이 코스의 편을 모두 통과했어요') : tr('80점이 안 됐어요 — 틀린 편만 다시 연습한 뒤 다시 시험'))
        : (widget.practiceOf != null ? tr('연습 끝 — 줄은 복습에 들어갔어요') : tr('복습 끝'));
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('$pct', key: const Key('quiz-score'), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: DramaColors.jade)),
          Text(trf('{0}문제 중 {1}개 맞힘', [total, correct]), style: const TextStyle(color: DramaColors.body)),
          const SizedBox(height: 12),
          Text(msg, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, color: DramaColors.ink)),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(tr('확인'))),
        ]),
      ),
    );
  }
}
