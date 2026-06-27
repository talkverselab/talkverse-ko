import 'package:flutter/material.dart';

/// Globy — K-Universe mascot with 12 emotional expressions.
/// All PNGs are transparent-backgrounded; ratio 384 : 341.
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

  String get _asset {
    switch (pose) {
      case MascotPose.happy:
        return 'assets/mascot/happy.png';
      case MascotPose.excited:
        return 'assets/mascot/excited.png';
      case MascotPose.normal:
        return 'assets/mascot/normal.png';
      case MascotPose.worried:
        return 'assets/mascot/worried.png';
      case MascotPose.angry:
        return 'assets/mascot/angry.png';
      case MascotPose.annoyed:
        return 'assets/mascot/annoyed.png';
      case MascotPose.sad:
        return 'assets/mascot/sad.png';
      case MascotPose.disappointed:
        return 'assets/mascot/disappointed.png';
      case MascotPose.gaveUp:
        return 'assets/mascot/gave_up.png';
      case MascotPose.tired:
        return 'assets/mascot/tired.png';
      case MascotPose.badMood:
        return 'assets/mascot/bad_mood.png';
      case MascotPose.meltdown:
        return 'assets/mascot/meltdown.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _asset,
      width: size,
      height: size * (341.0 / 384.0),
      fit: BoxFit.contain,
    );
  }
}
