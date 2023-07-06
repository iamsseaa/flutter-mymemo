import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'memo_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                MemoService()), // MemoService를 provider로 최상단에 지정
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// 홈 페이지
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<String> memoList = ['장보기 목록 : 사과, 양파', '새 메모']; // 전체 메모 목록 / MemoService를 사용하면서 안 씀

  @override
  Widget build(BuildContext context) {
    // Consumer<MemoService>는 위젯 트리를 타고 올라가 provider로 지정된 MemoService를 찾음, 찾은 MemoService를 해당 라인의 memoService 변수에 담는 것
    // Consumer를 쓰는 근본적인 이유 : memo_service 파일에서 memo에 수정이 생기면, notify 함수 호출을 할건데 그러면 Consumer 위젯의 자녀로 있는 것들이 리셋됨
    return Consumer<MemoService>(builder: (context, memoService, child) {
      // memoService로부터 memoList 가져오기
      List<Memo> memoList = memoService.memoList;

      return Scaffold(
        appBar: AppBar(
          title: Text("mymemo"),
        ),
        body: memoList.isEmpty
            ? Center(child: Text("메모를 작성해 주세요.")) // true
            : ListView.builder(
                itemCount: memoList.length,
                itemBuilder: (context, index) {
                  Memo memo = memoList[index];
                  return ListTile(
                    // 메모 고정 아이콘
                    leading: IconButton(
                      icon: Icon(CupertinoIcons.pin),
                      onPressed: () {
                        print('$memo : pin 클릭 됨');
                      },
                    ),
                    title: Text(
                      memo.content,
                      maxLines:
                          3, // title 은 최대 3줄까지 가능한데, isThreeLine: true로도 설정 가능
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // 아이템 클릭 시
                      // Navigator.push(
                      //   // 리스트타일 눌렀을 때 DetailPage로 이동하게 함
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (_) => DetailPage(
                      //             index: index,
                      //             memoList: memoList,
                      //           )),
                      // );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(
                            index: index,
                          ),
                        ),
                      );
                    },
                  );
                },
              ), // false
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // + 버튼 클릭시 메모 생성 및 수정 페이지로 이동
            // String memo = '';
            // setState(() {
            //   memoList.add(memo);
            // });
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => DetailPage(
            //       index: memoList.indexOf(memo),
            //       memoList: memoList,
            //     ),
            //   ),
            // );
          },
        ),
      );
    });
  }
}

// 메모 생성 및 수정 페이지
class DetailPage extends StatelessWidget {
  // DetailPage({super.key, required this.memoList, required this.index});
  DetailPage({super.key, required this.index});

  final int index;

  // final List<String> memoList; // 85, 86번 째 코드: DetailPage에서 HomePage에서 넘어온 메모 내용을 변수에 담아 사용하기 위해 변수 선언

  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // contentController.text = memoList[index]; // 해당 화면의 초깃값 텍스트를 초기화할 수 있음
    MemoService memoService = context.read<MemoService>();
    Memo memo = memoService.memoList[index];

    contentController.text = memo.content;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // 삭제 버튼 클릭시 =>
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("정말로 삭제하시겠습니까?"),
                    // 텍스트 아래 나올 버튼들
                    actions: [
                      // 취소 버튼
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("취소"),
                      ),
                      // 확인 버튼
                      TextButton(
                        onPressed: () {
                          // memoList.removeAt(index); // 해당 index에 해당하는 항목 삭제
                          Navigator.pop(context); // 팝업 닫기
                          Navigator.pop(context); // HomePage로 가기
                        },
                        child: Text(
                          "확인",
                          style: TextStyle(color: Colors.pink),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: contentController,
          decoration: InputDecoration(
            hintText: "메모를 입력하세요",
            border: InputBorder.none,
          ),
          autofocus: true,
          maxLines: null,
          expands: true,
          keyboardType: TextInputType.multiline,
          onChanged: (value) {
            // 텍스트필드 안의 값이 변할 때 => 이 경우 아래 코드로 수정된 텍스트로 원래의 변수 값에 저장해주면 됨. / 근데 변수에서는 바뀌는데 HomePage UI에서는 바뀌지 않음 / 근데 만약에 여기서도 SetState를 쓰려고 한다면? x why?_) 두 개의 화면이 다르기 때문
            // memoList[index] = value;
          },
        ),
      ),
    );
  }
}
