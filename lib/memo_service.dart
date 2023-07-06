import 'package:flutter/material.dart';

import 'main.dart';

// 원래는 main.dart 파일에 memoList(List 형태)로 만들었지만, class로 만드는 것이 좋음
// Memo 데이터의 형식을 정해줍니다. 추후 isPinned, updatedAt 등의 정보도 저장할 수 있습니다.
class Memo {
  Memo({
    required this.content,
  });

  String content;
}

// Memo 데이터는 모두 여기서 관리 / 위에서는 틀만 만든 것이고, 여기서 모든 구현 및 관리
class MemoService extends ChangeNotifier {
  List<Memo> memoList = [
    Memo(content: '장보기 목록: 사과, 양파'), // 더미(dummy) 데이터
    Memo(content: '새 메모'), // 더미(dummy) 데이터
  ];
}
