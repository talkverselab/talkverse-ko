import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../services/content_sync.dart';
import '../services/learner_prefs.dart';
import '../services/tts_service.dart';
import 'drama_service.dart';

/// 회화 턴의 생성 음성(mp4) — 일본어앱 `dialogue_audio.dart` 를 옮김(구조 = 일본어앱 `docs/DIALOGUE_AUDIO.md`).
/// 목록은 `ContentSync.audioIndex`(편 → 턴 → 판 m·f). 기기에 받은 파일이 있으면 파일, 없으면 주소로 재생.
/// 음성이 없는 턴은 기기 음성(TTS)으로 읽는다 — 한국어 음성이 DB 에 올라오기 전에는 전부 TTS.
class DramaAudio {
  DramaAudio._();
  static final DramaAudio instance = DramaAudio._();

  AudioPlayer? _player;
  Completer<void>? _wait;
  int _gen = 0;

  AudioLine? line(String episodeId, int turn) => ContentSync.instance.audioIndex[episodeId]?[turn]?[LearnerPrefs.isFemale ? 'f' : 'm'];

  /// 이름 자리가 있는 턴마다 음성이 있는가(있으면 이름을 묻지 않는다 — 음성판의 이름으로 보인다).
  bool covers(DramaEpisode e) => e.turns.every((t) => !t.ko.contains('{name}') || line(e.id, t.num) != null);

  /// 음성을 끝까지 재생한다. 음성이 없거나 재생에 실패하면 false(부르는 쪽이 TTS 로 넘긴다).
  Future<bool> play(String episodeId, int turn, {double rate = 1.0}) async {
    final l = line(episodeId, turn);
    if (l == null) return false;
    final my = ++_gen;
    try {
      await TtsService.instance.stop();
      final p = _player ??= AudioPlayer();
      await p.stop();
      _wait?.complete();
      final done = _wait = Completer<void>();
      final sub = p.onPlayerComplete.listen((_) {
        if (!done.isCompleted) done.complete();
      });
      try {
        final url = '${ContentSync.instance.base}/${l.key}';
        final f = ContentSync.instance.localFile(url);
        await p.setPlaybackRate(rate);
        await p.play(f != null ? DeviceFileSource(f.path) : UrlSource(url)).timeout(const Duration(seconds: 12));
        if (my != _gen) return true;
        await p.setPlaybackRate(rate); // 일부 기기는 재생을 시작한 뒤에야 속도가 먹는다
        await done.future.timeout(Duration(milliseconds: (l.ms / rate).round() + 6000), onTimeout: () {});
      } finally {
        await sub.cancel();
      }
      return true;
    } catch (e) {
      debugPrint('DramaAudio: 재생 실패 $episodeId/$turn $e');
      return false;
    }
  }

  Future<void> stop() async {
    _gen++;
    final w = _wait;
    if (w != null && !w.isCompleted) w.complete();
    try {
      await _player?.stop();
    } catch (_) {}
    await TtsService.instance.stop();
  }
}

/// 턴 하나 읽기: 생성 음성이 있으면 그것, 없으면 기기 음성. 끝날 때까지 기다린다.
Future<void> speakTurn(DramaEpisode e, DramaTurn t, {double rate = 1.0}) async {
  if (await DramaAudio.instance.play(e.id, t.num, rate: rate)) return;
  // 지문·ㅋㅋ·이모지(어조사 턴에 붙는 감정 이모지)는 소리 내지 않는다
  final s = DramaEpisode.fill(t.ko).replaceAll(RegExp(r'\([^)]*\)'), '').replaceAll(RegExp(r'[ㅋㅎㅠㅜ]+'), '').replaceAll(RegExp(r'[\u{1F300}-\u{1FAFF}\u{2600}-\u{27BF}\u{2B50}\u{FE0F}]', unicode: true), '').trim();
  if (s.isNotEmpty) await TtsService.instance.speakAndWait(s, rate: 0.45 * rate);
}
