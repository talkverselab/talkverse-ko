import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/embed_env.dart';
import '../../core/l10n.dart';
import '../../core/platform.dart';
import '../../drama/drama_theme.dart';
import '../../services/tts_service.dart';

/// 외래어 퀴즈 복습(일본어앱 빌드 110 옮김 2026-11-18) — 표기(바르게 쓴 한글 고르기)와 뜻 고르기, 보기 1~4, 10문제.
/// 표기 문제의 틀린 보기는 외래어 표기 규칙을 어긴 꼴(ㅍ↔ㅂ·ㅋ↔ㄱ·ㅌ↔ㄷ·ㅊ↔ㅈ, ㅐ↔ㅔ·ㅓ↔ㅗ·ㅜ↔ㅡ, ㅅ↔ㅆ, ㄹ 하나/둘)로 만든다. 틀린 단어는 다음 복습에 먼저.
const int kLoanQuizSize = 10;
String get _kWrong => pk('loanword_quiz_wrong');

class LQWord {
  final String ko, en, meaning; // meaning = 한국어 뜻이 영어와 다를 때(콩글리시), 아니면 en 과 같다
  const LQWord(this.ko, this.en, this.meaning);
}

const _base = 0xAC00;
const _choSwap = {7: 17, 17: 7, 0: 15, 15: 0, 3: 16, 16: 3, 12: 14, 14: 12, 9: 10, 10: 9}; // ㅂ↔ㅍ, ㄱ↔ㅋ, ㄷ↔ㅌ, ㅈ↔ㅊ, ㅅ↔ㅆ
const _jungSwap = {1: 5, 5: 1, 4: 8, 8: 4, 13: 18, 18: 13}; // ㅐ↔ㅔ, ㅓ↔ㅗ, ㅜ↔ㅡ

/// 규칙을 어긴 꼴들(실제 단어와 겹치는 것은 뺀다).
List<String> loanMisspellings(String ko, Set<String> real) {
  final c = ko.runes.toList();
  final out = <String>{};
  for (var i = 0; i < c.length; i++) {
    final v = c[i] - _base;
    if (v < 0 || v >= 11172) continue;
    final cho = v ~/ 588, jung = (v % 588) ~/ 28, jong = v % 28;
    String put(int a, int b, int d) => String.fromCharCodes([...c]..[i] = _base + a * 588 + b * 28 + d);
    final s1 = _choSwap[cho];
    if (s1 != null) out.add(put(s1, jung, jong));
    final s2 = _jungSwap[jung];
    if (s2 != null) out.add(put(cho, s2, jong));
    // ㄹ 하나/둘 — 다음 글자가 ㄹ 로 시작하면 받침 ㄹ(8) 넣기/빼기
    if (i + 1 < c.length) {
      final nv = c[i + 1] - _base;
      if (nv >= 0 && nv < 11172 && nv ~/ 588 == 5) {
        if (jong == 8) out.add(put(cho, jung, 0));
        if (jong == 0) out.add(put(cho, jung, 8));
      }
    }
  }
  return out.where((s) => s != ko && !real.contains(s)).toList();
}

class _Q {
  final LQWord w;
  final bool spelling;
  final List<String> options;
  const _Q(this.w, this.spelling, this.options);
  String get answer => spelling ? w.ko : w.meaning;
}

class LoanwordQuizScreen extends StatefulWidget {
  final List<LQWord> words;
  final int? seed;
  const LoanwordQuizScreen({super.key, required this.words, this.seed});
  @override
  State<LoanwordQuizScreen> createState() => _LoanwordQuizScreenState();
}

class _LoanwordQuizScreenState extends State<LoanwordQuizScreen> {
  late final _rnd = Random(widget.seed);
  List<_Q>? _qs;
  int _i = 0;
  String? _picked;
  int _right = 0;
  final List<LQWord> _missed = [];

  @override
  void initState() {
    super.initState();
    _build();
  }

  Future<void> _build() async {
    final p = await SharedPreferences.getInstance();
    final wrong = (p.getStringList(_kWrong) ?? const []).toSet();
    final uniq = <String, LQWord>{for (final w in widget.words) w.ko: w}.values.toList()..shuffle(_rnd);
    uniq.sort((a, b) => (wrong.contains(b.ko) ? 1 : 0) - (wrong.contains(a.ko) ? 1 : 0));
    final picked = uniq.take(kLoanQuizSize).toList()..shuffle(_rnd);
    final real = {for (final w in widget.words) w.ko};
    final qs = <_Q>[];
    for (var k = 0; k < picked.length; k++) {
      final w = picked[k];
      final miss = (loanMisspellings(w.ko, real)..shuffle(_rnd)).take(3).toList();
      if (k.isEven && miss.length == 3) {
        qs.add(_Q(w, true, [w.ko, ...miss]..shuffle(_rnd)));
      } else {
        final others = ({for (final o in uniq) if (o.meaning != w.meaning) o.meaning}.toList()..shuffle(_rnd)).take(3);
        qs.add(_Q(w, false, [w.meaning, ...others]..shuffle(_rnd)));
      }
    }
    if (mounted) setState(() => _qs = qs);
  }

  Future<void> _record(String ko, bool ok) async {
    final p = await SharedPreferences.getInstance();
    final s = (p.getStringList(_kWrong) ?? const []).toSet();
    ok ? s.remove(ko) : s.add(ko);
    await p.setStringList(_kWrong, s.toList());
  }

  void _again() => setState(() {
        _qs = null;
        _i = 0;
        _picked = null;
        _right = 0;
        _missed.clear();
        _build();
      });

  @override
  Widget build(BuildContext context) {
    final qs = _qs;
    return Scaffold(
      backgroundColor: DramaColors.bg,
      appBar: AppBar(title: Text(tr('퀴즈 복습'))),
      body: qs == null
          ? const Center(child: CircularProgressIndicator())
          : _i >= qs.length
              ? _summary(qs.length)
              : _question(qs[_i], qs.length),
    );
  }

  Widget _summary(int n) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('🎉', style: TextStyle(fontSize: 44)),
            const SizedBox(height: 10),
            Text(trf('{0}문제 중 {1}개 맞힘', [n, _right]), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: DramaColors.ink)),
            if (_missed.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(tr('틀린 단어 — 다음 복습에 먼저 나와요'), style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
              const SizedBox(height: 6),
              for (final w in _missed)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('${w.ko}  ${w.meaning}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: DramaColors.ink)),
                ),
            ],
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              OutlinedButton(key: const ValueKey('lq-again'), onPressed: _again, child: Text(tr('한 번 더'))),
              const SizedBox(width: 10),
              FilledButton(onPressed: () => Navigator.of(context).maybePop(), style: FilledButton.styleFrom(backgroundColor: DramaColors.ink), child: Text(tr('나가기'))),
            ]),
          ]),
        ),
      );

  Widget _question(_Q q, int n) {
    final w = q.w;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset(context)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('${tr(q.spelling ? '표기' : '뜻')} · ${_i + 1} / $n', style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
        const SizedBox(height: 14),
        Text(
          q.spelling ? (w.meaning == w.en ? w.en : '${w.en} · ${w.meaning}') : w.ko,
          key: const ValueKey('lq-stem'),
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: DramaColors.ink),
        ),
        const SizedBox(height: 8),
        Text(tr(q.spelling ? '한글로 바르게 쓴 것을 고르세요.' : '뜻으로 맞는 것을 고르세요.'), style: const TextStyle(fontSize: 14, color: DramaColors.ink)),
        const SizedBox(height: 14),
        for (var k = 0; k < q.options.length; k++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OutlinedButton(
              key: ValueKey('lq-opt-$k'),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                backgroundColor: _picked == null ? null : (q.options[k] == q.answer ? const Color(0x3336A35B) : (q.options[k] == _picked ? const Color(0x33D83A3A) : null)),
                side: BorderSide(color: _picked != null && q.options[k] == q.answer ? DramaColors.jade : DramaColors.line, width: 1.4),
              ),
              onPressed: _picked != null
                  ? null
                  : () {
                      final ok = q.options[k] == q.answer;
                      TtsService.instance.speak(w.ko);
                      _record(w.ko, ok);
                      setState(() {
                        _picked = q.options[k];
                        ok ? _right++ : _missed.add(w);
                      });
                    },
              child: Row(children: [
                SizedBox(width: 26, child: Text('${k + 1}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: DramaColors.muted))),
                Expanded(child: Text(q.options[k], style: TextStyle(fontSize: q.spelling ? 20 : 16, fontWeight: FontWeight.w800, color: DramaColors.ink))),
              ]),
            ),
          ),
        if (_picked != null)
          FilledButton(
            key: const ValueKey('lq-next'),
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
