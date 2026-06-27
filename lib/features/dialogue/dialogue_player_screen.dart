import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:k_universe/db/database.dart';
import 'package:k_universe/features/dialogue/widgets/turn_card.dart';
import 'package:k_universe/ui/spacing.dart';

class DialoguePlayerScreen extends StatefulWidget {
  final String scenarioId;
  const DialoguePlayerScreen({super.key, required this.scenarioId});

  @override
  State<DialoguePlayerScreen> createState() => _DialoguePlayerScreenState();
}

class _DialoguePlayerScreenState extends State<DialoguePlayerScreen> {
  int _revealed = 1;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final db = context.read<AppDatabase>();
      db.into(db.userProgress).insertOnConflictUpdate(
            UserProgressCompanion(
              scenarioId: Value(widget.scenarioId),
              status: const Value('in_progress'),
              lastTurnOrder: const Value(1),
              startedAt: Value(DateTime.now()),
            ),
          );
    });
  }

  void _next(int total) {
    if (_revealed < total) {
      setState(() => _revealed++);
      final db = context.read<AppDatabase>();
      db.into(db.userProgress).insertOnConflictUpdate(
            UserProgressCompanion(
              scenarioId: Value(widget.scenarioId),
              status: const Value('in_progress'),
              lastTurnOrder: Value(_revealed),
            ),
          );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 200,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _complete(int total) async {
    final db = context.read<AppDatabase>();
    await db.into(db.userProgress).insertOnConflictUpdate(
          UserProgressCompanion(
            scenarioId: Value(widget.scenarioId),
            status: const Value('completed'),
            lastTurnOrder: Value(total),
            completedAt: Value(DateTime.now()),
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Scenario>(
          future: (db.select(db.scenarios)
                ..where((t) => t.id.equals(widget.scenarioId)))
              .getSingle(),
          builder: (context, snap) => Text(snap.data?.titleEn ?? '...'),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Turn>>(
          future: (db.select(db.turns)
                ..where((t) => t.scenarioId.equals(widget.scenarioId))
                ..orderBy([(t) => OrderingTerm.asc(t.turnOrder)]))
              .get(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final turns = snap.data!;
            if (turns.isEmpty) return const Center(child: Text('No turns.'));

            final visible = turns.take(_revealed).toList();
            final isComplete = _revealed >= turns.length;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                        KSpace.lg, KSpace.md, KSpace.lg, KSpace.xxxl),
                    itemCount: visible.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: KSpace.md),
                        child: TurnCard(turn: visible[i], db: db),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                      KSpace.lg, KSpace.sm, KSpace.lg, KSpace.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(
                      top: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$_revealed / ${turns.length}',
                          style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                      FilledButton(
                        onPressed: isComplete
                            ? () => _complete(turns.length)
                            : () => _next(turns.length),
                        child: Text(isComplete
                            ? 'Done ✓'
                            : 'Next line  →'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
