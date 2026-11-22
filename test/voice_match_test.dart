import 'package:flutter_test/flutter_test.dart';
import 'package:k_universe/drama/drama_service.dart';

/// 녹음 음성 ↔ 대사 맞춤(사용자 지시 2026-11-22 「음성이 없는건 TTS로」) — 대사가 바뀐 옛 음성은 TTS 로.
void main() {
  bool m(String rec, String ko, [List<String> alt = const []]) =>
      DramaTurn(num: 1, speaker: 'A', ko: ko, rd: '', en: '', note: '', voiceAlt: alt).matchesVoice(rec);

  test('같은 대사·문장부호/이모지 차이 → 녹음', () {
    expect(m('헐, 아까 복도에서 떨어뜨렸잖아! 😮', '헐, 아까 복도에서 떨어뜨렸잖아!'), isTrue);
  });
  test('{name} 자리와 뒤 조사 차이 → 녹음', () {
    expect(m('에마야 이거 봐 너 최애 누구야?', '{name}아 이거 봐 너 최애 누구야?'), isTrue);
    expect(m('아… 알렉스예요. 펜은 그냥 쓰세요.', '아… {name}이에요. 펜은 그냥 쓰세요.'), isTrue);
    expect(m('캐나다요 한국어 배운 지 2년 됐어요', '{country}요 한국어 배운 지 2년 됐어요'), isTrue);
  });
  test('대사가 바뀐 옛 음성 → TTS', () {
    expect(m('(10분 뒤) 벌써 열 팀째예요. 정신없어요.', '(10분 뒤) 와, 벌써 열 팀이라 정신없어요.'), isFalse);
    expect(m('네? 열 상자 다 김치예요?', '네? 상자 열 개 다 김치예요?'), isFalse);
  });
  test('성별 판은 voice_alt 로 녹음', () {
    expect(m('누나 여자친구야?', '누나 남자친구야?'), isFalse);
    expect(m('누나 여자친구야?', '누나 남자친구야?', ['누나 여자친구야?']), isTrue);
  });
  test('녹음 문장이 비면(옛 목록) 녹음', () => expect(m('', '아무 대사'), isTrue));
}
