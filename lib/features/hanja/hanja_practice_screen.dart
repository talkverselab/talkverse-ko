import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/embed_env.dart';
import '../../core/l10n.dart';
import '../../core/pane.dart';
import '../../core/platform.dart';
import '../../drama/drama_theme.dart';
import '../../services/tts_service.dart';
import '../../data/usage_pages.dart';

/// 한자 연습 — 하루 3자(일본어앱 빌드 112 옮김 2026-11-18; 원래 사용자 지시 2026-11-11 「패밀리가 많은 한자부터」·11-17 「하루 3자」).
/// 교육용 한자 중 소리 부품이 같은 글자 3자 이상 가족을 큰 가족부터. 하루 = 가족 보기 → 「이 글자의 가족(소리 부품)은?」 → 마침.
/// 데이터 `assets/data/hanja/families_ko.json`(한자유니버스 공용 DB 에서 뽑음 — 훈음·영어 뜻).
const int kHanjaPerDay = 3;
const int kHanjaReviewSize = 20;
String get _kDone => pk('hanja_practice_done');
String get _kWrong => pk('hanja_practice_wrong');

class HChar {
  final String ch, hun, en;
  const HChar(this.ch, this.hun, this.en);

  /// 음(소리) — 훈음 「붉을 홍」의 마지막 낱말.
  String get sound => hun.trim().split(RegExp(r'\s+')).last;
}

class HFamily {
  final String root, hun, en;
  final List<HChar> members;
  const HFamily(this.root, this.hun, this.en, this.members);
}

class HanjaPractice {
  static List<List<HFamily>>? _days;
  static List<String> roots = const [];

  static Future<List<List<HFamily>>> days() async {
    if (_days != null) return _days!;
    final j = json.decode(utf8.decode((await rootBundle.load(assetPath('assets/data/hanja/families_ko.json'))).buffer.asUint8List()) /* loadString 은 큰 파일을 다른 isolate 에서 풀어 위젯 테스트가 멈춘다 */) as Map<String, dynamic>;
    final fams = [
      for (final f in (j['families'] as List).cast<Map<String, dynamic>>())
        HFamily(f['root'] as String, (f['hun'] as String?) ?? '', (f['en'] as String?) ?? '', [
          for (final m in (f['members'] as List).cast<Map<String, dynamic>>()) HChar(m['ch'] as String, (m['hun'] as String?) ?? '', (m['en'] as String?) ?? ''),
        ]),
    ];
    roots = [for (final f in fams) f.root];
    final pairs = [for (final f in fams) for (final m in f.members) (f, m)];
    final days = <List<HFamily>>[];
    for (var i = 0; i < pairs.length; i += kHanjaPerDay) {
      final day = <HFamily>[];
      for (final (f, m) in pairs.sublist(i, min(i + kHanjaPerDay, pairs.length))) {
        if (day.isNotEmpty && day.last.root == f.root) {
          day.last.members.add(m);
        } else {
          day.add(HFamily(f.root, f.hun, f.en, [m]));
        }
      }
      days.add(day);
    }
    return _days = days;
  }

  static Future<Set<String>> done() async => ((await SharedPreferences.getInstance()).getStringList(_kDone) ?? const []).toSet();
  static Future<Set<String>> wrong() async => ((await SharedPreferences.getInstance()).getStringList(_kWrong) ?? const []).toSet();
  static Future<void> answer(String c, bool ok) async {
    final p = await SharedPreferences.getInstance();
    final s = (p.getStringList(_kWrong) ?? <String>[]).toSet();
    ok ? s.remove(c) : s.add(c);
    await p.setStringList(_kWrong, s.toList());
  }

  static Future<void> markDone(int day) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_kDone, {...?p.getStringList(_kDone), '$day'}.toList());
  }
}

class HanjaPracticeScreen extends StatefulWidget {
  const HanjaPracticeScreen({super.key});
  @override
  State<HanjaPracticeScreen> createState() => _HanjaPracticeScreenState();
}

class _HanjaPracticeScreenState extends State<HanjaPracticeScreen> {
  List<List<HFamily>>? _days;
  Set<String> _done = {};

  @override
  void initState() {
    super.initState();
    UsagePages.view(UsagePages.hanja);
    _load();
  }

  Future<void> _load() async {
    final d = await HanjaPractice.days();
    final done = await HanjaPractice.done();
    if (mounted) {
      setState(() {
        _days = d;
        _done = done;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _days;
    return Scaffold(
      backgroundColor: DramaColors.bg,
      appBar: AppBar(title: Text(tr('한자 연습'))),
      body: days == null ? const Center(child: CircularProgressIndicator()) : _body(days),
    );
  }

  Widget _body(List<List<HFamily>> days) {
    final fams = days.expand((d) => d).map((f) => f.root).toSet().length;
    final chars = days.expand((d) => d).fold<int>(0, (a, f) => a + f.members.length);
    final next = List.generate(days.length, (i) => i + 1).firstWhere((n) => !_done.contains('$n'), orElse: () => -1);
    final learned = [for (var i = 0; i < days.length; i++) if (_done.contains('${i + 1}')) ...days[i]];
    final n = learned.fold<int>(0, (a, f) => a + f.members.length);
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 24 + bottomInset(context)),
      children: [
        Text(tr('가족이 큰 한자부터 — 소리 부품 하나로 여러 글자를 한 번에'), style: const TextStyle(fontSize: 13, color: DramaColors.muted)),
        const SizedBox(height: 4),
        Text(trf('{0}가족 · {1}자 · 하루 {2}자 · {3}일', [fams, chars, kHanjaPerDay, days.length]), style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
        Text(trf('{0}/{1}일 마침', [_done.length, days.length]), style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
        const SizedBox(height: 10),
        FilledButton.icon(
          key: const ValueKey('hp-review'),
          style: FilledButton.styleFrom(backgroundColor: DramaColors.ink, minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: learned.isEmpty
              ? null
              : () async {
                  await openFull(context, (_) => HanjaReviewScreen(learned: learned));
                  _load();
                },
          icon: const Icon(Icons.replay),
          label: Text(learned.isEmpty ? tr('누적 복습 — 1일차를 마치면 열려요') : trf('누적 복습 · {0}자에서 {1}문제', [n, min(kHanjaReviewSize, n)]), style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < days.length; i++) _dayRow(i + 1, days[i], next == i + 1),
      ],
    );
  }

  Widget _dayRow(int n, List<HFamily> fams, bool isNext) {
    final isDone = _done.contains('$n');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isNext ? DramaColors.jadeSoft : DramaColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isNext ? DramaColors.jade : DramaColors.line, width: isNext ? 1.4 : 1)),
        child: InkWell(
          key: ValueKey('hp-day-$n'),
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            await openFull(context, (_) => HanjaPracticeDayScreen(day: n, families: fams));
            _load();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(children: [
              SizedBox(width: 56, child: Text(trf('{0}일차', [n]), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: DramaColors.jade))),
              Expanded(child: Text(fams.expand((f) => f.members).map((m) => m.ch).join('  '), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: DramaColors.ink))),
              if (isDone)
                const Icon(Icons.check_circle, color: DramaColors.jade, size: 20)
              else if (isNext)
                Text(tr('다음'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: DramaColors.jade)),
            ]),
          ),
        ),
      ),
    );
  }
}

class _FamilyCard extends StatelessWidget {
  final HFamily f;
  const _FamilyCard(this.f);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: DramaColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: DramaColors.line)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Text(f.root, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: DramaColors.jade)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(trf('소리 부품 「{0}」', [f.root]), style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
                Text('${f.hun}  ·  ${f.en}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: DramaColors.ink)),
              ]),
            ),
          ]),
          const Divider(height: 18),
          for (final m in f.members)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                SizedBox(width: 56, child: Text(m.ch, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: DramaColors.ink))),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(m.hun, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: DramaColors.ink)),
                    Text(m.en, style: const TextStyle(fontSize: 13, color: DramaColors.jade, fontWeight: FontWeight.w600)),
                  ]),
                ),
                IconButton(tooltip: tr('듣기'), icon: const Icon(Icons.volume_up, color: DramaColors.jade), onPressed: () => TtsService.instance.speak(m.hun)),
              ]),
            ),
        ]),
      );
}

/// 문제 한 벌 — 글자를 보고 가족(소리 부품)을 고른다. 하루 화면과 누적 복습이 같이 쓴다.
class _Quiz extends StatefulWidget {
  final List<(HChar, HFamily)> items;
  final VoidCallback? onFinish;
  final String finishLabel;
  const _Quiz({required this.items, this.onFinish, required this.finishLabel});
  @override
  State<_Quiz> createState() => _QuizState();
}

class _QuizState extends State<_Quiz> {
  late List<(HChar, HFamily, List<String>)> _qs;
  int _i = 0;
  String? _picked;
  int _right = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    final rnd = Random();
    List<String> opts(HFamily f) {
      final o = <String>{f.root, ...widget.items.map((e) => e.$2.root)};
      final pool = [...HanjaPractice.roots]..shuffle(rnd);
      final out = <String>{f.root};
      for (final r in [...o..remove(f.root), ...pool]) {
        if (out.length >= 4) break;
        out.add(r);
      }
      return out.toList()..shuffle(rnd);
    }

    _qs = [for (final (m, f) in widget.items) (m, f, opts(f))];
    setState(() {
      _i = 0;
      _picked = null;
      _right = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_i >= _qs.length) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🎉', style: TextStyle(fontSize: 44)),
          const SizedBox(height: 10),
          Text(trf('{0}문제 중 {1}개 맞힘', [_qs.length, _right]), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: DramaColors.ink)),
          const SizedBox(height: 12),
          Row(mainAxisSize: MainAxisSize.min, children: [
            OutlinedButton(onPressed: _start, child: Text(tr('한 번 더'))),
            const SizedBox(width: 10),
            FilledButton(
              key: const ValueKey('hp-finish'),
              style: FilledButton.styleFrom(backgroundColor: DramaColors.jade),
              onPressed: widget.onFinish ?? () => Navigator.of(context).maybePop(),
              child: Text(widget.finishLabel),
            ),
          ]),
        ]),
      );
    }
    final (c, fam, options) = _qs[_i];
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset(context)),
      child: Column(children: [
        Text('${_i + 1} / ${_qs.length}', style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
        const SizedBox(height: 16),
        Text(c.ch, style: const TextStyle(fontSize: 96, fontWeight: FontWeight.w900, color: DramaColors.ink)),
        if (_picked != null) Text('${c.hun}  ·  ${c.en}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: DramaColors.jade, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Text(tr('이 글자의 가족(소리 부품)은?'), style: const TextStyle(fontSize: 14, color: DramaColors.ink)),
        const SizedBox(height: 14),
        Wrap(spacing: 12, runSpacing: 12, alignment: WrapAlignment.center, children: [
          for (final o in options)
            SizedBox(
              width: 88,
              height: 72,
              child: OutlinedButton(
                key: ValueKey('hp-opt-$o'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: _picked == null ? null : (o == fam.root ? const Color(0x3336A35B) : (o == _picked ? const Color(0x33D83A3A) : null)),
                  side: BorderSide(color: _picked != null && o == fam.root ? DramaColors.jade : DramaColors.line, width: 1.4),
                ),
                onPressed: _picked != null
                    ? null
                    : () {
                        TtsService.instance.speak(c.hun);
                        HanjaPractice.answer(c.ch, o == fam.root);
                        setState(() {
                          _picked = o;
                          if (o == fam.root) _right++;
                        });
                      },
                child: Text(o, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: DramaColors.ink)),
              ),
            ),
        ]),
        const SizedBox(height: 20),
        if (_picked != null)
          FilledButton(
            key: const ValueKey('hp-next'),
            style: FilledButton.styleFrom(backgroundColor: DramaColors.ink, minimumSize: const Size.fromHeight(48)),
            onPressed: () => setState(() {
              _i++;
              _picked = null;
            }),
            child: Text(tr('다음 →')),
          ),
      ]),
    );
  }
}

/// 하루 — 가족 보기 → 문제 → 마침(기록).
class HanjaPracticeDayScreen extends StatefulWidget {
  final int day;
  final List<HFamily> families;
  const HanjaPracticeDayScreen({super.key, required this.day, required this.families});
  @override
  State<HanjaPracticeDayScreen> createState() => _HanjaPracticeDayScreenState();
}

class _HanjaPracticeDayScreenState extends State<HanjaPracticeDayScreen> {
  bool _quiz = false;

  @override
  Widget build(BuildContext context) {
    final items = [for (final f in widget.families) for (final m in f.members) (m, f)]..shuffle();
    return Scaffold(
      backgroundColor: DramaColors.bg,
      appBar: AppBar(title: Text('${trf('{0}일차', [widget.day])}  ${widget.families.expand((f) => f.members).map((m) => m.ch).join(' ')}')),
      body: _quiz
          ? _Quiz(
              items: items,
              finishLabel: tr('마침'),
              onFinish: () async {
                await HanjaPractice.markDone(widget.day);
                if (context.mounted) Navigator.of(context).maybePop();
              },
            )
          : ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 16), children: [for (final f in widget.families) _FamilyCard(f)]),
      bottomNavigationBar: _quiz
          ? null
          : Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset(context)),
              child: FilledButton(
                key: const ValueKey('hp-start'),
                style: FilledButton.styleFrom(backgroundColor: DramaColors.jade, minimumSize: const Size.fromHeight(48)),
                onPressed: () => setState(() => _quiz = true),
                child: Text(tr('문제 풀기')),
              ),
            ),
    );
  }
}

/// 누적 복습 — 마친 날의 글자에서 20문제, 틀린 글자 먼저.
class HanjaReviewScreen extends StatefulWidget {
  final List<HFamily> learned;
  const HanjaReviewScreen({super.key, required this.learned});
  @override
  State<HanjaReviewScreen> createState() => _HanjaReviewScreenState();
}

class _HanjaReviewScreenState extends State<HanjaReviewScreen> {
  List<(HChar, HFamily)>? _items;

  @override
  void initState() {
    super.initState();
    HanjaPractice.wrong().then((wrong) {
      final all = [for (final f in widget.learned) for (final m in f.members) (m, f)]..shuffle();
      all.sort((a, b) => (wrong.contains(b.$1.ch) ? 1 : 0) - (wrong.contains(a.$1.ch) ? 1 : 0));
      if (mounted) setState(() => _items = all.take(kHanjaReviewSize).toList()..shuffle());
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: DramaColors.bg,
        appBar: AppBar(title: Text(tr('누적 복습'))),
        body: _items == null ? const Center(child: CircularProgressIndicator()) : _Quiz(items: _items!, finishLabel: tr('나가기')),
      );
}
