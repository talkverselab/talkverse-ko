import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/ui/colors.dart';
import 'package:k_universe/ui/spacing.dart';
import 'package:k_universe/ui/typography.dart';

/// Renders a single dialogue turn's Korean text with tappable inline
/// annotations on particles, endings, honorifics, and vocab words.
class AnnotatedTurnText extends StatelessWidget {
  final Turn turn;
  final AppDatabase db;
  const AnnotatedTurnText({super.key, required this.turn, required this.db});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Annotation>>(
      future:
          (db.select(db.annotations)..where((t) => t.turnId.equals(turn.id)))
              .get(),
      builder: (context, snap) {
        final annotations = snap.data ?? const <Annotation>[];
        return _buildRichText(context, annotations);
      },
    );
  }

  Widget _buildRichText(BuildContext context, List<Annotation> annotations) {
    final theme = Theme.of(context);
    final text = turn.koText;

    if (annotations.isEmpty) {
      return Text(text, style: KType.koHero.copyWith(color: theme.colorScheme.onSurface));
    }

    final sorted = [...annotations]
      ..sort((a, b) => a.startOffset.compareTo(b.startOffset));

    final spans = <InlineSpan>[];
    int cursor = 0;

    for (final ann in sorted) {
      if (ann.startOffset < cursor) continue; // skip overlap
      if (ann.startOffset > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, ann.startOffset)));
      }
      final color = _annColor(ann.kind);
      spans.add(
        TextSpan(
          text: text.substring(ann.startOffset, ann.endOffset),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: color.withValues(alpha: 0.45),
            decorationStyle: TextDecorationStyle.dotted,
            decorationThickness: 2,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _showAnnotation(context, ann),
        ),
      );
      cursor = ann.endOffset;
    }

    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return RichText(
      text: TextSpan(
        style: KType.koHero.copyWith(color: theme.colorScheme.onSurface),
        children: spans,
      ),
    );
  }

  Color _annColor(String kind) {
    switch (kind) {
      case 'particle':
        return KColors.annParticle;
      case 'ending':
        return KColors.annEnding;
      case 'honorific':
        return KColors.annHonorific;
      case 'vocab':
        return KColors.annVocab;
      default:
        return KColors.softPink;
    }
  }

  void _showAnnotation(BuildContext context, Annotation ann) {
    final theme = Theme.of(context);
    final color = _annColor(ann.kind);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(
            KSpace.xl, 0, KSpace.xl, KSpace.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    ann.kind.toUpperCase(),
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: color, fontSize: 11),
                  ),
                ),
                const SizedBox(width: KSpace.md),
                Flexible(
                  child: Text(
                    ann.target,
                    style: KType.koHero.copyWith(fontSize: 24, color: color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: KSpace.lg),
            Text(ann.glossEn, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
