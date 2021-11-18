import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../controllers/post_controller.dart';
import 'package:tcard/tcard.dart';

class PostCard extends StatefulWidget {
  @override
  _TCardPageState createState() => _TCardPageState();
}

class _TCardPageState extends State<PostCard> {
  // class PostView extends GetView<PostController> {

  final TCardController _controller = TCardController();
  int _index = 0;
  final _postController = PostController.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Center(
          child: _postController.isLoading.value
              ? Text("loading")
              : Column(
                  children: <Widget>[
                    SizedBox(height: 5),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.075),
                      child: Text("Select_a_question".tr,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    TCard(
                      size: Size(MediaQuery.of(context).size.width * 0.95,
                          MediaQuery.of(context).size.height * 0.7),
                      cards: List.generate(
                        _postController.postTemplatesIndexes.length,
                        (int index) {
                          return GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.ANSWER, arguments: {
                                  "id": _postController
                                      .postTemplatesIndexes[index]
                                });
                              },
                              child: Container(
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(10),
                                        topRight: const Radius.circular(10),
                                        bottomLeft: const Radius.circular(10),
                                        bottomRight: const Radius.circular(10)),
                                    color: HexColor(_postController
                                        .postTemplatesMap[_postController
                                            .postTemplatesIndexes[index]]!
                                        .backgroundColor),
                                  ),
                                  child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 20, 0, 0),
                                      child: Text(
                                        _postController
                                            .postTemplatesMap[_postController
                                                .postTemplatesIndexes[index]]!
                                            .content,
                                        style: TextStyle(
                                            fontSize: 26.0,
                                            color: Colors.white),
                                      ))));
                        },
                      ),
                      controller: _controller,
                      onForward: (index, info) {
                        _index = index;
                        print(info.direction);
                        setState(() {});
                      },
                      onBack: (index, info) {
                        _index = index;
                        setState(() {});
                      },
                      onEnd: () {
                        print('end');
                      },
                    ),
                  ],
                ),
        ));
  }
}

class PostView extends GetView<PostController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PostView'),
        centerTitle: true,
      ),
      body: PostCard(),
    );
  }
}
