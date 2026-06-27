import 'package:flutter/material.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/features/dialogue/widgets/annotated_text.dart';
import 'package:k_universe/services/tts_service.dart';
import 'package:k_universe/ui/spacing.dart';
import 'package:k_universe/ui/typography.dart';

class TurnCard extends StatefulWidget {
  final Turn turn;
  final AppDatabase db;
  const TurnCard({super.key, required this.turn, required this.db});

  @override
  State<TurnCard> createState() => _TurnCardState();
}

class _TurnCardState extends State<TurnCard> {
  bool _glossRevealed = false;
  bool _noteRevealed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isVisitor =
        widget.turn.speaker.toLowerCase().contains('visitor');

    return Card(
      color: isVisitor
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
          : theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(KSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isVisitor
                        ? theme.colorScheme.primary
                        : theme.colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    widget.turn.speaker,
                    style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white, fontSize: 11),
                  ),
                ),
                const Spacer(),
                _PlayButton(text: widget.turn.koText),
              ],
            ),
            const SizedBox(height: KSpace.md),
            AnnotatedTurnText(turn: widget.turn, db: widget.db),
            const SizedBox(height: KSpace.sm),
            Text(
              widget.turn.romanization,
              style: KType.koRoman.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: KSpace.md),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() => _glossRevealed = !_glossRevealed),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(KSpace.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _glossRevealed
                    ? Text(widget.turn.enGloss,
                        style: theme.textTheme.bodyLarge)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tap to reveal English',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                          Icon(Icons.translate,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant),
                        ],
                      ),
              ),
            ),
            if (widget.turn.learnerNoteEn != null) ...[

              const SizedBox(height: KSpace.sm),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () =>
                    setState(() => _noteRevealed = !_noteRevealed),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: KSpace.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _noteRevealed
                            ? Icons.lightbulb
                            : Icons.lightbulb_outline,
                        size: 16,
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _noteRevealed
                            ? Text(
                                widget.turn.learnerNoteEn!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.tertiary,
                                    fontStyle: FontStyle.italic),
                              )
                            : Text(
                                'Learning note',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.tertiary),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlayButton extends StatefulWidget {
  final String text;
  const _PlayButton({required this.text});

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> {
  bool _busy = false;

  Future<void> _onTap() async {
    setState(() => _busy = true);
    try {
      await TtsService.instance.speak(widget.text);
    } finally {
      // Give a short visual confirmation; not a true completion signal.
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.primaryContainer,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _busy ? null : _onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            _busy ? Icons.volume_up_rounded : Icons.play_arrow_rounded,
            size: 22,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
