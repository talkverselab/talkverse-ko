import 'package:flutter/material.dart';

import 'embed.dart';

/// 단독 앱. 초기화·화면은 embed.dart 와 같다(통합 앱 Talkverse 가 같은 두 함수를 부른다).
void main() async {
  await embedInit();
  runApp(embedApp());
}
