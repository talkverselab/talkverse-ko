import 'package:flutter_test/flutter_test.dart';
import 'package:k_universe/curriculum/curriculum_service.dart';
import 'package:k_universe/data/entitlement.dart';
import 'package:k_universe/drama/drama_service.dart';

/// 이용권 잠금 경계(PAYWALL_SPEC §2·§5): 1단계 열림 · 2단계 잠김 · 이용권 있으면 열림.
DramaEpisode ep(String region) => DramaEpisode.fromJson({'id': 'x_$region', 'region': region, 'turns': []});

void main() {
  tearDown(() => Entitlement.premiumForTest = null);

  test('이용권 없음 — 1단계·R0·R1·언어감각 1급만 열림', () {
    Entitlement.premiumForTest = false;
    final p = parsePlan('{"rev":2,"freeSenseLevels":1,"stages":[{"n":1,"dialogueIds":[],"free":true},{"n":2,"dialogueIds":[],"free":false},{"n":3,"dialogueIds":[]}]}')!;
    expect(Entitlement.canOpenStage(p.stages[0]), isTrue);
    expect(Entitlement.canOpenStage(p.stages[1]), isFalse);
    expect(Entitlement.canOpenStage(p.stages[2]), isFalse); // free 값이 없으면 1단계만 무료
    expect(p.freeSense, 1);
    expect(Entitlement.canOpenEpisode(ep('R0')), isTrue);
    expect(Entitlement.canOpenEpisode(ep('R1')), isTrue);
    expect(Entitlement.canOpenEpisode(ep('R2')), isFalse);
    CurriculumService.instance.freeSenseLevels = 1;
    expect(Entitlement.canOpenSenseLevel(0), isTrue);
    expect(Entitlement.canOpenSenseLevel(1), isFalse);
  });

  test('이용권 있음 — 모두 열림', () {
    Entitlement.premiumForTest = true;
    expect(Entitlement.canOpenStage(const CurStage(2, '2단계', '', [], free: false)), isTrue);
    expect(Entitlement.canOpenEpisode(ep('R3')), isTrue);
    expect(Entitlement.canOpenSenseLevel(9), isTrue);
  });

  test('서버 단계표가 무료 범위를 바꿈 — 2단계 free:true 면 열림', () {
    Entitlement.premiumForTest = false;
    final p = parsePlan('{"rev":3,"freeSenseLevels":2,"stages":[{"n":2,"dialogueIds":[],"free":true}]}')!;
    expect(Entitlement.canOpenStage(p.stages[0]), isTrue);
    expect(p.freeSense, 2);
  });
}
