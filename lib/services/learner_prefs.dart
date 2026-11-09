import '../core/embed_env.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 회화 속 「나」 — 이름·성별(사용자 지시 2026-11-04, 일본어앱 learner_prefs 와 같은 뜻).
/// 이름은 대사의 `{name}` 자리, 성별은 장면 컷(여자면 `<편id>_f` 컷 먼저)에 쓴다.
class LearnerPrefs {
  LearnerPrefs._();
  static final ValueNotifier<String> name = ValueNotifier('');
  static final ValueNotifier<String> gender = ValueNotifier('male'); // male | female
  /// 읽기 보조(로마자) 전역 표시 — 기본 미표시(일본어앱 후리가나 토글과 같은 뜻, 2026-11-07).
  static final ValueNotifier<bool> roman = ValueNotifier(false);

  static bool get isFemale => gender.value == 'female';

  static Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    name.value = p.getString('learner_name') ?? '';
    gender.value = p.getString('learner_gender') ?? 'male';
    roman.value = p.getBool(pk('roman_show')) ?? false;
  }

  static Future<void> setRoman(bool v) async {
    roman.value = v;
    (await SharedPreferences.getInstance()).setBool(pk('roman_show'), v);
  }

  static Future<void> setName(String v) async {
    name.value = v.trim();
    (await SharedPreferences.getInstance()).setString('learner_name', name.value);
  }

  static Future<void> setGender(String v) async {
    gender.value = v == 'female' ? 'female' : 'male';
    (await SharedPreferences.getInstance()).setString('learner_gender', gender.value);
  }
}
