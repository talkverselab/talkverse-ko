import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/platform.dart';
import 'drama_service.dart';
import 'drama_theme.dart';
import 'episode_screen.dart';
import 'scene_art.dart';

/// 드라마 회화 홈 — 레벨(왕초보~고급) 칩 + 주제 = 「시리즈」, 편 = 「EP.n」 카드(첫 컷 썸네일). 시안 04 톤.
class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key});
  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  String _level = 'R1';
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    Future.wait([DramaService.instance.ensureLoaded(), SceneArt.instance.ensureLoaded()]).then((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = DramaService.instance;
    return Scaffold(
      backgroundColor: DramaColors.bg,
      appBar: AppBar(
        backgroundColor: DramaColors.ink,
        foregroundColor: Colors.white,
        title: Text(tr('드라마 회화'), style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: !_ready
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 24 + bottomInset(context)),
              children: [
                _continueCard(context),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    for (final lv in DramaService.levels)
                      if (s.count(lv) > 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text('${tr(DramaService.levelKo[lv]!)} · ${s.count(lv)}'),
                            selected: _level == lv,
                            showCheckmark: false,
                            selectedColor: DramaColors.jade,
                            labelStyle: TextStyle(color: _level == lv ? Colors.white : DramaColors.ink, fontWeight: FontWeight.w700),
                            onSelected: (_) => setState(() => _level = lv),
                          ),
                        ),
                  ]),
                ),
                const SizedBox(height: 8),
                for (final isl in s.islandsOf(_level)) _series(context, isl),
              ],
            ),
    );
  }

  Widget _continueCard(BuildContext context) {
    final last = DramaService.instance.lastOpened == null ? null : DramaService.instance.byId(DramaService.instance.lastOpened!);
    if (last == null) return const SizedBox.shrink();
    final url = SceneArt.instance.cut(last.id, 1, small: true);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => EpisodeScreen.open(context, last).then((_) => setState(() {})),
          child: Row(children: [
            SizedBox(width: 120, height: 80, child: url == null ? Center(child: Text(last.emoji, style: const TextStyle(fontSize: 36))) : Image.network(url, fit: BoxFit.cover)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tr('이어서 보기'), style: const TextStyle(fontSize: 12, color: DramaColors.jade, fontWeight: FontWeight.w800)),
                Text(last.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: DramaColors.ink)),
              ]),
            ),
            const Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.play_circle_fill_rounded, color: DramaColors.jade, size: 34)),
          ]),
        ),
      ),
    );
  }

  Widget _series(BuildContext context, String isl) {
    final eps = DramaService.instance.list(_level, island: isl);
    final watched = eps.where((e) => DramaService.instance.watched.contains(e.id)).length;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('${DramaService.islandEmoji[isl]}  ${tr(DramaService.islandKo[isl]!)}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: DramaColors.ink)),
          const SizedBox(width: 8),
          Text(trf('{0}/{1}회', [watched, eps.length]), style: const TextStyle(fontSize: 12, color: DramaColors.muted, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 8),
        SizedBox(
          height: 168,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: eps.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) => _EpisodeCard(ep: eps[i], no: i + 1, onTap: () => EpisodeScreen.open(context, eps[i]).then((_) => setState(() {}))),
          ),
        ),
      ]),
    );
  }
}

class _EpisodeCard extends StatelessWidget {
  final DramaEpisode ep;
  final int no;
  final VoidCallback onTap;
  const _EpisodeCard({required this.ep, required this.no, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final url = SceneArt.instance.cut(ep.id, 1, small: true);
    final seen = DramaService.instance.watched.contains(ep.id);
    return SizedBox(
      width: 196,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              AspectRatio(
                aspectRatio: 1168 / 784,
                child: url == null
                    ? Container(color: DramaColors.jadeSoft, alignment: Alignment.center, child: Text(ep.emoji, style: const TextStyle(fontSize: 38)))
                    : Image.network(url, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: DramaColors.jadeSoft)),
              ),
              Positioned(
                left: 8, top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: DramaColors.ink.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(10)),
                  child: Text('EP.$no${ep.cliche ? ' 🎬' : ''}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                ),
              ),
              if (seen) const Positioned(right: 8, top: 8, child: Icon(Icons.check_circle, color: DramaColors.jade, size: 20)),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
              child: Text(ep.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: DramaColors.ink)),
            ),
          ]),
        ),
      ),
    );
  }
}
