import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../core/platform.dart';

/// Wraps `flutter_tts` for Korean speech.
///
/// Uses whatever Korean TTS voice the device provides (Samsung Voice on Galaxy,
/// Google's Korean voice on most Androids, Apple's Yuna on iOS). Quality varies
/// by device, but every modern phone has a usable ko-KR engine bundled.
class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool _isSpeaking = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    if (isIOS) {
      // 무음 스위치가 켜져 있어도 재생되게, 다른 앱 소리는 잠시 줄이게
      await _tts.setSharedInstance(true);
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.duckOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ],
        IosTextToSpeechAudioMode.spokenAudio,
      );
    }
    try {
      await _tts.setLanguage('ko-KR');
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _tts.setCompletionHandler(() {
        _isSpeaking = false;
      });
      _tts.setCancelHandler(() {
        _isSpeaking = false;
      });
      _tts.setErrorHandler((msg) {
        debugPrint('TTS error: $msg');
        _isSpeaking = false;
      });
      _initialized = true;
    } catch (e) {
      debugPrint('TTS init failed: $e');
    }
  }

  Future<void> speak(String text) async {
    await _ensureInit();
    if (_isSpeaking) {
      await _tts.stop();
    }
    _isSpeaking = true;
    try {
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak failed: $e');
      _isSpeaking = false;
    }
  }

  Future<void> stop() async {
    if (!_initialized) return;
    await _tts.stop();
    _isSpeaking = false;
  }
}
