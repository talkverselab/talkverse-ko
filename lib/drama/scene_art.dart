import 'dart:convert';

import 'package:http/http.dart' as http;

/// 장면 컷 그림 — uk 세션이 R2 로 서빙(2026-11-02). 매니페스트 `GET /art/ko/scene/manifest` →
/// {base, items:[{episode, cut, key_1168, key_584}]}, 그림 = base + key. A·B 한 쌍 = 1컷(턴 n → 컷 (n+1)~/2).
class SceneArt {
  SceneArt._();
  static final SceneArt instance = SceneArt._();
  static const _manifest = 'https://auth.talkverse.uk/art/ko/scene/manifest';

  final Map<String, String> _full = {};
  final Map<String, String> _half = {};
  Future<void>? _loading;

  Future<void> ensureLoaded() => _loading ??= _load();

  Future<void> _load() async {
    try {
      final r = await http.get(Uri.parse(_manifest)).timeout(const Duration(seconds: 8));
      if (r.statusCode != 200) return;
      final j = jsonDecode(r.body) as Map<String, dynamic>;
      final base = j['base'] as String? ?? 'https://auth.talkverse.uk/art/';
      for (final it in (j['items'] as List? ?? const [])) {
        final m = it as Map<String, dynamic>;
        final k = '${m['episode']}#${m['cut']}';
        if (m['key_1168'] != null) _full[k] = '$base${m['key_1168']}';
        if (m['key_584'] != null) _half[k] = '$base${m['key_584']}';
      }
    } catch (_) {
      _loading = null; // 오프라인이면 다음에 다시
    }
  }

  /// 편·턴 번호(1부터)의 컷 주소. small = 절반 폭(목록 썸네일).
  String? cut(String episode, int turnNum, {bool small = false}) {
    final k = '$episode#${(turnNum + 1) ~/ 2}';
    return small ? (_half[k] ?? _full[k]) : (_full[k] ?? _half[k]);
  }
}
