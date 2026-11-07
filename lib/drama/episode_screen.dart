import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/platform.dart';
import '../services/content_sync.dart';
import '../services/achievement_service.dart';
import 'card_screen.dart';
import 'drama_audio.dart';
import 'drama_service.dart';
import 'drama_theme.dart';
import 'learner_setup_dialog.dart';
import 'lemma_chips.dart';
import 'scene_art.dart';

/// 드라마 한 회 보기 — Grok UXUI 시안 04(사용자 채택, `data/review/uxui/sian_04.md`).
/// 넓으면(900+) 왼쪽 「대화 스크립트」 · 오른쪽 「회화 장면」(점토 컷 + 아래 자막), 좁으면 장면 위 · 스크립트 아래.
/// 아래 고정 컨트롤 = ▶ · 진행 · 속도 · 자막 칩(한국어/로마자/English). 그림 위에는 말풍선을 얹지 않는다(2026-11-04 사용자 지시 — 그림을 덮음).
/// 대사는 그림 아래 자막 칸 + 내용어 칩(단어장 연결).
/// 끝까지 들으면 「다음 회 예고」.
class EpisodeScreen extends StatefulWidget {
  final DramaEpisode ep;
  final bool autoPlay;
  const EpisodeScreen({super.key, required this.ep, this.autoPlay = false});

  static Future<void> open(BuildContext context, DramaEpisode ep, {bool autoPlay = false}) {
    DramaService.instance.markOpened(ep.id);
    return Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => EpisodeScreen(ep: ep, autoPlay: autoPlay)));
  }

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  int _i = 0;
  bool _playing = false;
  double _rate = 1.0;
  bool _ko = true, _rd = false, _en = true;
  int _session = 0;
  bool _done = false;
  late final List<GlobalKey> _keys = List.generate(widget.ep.turns.length, (_) => GlobalKey());

  DramaEpisode get ep => widget.ep;

  @override
  void initState() {
    super.initState();
    SceneArt.instance.ensureLoaded().then((_) { if (mounted) setState(() {}); });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await ensureLearnerName(context, needed: ep.needsName && !DramaAudio.instance.covers(ep));
      if (mounted) setState(() {});
    });
    if (widget.autoPlay) WidgetsBinding.instance.addPostFrameCallback((_) => _play());
  }

  @override
  void dispose() {
    _session++;
    DramaAudio.instance.stop();
    super.dispose();
  }

  Future<void> _play() async {
    final my = ++_session;
    setState(() => _playing = true);
    while (mounted && my == _session && _i < ep.turns.length) {
      _scrollTo(_i);
      await speakTurn(ep, ep.view(ep.turns[_i]), rate: _rate);
      if (!mounted || my != _session) return;
      await Future.delayed(Duration(milliseconds: (600 / _rate).round()));
      if (!mounted || my != _session) return;
      if (_i >= ep.turns.length - 1) {
        await DramaService.instance.markWatched(ep.id);
        await AchievementService.instance.markEpisodeDone(ep.id);
        if (mounted) setState(() { _done = true; _playing = false; });
        return;
      }
      setState(() => _i++);
    }
    if (mounted && my == _session) setState(() => _playing = false);
  }

  void _pause() {
    _session++;
    DramaAudio.instance.stop();
    setState(() => _playing = false);
  }

  void _goto(int n, {bool speak = false}) {
    _session++;
    DramaAudio.instance.stop();
    setState(() { _i = n.clamp(0, ep.turns.length - 1); _playing = false; });
    _scrollTo(_i);
    if (speak) speakTurn(ep, ep.view(ep.turns[_i]));
  }

  void _scrollTo(int i) {
    final ctx = _keys[i].currentContext;
    if (ctx != null) Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 300), alignment: 0.3);
  }

  @override
  Widget build(BuildContext context) {
    final epNo = DramaService.instance.epNumber(ep);
    final script = _Script(ep: ep, current: _i, keys: _keys, ko: _ko, rd: _rd, en: _en, onTap: (i) => _goto(i, speak: true));
    Widget scene({required bool fit}) => _ScenePanel(ep: ep, epNo: epNo, index: _i, ko: _ko, rd: _rd, en: _en, fit: fit);
    final controls = _Controls(
      playing: _playing, index: _i, total: ep.turns.length, rate: _rate, ko: _ko, rd: _rd, en: _en,
      onPlay: _playing ? _pause : _play,
      onSeek: (v) => _goto(v),
      onRate: () => setState(() => _rate = _rate >= 1.25 ? 0.75 : _rate + 0.25),
      onKo: () => setState(() => _ko = !_ko), onRd: () => setState(() => _rd = !_rd), onEn: () => setState(() => _en = !_en),
    );
    return Scaffold(
      backgroundColor: DramaColors.bg,
      appBar: AppBar(
        backgroundColor: DramaColors.ink,
        foregroundColor: Colors.white,
        title: Text('${ep.emoji}  ${ep.title}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        actions: [IconButton(tooltip: tr('그림 카드'), icon: const Icon(Icons.style_outlined), onPressed: _cards)],
      ),
      body: LayoutBuilder(builder: (context, c) {
        final side = c.maxWidth >= 900;
        final body = Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: side
                  ? Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Expanded(flex: 4, child: _card(script)),
                      const SizedBox(width: 12),
                      Expanded(flex: 6, child: _card(scene(fit: false))),
                    ])
                  : Column(children: [
                      // 폰: 그림 3:2 고정, 자막은 자연 높이(길면 자막만 스크롤), 위 칸 최대 62% — 그림이 잘리지 않게(일본어앱 c558734)
                      if (c.maxWidth < 600)
                        ConstrainedBox(constraints: BoxConstraints(maxHeight: c.maxHeight * 0.62), child: _card(scene(fit: true)))
                      else
                        SizedBox(height: c.maxHeight * 0.58, child: _card(scene(fit: false))),
                      const SizedBox(height: 10),
                      Expanded(child: _card(script)),
                    ]),
            ),
          ),
          controls,
        ]);
        if (!_done) return body;
        return Stack(fit: StackFit.expand, children: [
          body,
          _NextEpisode(
            ep: ep,
            next: DramaService.instance.next(ep),
            onReplay: () => setState(() { _done = false; _i = 0; }),
            onClose: () => setState(() => _done = false),
            onCards: () {
              setState(() => _done = false);
              _cards();
            },
          ),
        ]);
      }),
    );
  }

  void _cards() {
    _pause();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PictureCardScreen.episode(ep)));
  }

  Widget _card(Widget child) => Container(
        decoration: BoxDecoration(color: DramaColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: DramaColors.line)),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
}

/// 「대화 스크립트」 — 번호 원 · 한국어 · (로마자) · English. 현재 줄은 청자 비취 테두리.
class _Script extends StatelessWidget {
  final DramaEpisode ep;
  final int current;
  final List<GlobalKey> keys;
  final bool ko, rd, en;
  final void Function(int) onTap;
  const _Script({required this.ep, required this.current, required this.keys, required this.ko, required this.rd, required this.en, required this.onTap});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Text(tr('대화 스크립트'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: DramaColors.ink)),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 12 + bottomInset(context)),
            itemCount: ep.turns.length,
            itemBuilder: (context, i) {
              final t = ep.view(ep.turns[i]);
              final on = i == current;
              return InkWell(
                key: keys[i],
                borderRadius: BorderRadius.circular(14),
                onTap: () => onTap(i),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    color: on ? DramaColors.jadeSoft : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: on ? DramaColors.jade : Colors.transparent, width: 1.6),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: on ? DramaColors.jade : DramaColors.jade.withValues(alpha: 0.75),
                      child: Text('${t.num}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(ep.speakerName(t.speaker), style: const TextStyle(fontSize: 11, color: DramaColors.muted, fontWeight: FontWeight.w700)),
                        if (ko) Text(DramaEpisode.fill(t.ko), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: DramaColors.ink, height: 1.35)),
                        if (rd) Text(DramaEpisode.fill(t.rd), style: const TextStyle(fontSize: 12.5, color: DramaColors.jade, height: 1.3)),
                        if (en) Text(DramaEpisode.fill(t.en), style: const TextStyle(fontSize: 13, color: DramaColors.body, height: 1.3)),
                      ]),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
      ]);
}

/// 「회화 장면」 — 현재 A·B 쌍의 점토 컷 + 아래 자막·내용어 칩. 그림이 없으면 이모지 장면 카드.
class _ScenePanel extends StatelessWidget {
  final DramaEpisode ep;
  final int epNo, index;
  final bool ko, rd, en;
  final bool fit; // true = 폰(그림 3:2 + 자막 자연 높이), false = 넓은 화면(그림이 칸을 채움)
  const _ScenePanel({required this.ep, required this.epNo, required this.index, required this.ko, required this.rd, required this.en, required this.fit});

  @override
  Widget build(BuildContext context) {
    final t = ep.view(ep.turns[index]);
    final url = SceneArt.instance.cut(ep.id, t.num);
    final art = AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: url == null
          ? _SceneCard(key: ValueKey('card${ep.id}'), ep: ep)
          : Image(image: artProvider(url), key: ValueKey(url), fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, _, _) => _SceneCard(ep: ep)),
    );
    final caption = Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: DramaColors.line))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.volume_up_rounded, color: DramaColors.jade, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (ko) Text(DramaEpisode.fill(t.ko), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: DramaColors.ink)),
            if (rd) Text(DramaEpisode.fill(t.rd), style: const TextStyle(fontSize: 13, color: DramaColors.jade)),
            if (en) Text(DramaEpisode.fill(t.en), style: const TextStyle(fontSize: 14, color: DramaColors.body)),
            if (t.note.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Text(t.note, style: const TextStyle(fontSize: 12, color: DramaColors.muted))),
            if (t.lemmas.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: LemmaChips(turn: t, compact: true)),
          ]),
        ),
      ]),
    );
    return Column(mainAxisSize: fit ? MainAxisSize.min : MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: EdgeInsets.fromLTRB(16, fit ? 10 : 14, 16, 8),
        child: Row(children: [
          if (!fit) ...[
            Text(tr('회화 장면'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: DramaColors.ink)),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: DramaColors.line)),
              child: Text('EP.$epNo · ${ep.title}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: DramaColors.ink)),
            ),
          ),
          if (ep.cliche) ...[const SizedBox(width: 6), const Text('🎬', style: TextStyle(fontSize: 14))],
        ]),
      ),
      if (fit) AspectRatio(aspectRatio: 1168 / 784, child: art) else Expanded(child: art),
      if (fit) Flexible(child: SingleChildScrollView(child: caption)) else caption,
    ]);
  }
}

class _SceneCard extends StatelessWidget {
  final DramaEpisode ep;
  const _SceneCard({super.key, required this.ep});
  @override
  Widget build(BuildContext context) => Container(
        color: DramaColors.jadeSoft,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(ep.emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 10),
            Text(ep.scene, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: DramaColors.body, height: 1.4)),
          ]),
        ),
      );
}

class _Controls extends StatelessWidget {
  final bool playing, ko, rd, en;
  final int index, total;
  final double rate;
  final VoidCallback onPlay, onRate, onKo, onRd, onEn;
  final void Function(int) onSeek;
  const _Controls({required this.playing, required this.index, required this.total, required this.rate, required this.ko, required this.rd, required this.en, required this.onPlay, required this.onSeek, required this.onRate, required this.onKo, required this.onRd, required this.onEn});

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, bool on, VoidCallback tap) => Padding(
          padding: const EdgeInsets.only(left: 6),
          child: ChoiceChip(
            label: Text(label),
            selected: on,
            onSelected: (_) => tap(),
            showCheckmark: false,
            selectedColor: DramaColors.jade,
            labelStyle: TextStyle(color: on ? Colors.white : DramaColors.ink, fontWeight: FontWeight.w700, fontSize: 13),
            side: const BorderSide(color: DramaColors.line),
            shape: const StadiumBorder(),
          ),
        );
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: EdgeInsets.fromLTRB(10, 6, 10, 6 + bottomInset(context)),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: DramaColors.line)),
      child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, alignment: WrapAlignment.spaceBetween, runSpacing: 4, children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: DramaColors.jade),
            onPressed: onPlay,
            icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white),
          ),
          SizedBox(
            width: 170,
            child: Slider(
              value: index.toDouble(),
              min: 0,
              max: (total - 1).toDouble().clamp(1, 999),
              divisions: total > 1 ? total - 1 : 1,
              activeColor: DramaColors.jade,
              onChanged: (v) => onSeek(v.round()),
            ),
          ),
          Text('${index + 1}/$total', style: const TextStyle(fontSize: 12, color: DramaColors.muted)),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: onRate, child: Text('${rate}x')),
        ]),
        Row(mainAxisSize: MainAxisSize.min, children: [chip('한국어', ko, onKo), chip(tr('로마자'), rd, onRd), chip('English', en, onEn)]),
      ]),
    );
  }
}

/// 편 끝 — 「다음 회 예고」(시안: 엔딩 크레딧 + 예고 한 컷).
class _NextEpisode extends StatelessWidget {
  final DramaEpisode ep;
  final DramaEpisode? next;
  final VoidCallback onReplay, onClose, onCards;
  const _NextEpisode({required this.ep, required this.next, required this.onReplay, required this.onClose, required this.onCards});
  @override
  Widget build(BuildContext context) {
    final url = next == null ? null : SceneArt.instance.cut(next!.id, 1);
    return Container(
      color: const Color(0xCC0A2540),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
          clipBehavior: Clip.antiAlias,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
              child: Text(trf('{0} — 끝', [ep.title]), style: const TextStyle(fontSize: 13, color: DramaColors.muted, fontWeight: FontWeight.w700)),
            ),
            if (next != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(tr('다음 회 예고'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: DramaColors.ink)),
              ),
              AspectRatio(
                aspectRatio: 1168 / 784,
                child: url == null ? _SceneCard(ep: next!) : Image(image: artProvider(url), fit: BoxFit.cover, errorBuilder: (_, _, _) => _SceneCard(ep: next!)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Text('${next!.emoji}  ${next!.title}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: DramaColors.ink)),
              ),
            ],
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Row(children: [
                TextButton(onPressed: onReplay, child: Text(tr('다시 보기'))),
                TextButton(onPressed: onCards, child: Text(tr('그림 카드'))),
                const Spacer(),
                if (next != null)
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: DramaColors.jade),
                    onPressed: () {
                      onClose();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => EpisodeScreen(ep: next!, autoPlay: true)));
                      DramaService.instance.markOpened(next!.id);
                    },
                    child: Text(tr('다음 회 보기')),
                  )
                else
                  FilledButton(style: FilledButton.styleFrom(backgroundColor: DramaColors.jade), onPressed: onClose, child: Text(tr('닫기'))),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
