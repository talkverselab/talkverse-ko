import 'package:flutter/material.dart';

/// 마스코트 자리 — 표정 12종을 그림 파일 대신 이모지로 그린다.
/// (2026-11-02 출처 불명 마스코트 그림 12장 삭제 — 자체 제작 그림이 생기면 여기만 바꾼다.)
enum MascotPose {
  happy,         // 행복해
  excited,       // 신나요
  normal,        // 보통이야
  worried,       // 걱정돼
  angry,         // 화가 나
  annoyed,       // 짜증나
  sad,           // 슬퍼
  disappointed,  // 실망이야
  gaveUp,        // 포기했어
  tired,         // 지쳤어
  badMood,       // 못마땅해
  meltdown,      // 멘붕이야
}

class Mascot extends StatelessWidget {
  final MascotPose pose;
  final double size;
  const Mascot(this.pose, {super.key, this.size = 64});

  String get _emoji {
    switch (pose) {
      case MascotPose.happy:
        return '😊';
      case MascotPose.excited:
        return '🤩';
      case MascotPose.normal:
        return '🙂';
      case MascotPose.worried:
        return '😟';
      case MascotPose.angry:
        return '😠';
      case MascotPose.annoyed:
        return '😒';
      case MascotPose.sad:
        return '😢';
      case MascotPose.disappointed:
        return '😞';
      case MascotPose.gaveUp:
        return '🫠';
      case MascotPose.tired:
        return '😮‍💨';
      case MascotPose.badMood:
        return '😑';
      case MascotPose.meltdown:
        return '🤯';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Text(_emoji, style: TextStyle(fontSize: size * 0.55, height: 1)),
    );
  }
}
