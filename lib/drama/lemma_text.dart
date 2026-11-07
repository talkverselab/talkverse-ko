import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/database.dart';
import 'drama_service.dart';
import 'drama_theme.dart';
import 'lemma_chips.dart';

/// 회화 문장을 레마(내용어) 단위로 쪼갠 글 — 단어장에 있는 레마는 밑줄, **탭하면 단어창**(일본어앱 `selectable_ja_text` 와 같은 뜻, 2026-11-07).
/// 표면형을 문장에서 차례로 찾아 구간을 잡는다. 못 찾으면 보통 글자로 둔다.
class LemmaText extends StatefulWidget {
  final String text; // 변수가 채워진 문장
  final DramaTurn turn;
  final TextStyle style;
  const LemmaText({super.key, required this.text, required this.turn, required this.style});
  @override
  State<LemmaText> createState() => _LemmaTextState();
}

class _LemmaTextState extends State<LemmaText> {
  final List<TapGestureRecognizer> _recs = [];
  Map<String, VocabEntry> _found = const {};

  @override
  void initState() {
    super.initState();
    _lookup();
  }

  @override
  void didUpdateWidget(LemmaText old) {
    super.didUpdateWidget(old);
    if (old.turn != widget.turn) _lookup();
  }

  Future<void> _lookup() async {
    final bases = {for (final l in widget.turn.lemmas) l.base}.toList();
    if (bases.isEmpty) return;
    final f = await lookupLemmas(context.read<AppDatabase>(), bases);
    if (mounted) setState(() => _found = f);
  }

  @override
  void dispose() {
    for (final r in _recs) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (final r in _recs) {
      r.dispose();
    }
    _recs.clear();
    final text = widget.text;
    final spans = <InlineSpan>[];
    var pos = 0;
    for (final l in widget.turn.lemmas) {
      if (l.surface.isEmpty) continue;
      final i = text.indexOf(l.surface, pos);
      if (i < 0) continue;
      if (i > pos) spans.add(TextSpan(text: text.substring(pos, i)));
      final v = _found[l.base];
      if (v == null) {
        spans.add(TextSpan(text: l.surface));
      } else {
        final rec = TapGestureRecognizer()..onTap = () => showWordSheet(context, v, l.rd);
        _recs.add(rec);
        spans.add(TextSpan(
          text: l.surface,
          recognizer: rec,
          style: const TextStyle(decoration: TextDecoration.underline, decorationColor: DramaColors.jade, decorationThickness: 1.5),
        ));
      }
      pos = i + l.surface.length;
    }
    if (pos < text.length) spans.add(TextSpan(text: text.substring(pos)));
    return Text.rich(TextSpan(children: spans, style: widget.style));
  }
}
