import 'package:flutter/material.dart';

import '../../core/l10n.dart';
import '../../drama/drama_theme.dart';
import 'hangul_phonetics.dart';

/// IPA 모음 사다리꼴 위에 한국어 모음(비취 ●)과 이웃한 영어 모음(남색 ●) — 일본어앱 vowel_compare_chart 이식.
class VowelCompareChart extends StatelessWidget {
  final VowelChartData data;
  const VowelCompareChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AspectRatio(
          aspectRatio: 1.45,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: DramaColors.line)),
            padding: const EdgeInsets.fromLTRB(30, 22, 12, 12),
            child: CustomPaint(painter: _P(data), size: Size.infinite),
          ),
        ),
        const SizedBox(height: 6),
        Row(children: [_dot(DramaColors.jade, tr('한국어')), const SizedBox(width: 12), _dot(DramaColors.ink, 'English')]),
        const SizedBox(height: 4),
        Text(data.note, style: const TextStyle(fontSize: 11.5, color: DramaColors.body, height: 1.45)),
      ]);

  Widget _dot(Color c, String l) => Row(children: [
        Container(width: 9, height: 9, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(l, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: c)),
      ]);
}

class _P extends CustomPainter {
  final VowelChartData d;
  _P(this.d);

  Offset _m(double x, double y, Size s) {
    final left = 0.38 * s.width * y;
    return Offset(left + (s.width - left) * x, y * s.height);
  }

  @override
  void paint(Canvas c, Size s) {
    final g = Paint()
      ..color = DramaColors.muted.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke;
    c.drawPath(Path()..addPolygon([_m(0, 0, s), _m(1, 0, s), _m(1, 1, s), _m(0, 1, s)], true), g);
    for (final y in [1 / 3, 2 / 3]) {
      c.drawLine(_m(0, y, s), _m(1, y, s), g);
    }
    c.drawLine(_m(0.5, 0, s), _m(0.5, 1, s), g);
    _t(c, tr('전설'), Offset(_m(0, 0, s).dx - 2, -18));
    _t(c, tr('중설'), Offset(_m(0.5, 0, s).dx - 10, -18));
    _t(c, tr('후설'), Offset(s.width - 22, -18));
    _t(c, tr('고'), Offset(-24, -5));
    _t(c, tr('중'), Offset(-24, _m(0, 0.5, s).dy - 5));
    _t(c, tr('저'), Offset(-24, s.height - 10));
    final ko = _m(d.ko.x, d.ko.y, s);
    for (final e in d.eng) {
      final p = _m(e.x, e.y, s);
      c.drawLine(ko, p, Paint()..color = DramaColors.muted.withValues(alpha: 0.5));
      c.drawCircle(p, 5, Paint()..color = DramaColors.ink);
      _label(c, s, p, '${e.ipa} ${e.label}', DramaColors.ink, false);
    }
    c.drawCircle(ko, 7, Paint()..color = DramaColors.jade);
    _label(c, s, ko + const Offset(0, 16), '${d.ko.ipa} ${d.ko.label}', DramaColors.jade, true); // 한국어 라벨은 점 아래 — 영어 점과 겹치지 않게
  }

  void _label(Canvas c, Size s, Offset p, String t, Color col, bool b) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(fontSize: b ? 12 : 10.5, fontWeight: b ? FontWeight.w900 : FontWeight.w700, color: col)), textDirection: TextDirection.ltr)..layout();
    var dx = p.dx + 9;
    if (dx + tp.width > s.width) dx = p.dx - tp.width - 9;
    tp.paint(c, Offset(dx, (p.dy - tp.height / 2).clamp(0, s.height - tp.height)));
  }

  void _t(Canvas c, String t, Offset o) {
    (TextPainter(text: TextSpan(text: t, style: const TextStyle(fontSize: 9, color: DramaColors.muted, fontWeight: FontWeight.w700)), textDirection: TextDirection.ltr)..layout()).paint(c, o);
  }

  @override
  bool shouldRepaint(covariant _P o) => o.d != d;
}
