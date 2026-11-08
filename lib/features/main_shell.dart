import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/l10n.dart';
import '../core/pane.dart';
import '../core/platform.dart';
import '../db/database.dart';
import '../drama/card_screen.dart';
import '../drama/drama_service.dart';
import '../drama/drama_theme.dart';
import '../drama/episode_screen.dart';
import '../drama/scene_art.dart';
import '../drama/series_screen.dart';
import '../review/review_engine.dart';
import '../review/review_service.dart';
import '../review/review_ui.dart';
import '../screens/about_screen.dart';
import '../services/content_sync.dart';
import '../services/tts_service.dart';
import '../ui/mesh_backdrop.dart';
import '../widgets/achievement_desk.dart';
import 'dialogue/scenario_list_screen.dart';
import 'hangul/hangul_chart_screen.dart';
import 'particles/particles_screen.dart';
import 'profile/profile_screen.dart';
import 'vocabulary/vocabulary_screen.dart';

/// 메인 — 탭 4개: 배우기 · 복습 · 탐색 · 나. 일본어앱 `main_screen.dart` 와 같은 구조(사용자 지시 2026-11-07).
/// 넓은 화면(isWide): 레일 + 왼쪽 탭 목록 + 오른쪽 칸(자기 Navigator). 폰: 하단 탭 + 내용 전체 화면.
/// 학습(회화 재생·카드 세션)은 어느 쪽이든 전체 화면.
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final _pane = GlobalKey<NavigatorState>();

  static List<(IconData, IconData, String)> get _tabs => [
    (Icons.menu_book_outlined, Icons.menu_book, tr('배우기')),
    (Icons.style_outlined, Icons.style, tr('복습')),
    (Icons.explore_outlined, Icons.explore, tr('탐색')),
    (Icons.person_outline, Icons.person, tr('프로필')),
  ];

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      centerTitle: false,
      title: const Text(
        'Korean Universe',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: DramaColors.jade),
      ),
      actions: [
        IconButton(
          tooltip: tr('단어 찾기'),
          icon: const Icon(Icons.search, color: DramaColors.ink),
          onPressed: () => openPane(context, (_) => const VocabularyScreen()),
        ),
        const SizedBox(width: 4),
      ],
    );
    final stack = IndexedStack(index: _index, children: const [LearnTab(), ReviewTab(), ExploreTab(), MeTab()]);
    if (!isWide(context)) {
      return Scaffold(
        appBar: appBar,
        body: stack,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [for (final t in _tabs) NavigationDestination(icon: Icon(t.$1), selectedIcon: Icon(t.$2), label: t.$3)],
        ),
      );
    }
    final w = MediaQuery.sizeOf(context).width;
    final left = (w * 0.34).clamp(300.0, 440.0); // 폴드 펼침은 300, 아이패드는 더 넓게
    return Pane(
      navKey: _pane,
      child: NavigatorPopHandler(
        onPopWithResult: (_) => _pane.currentState?.maybePop(),
        child: Scaffold(
          appBar: appBar,
          body: Row(
            children: [
              // 레일 + 맨 아래 ⓘ 「앱 소개」(일본어앱 2026-11-07 개편). trailing: Expanded 는 시험에서 레일 탭이 흔들려 Column 으로 둔다.
              ColoredBox(
                color: DramaColors.bg,
                child: Column(
                  children: [
                    Expanded(
                      child: NavigationRail(
                        selectedIndex: _index,
                        onDestinationSelected: (i) => setState(() => _index = i),
                        labelType: w >= 900 ? NavigationRailLabelType.all : NavigationRailLabelType.selected,
                        backgroundColor: DramaColors.bg,
                        indicatorColor: DramaColors.jadeSoft,
                        selectedIconTheme: const IconThemeData(color: DramaColors.jade),
                        unselectedIconTheme: const IconThemeData(color: DramaColors.muted),
                        selectedLabelTextStyle: const TextStyle(color: DramaColors.jade, fontSize: 11, fontWeight: FontWeight.w600),
                        unselectedLabelTextStyle: const TextStyle(color: DramaColors.muted, fontSize: 11, fontWeight: FontWeight.w600),
                        destinations: [for (final t in _tabs) NavigationRailDestination(icon: Icon(t.$1), selectedIcon: Icon(t.$2), label: Text(t.$3))],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: IconButton(
                        tooltip: tr('앱 소개'),
                        icon: const Icon(Icons.info_outline, color: DramaColors.muted),
                        onPressed: () => openPane(context, (_) => const AboutScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1, thickness: 1, color: DramaColors.line),
              SizedBox(width: left, child: stack),
              const VerticalDivider(width: 1, thickness: 1, color: DramaColors.line),
              Expanded(
                child: ClipRect(
                  child: Navigator(
                    key: _pane,
                    onGenerateInitialRoutes: (_, _) => [MaterialPageRoute(builder: (_) => const _PanePlaceholder())],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanePlaceholder extends StatelessWidget {
  const _PanePlaceholder();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Seal(text: '한', size: 56),
          const SizedBox(height: 14),
          Text(
            tr('왼쪽에서 고르면 여기에 열립니다 · 회화·카드는 전체 화면'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: DramaColors.muted, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}

class _Seal extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const _Seal({required this.text, this.size = 40, this.color = DramaColors.jade});
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(size * 0.28)),
    child: Text(
      text,
      style: TextStyle(fontSize: size * (text.length > 1 ? 0.3 : 0.44), fontWeight: FontWeight.w900, color: color),
    ),
  );
}

/// 탭 안의 한 줄 — 도장 + 제목·부제 + 꺾쇠.
class _NavRow extends StatelessWidget {
  final String seal;
  final Color color;
  final String title, subtitle;
  final VoidCallback onTap;
  const _NavRow({required this.seal, this.color = DramaColors.jade, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: DramaColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _Seal(text: seal, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: DramaColors.ink),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, color: DramaColors.muted),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: DramaColors.muted, size: 20),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _section(String title) => Padding(
  padding: const EdgeInsets.fromLTRB(2, 14, 2, 8),
  child: Text(
    title,
    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: DramaColors.muted, letterSpacing: 0.5),
  ),
);

EdgeInsets _pad(BuildContext context) => EdgeInsets.fromLTRB(16, 8, 16, 24 + bottomInset(context));

// ────────── 배우기 ──────────

class LearnTab extends StatefulWidget {
  const LearnTab({super.key});
  @override
  State<LearnTab> createState() => _LearnTabState();
}

class _LearnTabState extends State<LearnTab> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    DramaService.instance.ensureLoaded().then((_) {
      if (mounted) setState(() => _ready = true);
    });
    // 그림 목록은 기다리지 않는다(오프라인이면 8초) — 도착하면 컷만 다시 그린다
    SceneArt.instance.ensureLoaded().then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _open(Widget Function(BuildContext) b) async {
    await openPane(context, b);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      const Positioned(top: 0, left: 0, right: 0, height: 260, child: MeshBackdrop()),
      ListView(
        padding: _pad(context),
        children: [
          const SizedBox(height: 4),
          const Text(
            '안녕하세요!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: DramaColors.ink),
          ),
          const SizedBox(height: 2),
          Text(
            tr('오늘도 한 장면씩 가요'),
            style: const TextStyle(fontSize: 13, color: DramaColors.body, fontWeight: FontWeight.w500),
          ),
          _section(tr('오늘의 컷')),
          if (_ready) _TodayCut(onBack: () => setState(() {})) else const SizedBox(height: 200),
          _section(tr('기초')),
          _NavRow(seal: '한글', title: tr('한글과 발음'), subtitle: tr('자음·모음·받침 · 탭하면 IPA·입모양'), onTap: () => _open((_) => const HangulChartScreen())),
          _NavRow(seal: '기본', color: DramaColors.ink, title: tr('기본 회화 8장면'), subtitle: tr('문법 표시가 달린 짧은 장면'), onTap: () => _open((_) => const ScenarioListScreen())),
          _section(tr('문법')),
          _NavRow(seal: '조사', color: DramaColors.ink, title: tr('조사·어미'), subtitle: tr('한국어 말의 63%를 만드는 19개'), onTap: () => _open((_) => const ParticlesScreen())),
          _section(tr('회화')),
          _NavRow(seal: '회화', title: tr('주제별 회화 R0~R4'), subtitle: tr('모든 문장 듣기 · 그림 카드 · 왕초보/초보'), onTap: () => _open((_) => const SeriesScreen())),
          _section(tr('단어')),
          _NavRow(seal: '단어', title: tr('절벽 단어 R1~R5'), subtitle: tr('20어 단원 · 타일 · 회화 단어 포함'), onTap: () => _open((_) => const VocabularyScreen())),
        ],
      ),
    ],
  );
}

/// 「오늘의 컷 / 이어서 보기」 — 마지막으로 연 편(없으면 초보 첫 편)의 첫 컷.
class _TodayCut extends StatelessWidget {
  final VoidCallback onBack;
  const _TodayCut({required this.onBack});
  @override
  Widget build(BuildContext context) {
    final s = DramaService.instance;
    final last = s.lastOpened == null ? null : s.byId(s.lastOpened!);
    final list = s.list('R1');
    final e = last ?? (list.isEmpty ? null : list.first);
    if (e == null) return const SizedBox.shrink();
    final url = SceneArt.instance.cut(e.id, 1);
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: DramaColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => EpisodeScreen.open(context, e).then((_) => onBack()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1168 / 784,
              child: url == null
                  ? Container(
                      color: DramaColors.jadeSoft,
                      alignment: Alignment.center,
                      child: Text(e.emoji, style: const TextStyle(fontSize: 56)),
                    )
                  : Image(
                      image: artProvider(url),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(color: DramaColors.jadeSoft),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 10, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(last == null ? '오늘의 컷' : '이어서 보기'),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: DramaColors.jade),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${e.emoji} ${e.title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: DramaColors.ink),
                        ),
                        Text('${e.region} · ${tr(DramaService.islandKo[e.island] ?? e.island)} · ${trf('{0}턴', [e.turns.length])}', style: const TextStyle(fontSize: 11, color: DramaColors.muted)),
                      ],
                    ),
                  ),
                  const Icon(Icons.play_circle_fill_rounded, color: DramaColors.jade, size: 38),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────── 복습 ──────────

class ReviewTab extends StatelessWidget {
  const ReviewTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: _pad(context),
    children: [
      _section(tr('오늘의 복습')),
      const _TodayReview(),
      const SizedBox(height: 12),
      _section(tr('복습')),
      _NavRow(
        seal: '문장',
        title: tr('문장 카드'),
        subtitle: tr('전 레벨 랜덤 20'),
        onTap: () async {
          await DramaService.instance.ensureLoaded();
          if (context.mounted) openFull(context, (_) => PictureCardScreen.random());
        },
      ),
      _NavRow(seal: '조사', color: DramaColors.ink, title: tr('조사·어미'), subtitle: tr('한국어 말의 63%를 만드는 19개'), onTap: () => openPane(context, (_) => const ParticlesScreen())),
    ],
  );
}

/// 라이트너 7단계 복습 — 카드 = 그림이 있는 단어(빈도순). id `word:<단어>`. 앞면 영어 뜻 + 그림, 뒷면 한국어 + 로마자.
class _TodayReview extends StatefulWidget {
  const _TodayReview();
  @override
  State<_TodayReview> createState() => _TodayReviewState();
}

class _TodayReviewState extends State<_TodayReview> {
  final Map<String, VocabEntry> _words = {};
  List<ReviewCandidate> _cands = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = context.read<AppDatabase>();
    await DramaService.instance.ensureLoaded();
    await ReviewService.instance.load();
    final rows = await (db.select(db.vocab)..orderBy([(t) => OrderingTerm.asc(t.rank)])).get();
    final art = ContentSync.instance.wordIndex;
    final cands = <ReviewCandidate>[];
    for (final v in rows) {
      if ((v.glossEn ?? '').isEmpty || v.glossEn!.startsWith('(')) continue; // (ending) 같은 문법 조각은 카드로 안 낸다
      if (art.isNotEmpty && !art.containsKey(v.word)) continue;
      _words['word:${v.word}'] = v;
      cands.add(ReviewCandidate('word:${v.word}'));
    }
    if (mounted) setState(() => _cands = cands);
  }

  ReviewFace? _resolve(String id) {
    final v = _words[id];
    if (v == null) return null;
    return ReviewFace(prompt: v.glossEn!, target: v.word, reading: DramaService.instance.romanOf[v.word], asset: ContentSync.instance.wordArt(v.word));
  }

  @override
  Widget build(BuildContext context) {
    if (_cands.isEmpty) return const SizedBox.shrink();
    return ReviewTodayCard(candidates: _cands, resolve: _resolve, speak: (id, face) => TtsService.instance.speak(face.target), title: tr('오늘의 복습'));
  }
}

// ────────── 탐색 ──────────

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: _pad(context),
    children: [
      const SizedBox(height: 4),
      InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => openPane(context, (_) => const VocabularyScreen(focusSearch: true)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: DramaColors.bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DramaColors.line),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: DramaColors.jade, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(tr('단어 · 뜻으로 찾기'), style: const TextStyle(color: DramaColors.muted, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
      _section(tr('단어')),
      _NavRow(seal: '단어', title: tr('절벽 단어 R1~R5'), subtitle: tr('20어 단원 · 타일 · 회화 단어 포함'), onTap: () => openPane(context, (_) => const VocabularyScreen())),
      _NavRow(seal: '조사', color: DramaColors.ink, title: tr('조사·어미'), subtitle: tr('한국어 말의 63%를 만드는 19개'), onTap: () => openPane(context, (_) => const ParticlesScreen())),
      _section(tr('회화')),
      _NavRow(seal: '회화', title: tr('주제별 회화 R0~R4'), subtitle: tr('모든 문장 듣기 · 그림 카드 · 왕초보/초보'), onTap: () => openPane(context, (_) => const SeriesScreen())),
      _NavRow(seal: '기본', color: DramaColors.ink, title: tr('기본 회화 8장면'), subtitle: tr('문법 표시가 달린 짧은 장면'), onTap: () => openPane(context, (_) => const ScenarioListScreen())),
      _section(tr('정보')),
      _NavRow(seal: 'ⓘ', color: DramaColors.muted, title: tr('앱 소개'), subtitle: tr('절벽 구간 · 산출 방식'), onTap: () => openPane(context, (_) => const AboutScreen())),
    ],
  );
}

// ────────── 나 ──────────

class MeTab extends StatelessWidget {
  const MeTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: _pad(context), children: [_section(tr('성과')), const AchievementDesk(), _section(tr('프로필 · 설정')), const ProfileScreen(embedded: true)]);
}
