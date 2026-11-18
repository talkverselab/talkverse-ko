import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../core/embed_env.dart';
import '../../core/l10n.dart';
import '../../core/pane.dart';
import '../../core/platform.dart';
import '../../drama/drama_theme.dart';
import '../../drama/roman_toggle.dart';
import '../../services/learner_prefs.dart';
import '../../services/tts_service.dart';
import 'loanword_quiz_screen.dart';

/// 외래어 익히기(일본어앱 「외국어 단어」 빌드 110 옮김 2026-11-18) — 영어가 한국어 소리로 바뀌는 규칙(줄기)별 단어, 3단계, 퀴즈 복습.
/// 데이터 `assets/data/vocab/loanwords.json`(설명은 영어 — 학습자가 영어권).
class LoanwordScreen extends StatefulWidget {
  /// 언어감각 과정에서 열면 「규칙 한눈에」부터.
  final bool rulesFirst;
  const LoanwordScreen({super.key, this.rulesFirst = false});

  @override
  State<LoanwordScreen> createState() => _LoanwordScreenState();
}

class _Branch {
  final String id, title, emoji, rule;
  final List<_Word> words;
  const _Branch(this.id, this.title, this.emoji, this.rule, this.words);
}

class _Word {
  final String ko, rd, en, meaning;
  final String? note;
  final bool ex;
  final int st;
  const _Word(this.ko, this.rd, this.en, this.meaning, this.note, this.ex, this.st);
}

class _LoanwordScreenState extends State<LoanwordScreen> {
  List<_Branch> _branches = [];
  bool _loading = true;
  late int _tab = widget.rulesFirst ? -1 : 0; // -1 = 규칙 한눈에
  String _intro = '';
  List<List<String>> _table = [];
  int _stage = 1;

  List<_Word> _visible(_Branch b) => b.words.where((w) => w.st <= _stage).toList();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final j = json.decode(utf8.decode((await rootBundle.load(assetPath('assets/data/vocab/loanwords.json'))).buffer.asUint8List()) /* loadString 은 큰 파일을 다른 isolate 에서 풀어 위젯 테스트가 멈춘다 */) as Map<String, dynamic>;
    final branches = [
      for (final b in (j['branches'] as List).cast<Map<String, dynamic>>())
        _Branch(b['id'] as String, b['title'] as String, (b['emoji'] as String?) ?? '', (b['rule'] as String?) ?? '', [
          for (final w in (b['words'] as List).cast<Map<String, dynamic>>())
            _Word(w['ko'] as String, (w['rd'] as String?) ?? '', (w['en'] as String?) ?? '', (w['meaning'] as String?) ?? (w['en'] as String? ?? ''),
                w['note'] as String?, w['ex'] == true, (w['st'] as int?) ?? 1),
        ]),
    ];
    // 표 한 줄 = [영어 소리, 한글, 예] — 목록이든 맵이든 받는다
    List<String> row(dynamic r) => r is List
        ? r.map((e) => '$e').toList()
        : [for (final k in const ['en', 'ko', 'example']) if ((r as Map)[k] != null) '${r[k]}'];
    if (!mounted) return;
    setState(() {
      _intro = (j['intro'] as String?) ?? '';
      _table = [for (final r in (j['rules_table'] as List? ?? const [])) row(r)];
      _branches = branches;
      _loading = false;
    });
  }

  Widget _chip(String label, bool selected, Color color, VoidCallback onTap, {Key? key}) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          key: key,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: selected ? color : DramaColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color, width: selected ? 1.5 : 0.8),
            ),
            child: Text(label, style: TextStyle(color: selected ? Colors.white : color, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final total = _branches.fold(0, (s, b) => s + _visible(b).length);
    return Scaffold(
      backgroundColor: DramaColors.bg,
      appBar: AppBar(
        title: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(tr('외래어 익히기'), style: const TextStyle(color: DramaColors.ink, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(trf('{0}단계 · {1}줄기 · {2}어', [_stage, _branches.length, total]), style: const TextStyle(color: DramaColors.muted, fontSize: 10, letterSpacing: 1)),
        ]),
        actions: const [RomanToggleAction()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Container(
                color: DramaColors.jadeSoft,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    for (final st in const [1, 2, 3])
                      _chip(
                        trf(['1단계 핵심 {0}', '2단계 중급까지 {0}', '3단계 전체 {0}'][st - 1], [_branches.fold<int>(0, (s, b) => s + b.words.where((w) => w.st <= st).length)]),
                        _stage == st,
                        DramaColors.jade,
                        () => setState(() => _stage = st),
                      ),
                    _chip(tr('📝 퀴즈 복습'), false, DramaColors.ink, key: const ValueKey('loan-quiz'), () {
                      openFull(context, (_) => LoanwordQuizScreen(words: [for (final b in _branches) for (final w in _visible(b)) LQWord(w.ko, w.en, w.meaning)]));
                    }),
                  ]),
                ),
              ),
              Container(
                color: DramaColors.jadeSoft,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Builder(builder: (context) {
                  Widget chip(int k) => k == 0
                      ? _chip(tr('📏 규칙 한눈에'), _tab == -1, DramaColors.jade, key: const ValueKey('loan-rules'), () => setState(() => _tab = -1))
                      : _chip('${_branches[k - 1].emoji} ${_branches[k - 1].title} ${_visible(_branches[k - 1]).length}', _tab == k - 1, DramaColors.ink, () => setState(() => _tab = k - 1));
                  final n = _branches.length + 1, half = (n + 1) ~/ 2;
                  // 줄기 칩 두 줄 — 가로로 함께 넘긴다(일본어앱 빌드 112)
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [for (var k = 0; k < half; k++) chip(k)]),
                      const SizedBox(height: 6),
                      Row(children: [for (var k = half; k < n; k++) chip(k)]),
                    ]),
                  );
                }),
              ),
              Expanded(child: _tab < 0 || _branches.isEmpty ? _rulesView() : _branchView(_branches[_tab])),
            ]),
    );
  }

  Widget _branchView(_Branch b) {
    final words = _visible(b);
    return ListView(
      key: PageStorageKey(b.id),
      padding: EdgeInsets.fromLTRB(16, 12, 16, 80 + bottomInset(context)),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: DramaColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: DramaColors.line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${b.emoji} ${b.title}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: DramaColors.ink)),
            const SizedBox(height: 6),
            Text(b.rule, style: const TextStyle(fontSize: 13, color: DramaColors.body, height: 1.5)),
          ]),
        ),
        const SizedBox(height: 10),
        for (final w in words) _wordRow(w),
      ],
    );
  }

  Widget _wordRow(_Word w) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
        decoration: BoxDecoration(
          color: DramaColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: w.ex ? const Color(0xFFB26A00) : DramaColors.line),
        ),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(w.ko, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: DramaColors.ink)),
                if (w.ex) ...[
                  const SizedBox(width: 6),
                  Text(tr('예외'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFB26A00))),
                ],
              ]),
              ValueListenableBuilder<bool>(
                valueListenable: LearnerPrefs.roman,
                builder: (_, on, _) => on && w.rd.isNotEmpty ? Text(w.rd, style: const TextStyle(fontSize: 11.5, color: DramaColors.muted)) : const SizedBox.shrink(),
              ),
              Text(w.meaning == w.en ? w.en : '${w.en} → ${w.meaning}', style: const TextStyle(fontSize: 13, color: DramaColors.jade, fontWeight: FontWeight.w700)),
              if (w.note != null) Text(w.note!, style: const TextStyle(fontSize: 12, color: DramaColors.muted, height: 1.4)),
            ]),
          ),
          IconButton(tooltip: tr('듣기'), icon: const Icon(Icons.volume_up, color: DramaColors.jade), onPressed: () => TtsService.instance.speak(w.ko)),
        ]),
      );

  Widget _rulesView() => ListView(
        key: const PageStorageKey('rules'),
        padding: EdgeInsets.fromLTRB(16, 12, 16, 80 + bottomInset(context)),
        children: [
          if (_intro.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: DramaColors.jadeSoft, borderRadius: BorderRadius.circular(10)),
              child: Text(_intro, style: const TextStyle(fontSize: 13, color: DramaColors.ink, height: 1.5)),
            ),
          const SizedBox(height: 12),
          for (final r in _table)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(color: DramaColors.card, borderRadius: BorderRadius.circular(10), border: Border.all(color: DramaColors.line)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 4, child: Text(r.isNotEmpty ? r[0] : '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: DramaColors.ink))),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('→', style: TextStyle(color: DramaColors.muted))),
                  Expanded(flex: 5, child: Text(r.length > 1 ? r[1] : '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: DramaColors.jade))),
                ]),
                if (r.length > 2) ...[
                  const SizedBox(height: 4),
                  Text(r.sublist(2).join(' · '), style: const TextStyle(fontSize: 12.5, color: DramaColors.body, height: 1.4)),
                ],
              ]),
            ),
        ],
      );
}
