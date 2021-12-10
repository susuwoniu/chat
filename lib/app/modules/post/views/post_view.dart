import 'package:chat/app/modules/post/views/templates.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../controllers/post_controller.dart';
import 'package:tcard/tcard.dart';
import './templates.dart';

class PostCard extends StatefulWidget {
  @override
  _TCardPageState createState() => _TCardPageState();
}

class _TCardPageState extends State<PostCard> {
  // class PostView extends GetView<PostController> {

  final TCardController _controller = TCardController();
  int _index = 0;
  final _postController = PostController.to;
  final _indexList = PostController.to.postTemplatesIndexes;
  final _map = PostController.to.postTemplatesMap;
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return Obx(() => Center(
          child: _postController.isLoading.value
              ? Text("loading")
              : Column(
                  children: <Widget>[
                    SizedBox(height: 15),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: _width * 0.075),
                      child: Text("Select_a_question".tr,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 10),
                    TCard(
                      size: Size(_width * 0.95,
                          MediaQuery.of(context).size.height * 0.7),
                      cards: List.generate(
                        _indexList.length,
                        (int index) {
                          final _item = _map[_indexList[index]];

                          return GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.ANSWER,
                                    arguments: {"id": _indexList[index]});
                              },
                              child: Container(
                                alignment: Alignment.topLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(10)),
                                  color: HexColor(_item!.backgroundColor),
                                ),
                                child: Templates(
                                    question: _item.content,
                                    enabled: false,
                                    id: _indexList[index]),
                              ));
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
    return SafeArea(
        child: Scaffold(
      body: PostCard(),
    ));
  }
}
