import 'dart:convert';

import 'package:flutter/material.dart';

import 'main.dart';

// 원래는 main.dart 파일에 memoList(List 형태)로 만들었지만, class로 만드는 것이 좋음
// Memo 데이터의 형식을 정해줍니다. 추후 isPinned, updatedAt 등의 정보도 저장할 수 있습니다.
class Memo {
  Memo({
    required this.content,
  });

  String content;

  Map toJson() {
    return {'content': content};
  }

  factory Memo.fromJson(json) {
    return Memo(content: json['content']);
  }
}

// Memo 데이터는 모두 여기서 관리 / 위에서는 틀만 만든 것이고, 여기서 모든 구현 및 관리
class MemoService extends ChangeNotifier {
  MemoService() {
    loadMemoList();
  }

  List<Memo> memoList = [
    Memo(content: '장보기 목록: 사과, 양파'), // 더미(dummy) 데이터
    Memo(content: '새 메모'), // 더미(dummy) 데이터
  ];

  createMemo({required String content}) {
    Memo memo = Memo(content: content);
    memoList.add(memo);

    notifyListeners(); // Consumer<MemoService>의 builder 부분을 호출해서 화면 새로고침 => 요거만 쓰면 해당 클래스를 Consumer하고 있는 위젯은 화면을 새로고침함
    saveMemoList();
  }

  // index : 몇번째 메모를 업데이트 하는지를 결정하는 idx
  updateMemo({required int index, required String content}) {
    Memo memo = memoList[index];
    memo.content = content;
    notifyListeners();
    saveMemoList();
  }

  deleteMemo({required int index}) {
    memoList.removeAt(index);
    notifyListeners();
    saveMemoList();
  }

  saveMemoList() {
    List memoJsonList = memoList
        .map((memo) => memo.toJson())
        .toList(); // map : 하나하나 돌면서 뭘 어떻게 바꿔줄 것인지 정하는 함수
    // [{"content": "1"}, {"content": "2"}]

    String jsonString = jsonEncode(memoJsonList);
    // '[{"content": "1"}, {"content": "2"}]'

    prefs.setString('memoList', jsonString);
  }

  loadMemoList() {
    String? jsonString = prefs.getString('memoList');
    // '[{"content": "1"}, {"content": "2"}]'

    if (jsonString == null) return; // null 이면 로드하지 않음

    List memoJsonList = jsonDecode(jsonString);
    // [{"content": "1"}, {"content": "2"}]

    memoList = memoJsonList.map((json) => Memo.fromJson(json)).toList();
  }
}
