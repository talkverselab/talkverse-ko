import 'package:flutter/material.dart';

/// 파스텔 메시 그라데이션 — talkverse.uk 히어로 배경을 옮긴 것. 홈 상단에만 쓴다.
class MeshBackdrop extends StatelessWidget {
  const MeshBackdrop({super.key});

  static const _blobs = <(Alignment, Color)>[
    (Alignment(-0.8, -0.3), Color(0xFFFFD39B)),
    (Alignment(-0.2, -0.9), Color(0xFFF5B8E6)),
    (Alignment(0.45, -0.5), Color(0xFFA9A4FF)),
    (Alignment(0.95, 0.2), Color(0xFF8FE3FF)),
  ];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xFFECEAFF)),
          for (final (align, color) in _blobs)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: align,
                  radius: 0.9,
                  colors: [
                    color.withValues(alpha: 0.85),
                    color.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          // 아래로 갈수록 흰 바탕에 녹아들게
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x26FFFFFF), Color(0x8CFFFFFF), Colors.white],
                stops: [0, 0.6, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
