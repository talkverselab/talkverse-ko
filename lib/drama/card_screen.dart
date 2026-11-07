import 'dart:math';

import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/platform.dart';
import '../services/achievement_service.dart';
import '../services/content_sync.dart';
import '../services/learner_prefs.dart';
import 'drama_audio.dart';
import 'drama_service.dart';
import 'drama_theme.dart';
import 'lemma_chips.dart';
import 'lemma_text.dart';
import 'roman_toggle.dart';
import 'scene_art.dart';

/// 그림 카드 — 일본어앱 `dialogue_card_screen.dart` 를 옮김. 앞면 = 장면 그림 + 영어 뜻, 탭하면 한국어·로마자.
/// 틀림/맞음 2단계, 틀린 카드는 끝에 다시. 편 하나([PictureCardScreen.episode]) 또는 전 레벨 랜덤([PictureCardScreen.random]).
class PictureCardScreen extends StatefulWidget {
  final List<(DramaEpisode, DramaTurn)> cards;
  final String title;
  final String? episodeId; // 편 카드면 성과에 편별로 기록
  const PictureCardScreen({super.key, required this.cards, required this.title, this.episodeId});

  factory PictureCardScreen.episode(DramaEpisode e) => PictureCardScreen(
        cards: [for (final t in e.turns) if (t.ko.trim().isNotEmpty) (e, t)],
        title: '${e.emoji} ${e.title}',
        episodeId: e.id,
      );

  /// 왕초보~고급 회화에서 문장 n개를 고른다.
  factory PictureCardScreen.random({int n = 20}) {
    final all = <(DramaEpisode, DramaTurn)>[
      for (final e in DramaService.instance.all)
        if (e.region != 'R4')
          for (final t in e.turns)
            if (t.ko.trim().isNotEmpty && t.en.trim().isNotEmpty) (e, t),
    ]..shuffle(Random());
    return PictureCardScreen(cards: all.take(n).toList(), title: tr('문장 카드'));
  }

  @override
  State<PictureCardScreen> createState() => _PictureCardScreenState();
}

class _PictureCardScreenState extends State<PictureCardScreen> {
  late final List<int> _order = List.generate(widget.cards.length, (i) => i);
  int _pos = 0;
  bool _flipped = false;
  bool _finished = false;
  final List<int> _retry = [];
  int _right = 0;

  (DramaEpisode, DramaTurn) get _c => widget.cards[_order[_pos]];

  @override
  void initState() {
    super.initState();
    SceneArt.instance.ensureLoaded().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    DramaAudio.instance.stop();
    super.dispose();
  }

  void _mark(bool ok) {
    if (ok) {
      if (_pos < widget.cards.length) _right++; // 다시 나온 카드는 세지 않는다
    } else if (!_retry.contains(_order[_pos])) {
      _retry.add(_order[_pos]);
    }
    DramaAudio.instance.stop();
    if (_pos < _order.length - 1) {
      setState(() {
        _pos++;
        _flipped = false;
      });
    } else if (_retry.isNotEmpty) {
      setState(() {
        _order.addAll(_retry);
        _retry.clear();
        _pos++;
        _flipped = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('틀린 카드를 다시 봅니다')), backgroundColor: DramaColors.ink, duration: const Duration(seconds: 1)));
    } else {
      AchievementService.instance.markCards(widget.episodeId, _right, widget.cards.length);
      setState(() => _finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty || _finished) return _result(context);
    final (e, raw) = _c;
    final t = e.view(raw);
    final wide = isWide(context);
    final art = _CardArt(key: ValueKey('${e.id}:${t.num}'), ep: e, t: t);
    final text = _CardText(ep: e, t: t, flipped: _flipped);
    return Scaffold(
      backgroundColor: DramaColors.bg,
      appBar: AppBar(
        backgroundColor: DramaColors.ink,
        foregroundColor: Colors.white,
        title: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          Text('${_pos + 1} / ${_order.length}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
        ]),
        actions: const [RomanToggleAction()],
      ),
      body: Column(children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _flipped = !_flipped),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: wide
                  ? Row(children: [Expanded(flex: 5, child: art), const SizedBox(width: 16), Expanded(flex: 6, child: text)])
                  : Column(children: [Expanded(flex: 5, child: art), const SizedBox(height: 12), Expanded(flex: 6, child: text)]),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 16 + bottomInset(context)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _Btn(icon: Icons.close, label: tr('틀렸어요'), color: const Color(0xFFC2543F), onTap: () => _mark(false)),
            _Btn(icon: Icons.volume_up, label: tr('듣기'), color: DramaColors.ink, onTap: () => speakTurn(e, t)),
            _Btn(icon: Icons.check, label: tr('맞았어요'), color: DramaColors.jade, onTap: () => _mark(true)),
          ]),
        ),
      ]),
    );
  }

  Widget _result(BuildContext context) => Scaffold(
        backgroundColor: DramaColors.bg,
        appBar: AppBar(backgroundColor: DramaColors.ink, foregroundColor: Colors.white, title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle, color: DramaColors.jade, size: 56),
            const SizedBox(height: 12),
            Text(trf('끝! 맞음 {0} / {1}', [_right, widget.cards.length]), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: DramaColors.ink)),
            const SizedBox(height: 16),
            FilledButton(style: FilledButton.styleFrom(backgroundColor: DramaColors.jade), onPressed: () => Navigator.pop(context), child: Text(tr('닫기'))),
          ]),
        ),
      );
}

class _CardArt extends StatelessWidget {
  final DramaEpisode ep;
  final DramaTurn t;
  const _CardArt({super.key, required this.ep, required this.t});

  @override
  Widget build(BuildContext context) {
    final url = SceneArt.instance.cut(ep.id, t.num);
    final fallback = Center(child: Text(ep.emoji, style: const TextStyle(fontSize: 72)));
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: DramaColors.jadeSoft, border: Border.all(color: DramaColors.line), borderRadius: BorderRadius.circular(18)),
      child: url == null ? fallback : Image(image: artProvider(url), fit: BoxFit.contain, errorBuilder: (_, _, _) => fallback),
    );
  }
}

class _CardText extends StatelessWidget {
  final DramaEpisode ep;
  final DramaTurn t;
  final bool flipped;
  const _CardText({required this.ep, required this.t, required this.flipped});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(valueListenable: LearnerPrefs.roman, builder: (context, _, _) => _build(context));

  Widget _build(BuildContext context) {
    final name = ep.speakerName(t.speaker);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: flipped ? DramaColors.jade : DramaColors.line), borderRadius: BorderRadius.circular(18)),
      child: flipped
          ? SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('$name · ${t.num}', style: const TextStyle(fontSize: 11, color: DramaColors.muted)),
                const SizedBox(height: 8),
                LemmaText(text: DramaEpisode.fill(t.ko), turn: t, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: DramaColors.ink, height: 1.3)),
                if (t.rd.isNotEmpty && LearnerPrefs.roman.value) Padding(padding: const EdgeInsets.only(top: 6), child: Text(DramaEpisode.fill(t.rd), style: const TextStyle(fontSize: 14, color: DramaColors.jade, fontWeight: FontWeight.w700))),
                const Divider(height: 22, color: DramaColors.line),
                Text(DramaEpisode.fill(t.en), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: DramaColors.body, height: 1.4)),
                if (t.note.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10), child: Text('💡 ${t.note}', style: const TextStyle(fontSize: 12, color: DramaColors.muted, height: 1.4))),
                if (t.lemmas.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 12), child: LemmaChips(turn: t)),
              ]),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: DramaColors.ink)),
                  const SizedBox(height: 10),
                  Text(DramaEpisode.fill(t.en), textAlign: TextAlign.center, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: DramaColors.ink, height: 1.4)),
                  const SizedBox(height: 12),
                  Text(tr('이 말을 한국어로 해 보세요'), style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
                  const SizedBox(height: 4),
                  Text(tr('탭해서 확인'), style: const TextStyle(fontSize: 11, color: DramaColors.muted, letterSpacing: 1)),
                ]),
              ),
            ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Btn({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(border: Border.all(color: color, width: 1.5), borderRadius: BorderRadius.circular(14)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: DramaColors.ink)),
          ]),
        ),
      );
}
