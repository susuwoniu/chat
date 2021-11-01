import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TikTokStyleFullPageScroller(
        contentSize: controller.postIndexes.length,
        swipePositionThreshold: 0.2,
        // ^ the fraction of the screen needed to scroll
        swipeVelocityThreshold: 2000,
        // ^ the velocity threshold for smaller scrolls
        animationDuration: const Duration(milliseconds: 300),
        // ^ how long the animation will take
        onScrollEvent: _handleCallbackEvent,
        // ^ registering our own function to listen to page changes
        builder: (BuildContext context, int index) {
          return Container(
            color: HexColor(controller
                .postMap[controller.postIndexes[index]]!.backgroundColor),
            padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
            alignment: Alignment.topLeft,
            child: GestureDetector(
                onTap: () async {
                  print("tap");
                  Get.rootDelegate.toNamed(Routes.ROOM);
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: Text(
                        '$index' * 50,
                        key: Key('$index-text'),
                        style:
                            const TextStyle(fontSize: 48, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                      padding: const EdgeInsets.only(right: 10.0),
                    ),
                    Padding(padding: const EdgeInsets.only(bottom: 10.0)),
                    Row(children: [
                      TextButton(
                        onPressed: () async {},
                        child: CircleAvatar(radius: 30),
                      ),
                      Padding(padding: const EdgeInsets.only(right: 8.0)),
                      Text(
                        '$index',
                        key: Key('$index-text'),
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white),
                      ),
                    ]),
                  ],
                )),
          );
        },
      ),
    );
  }

  void _handleCallbackEvent(ScrollEventType type, {int? currentIndex}) {
    if (currentIndex != null && currentIndex > 0) {
      controller.setIndex(currentIndex);
    }
    print(
        "Scroll callback received with data: {type: $type, and index: ${currentIndex ?? 'not given'}}");
  }
}

class ChatRoute extends StatelessWidget {
  final String text;

  ChatRoute({
    Key? key,
    @required this.text = " ", // 接收一个text参数
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("提示"),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(text),
              TextButton(
                onPressed: () => Navigator.pop(context, "我是返回值"),
                child: Text("返回"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final List<Color> _colors = <Color>[
//       Colors.red,
//       Colors.yellow,
//       Colors.green,
//       Colors.orange,
//     ];

//     return MaterialApp(
//       routes: {
//         "chat_page": (context) => ChatRoute(),
//         "/": (context) => HomeWidget(colors: _colors), //注册首页路由
//       },
//     );
//   }
// }

