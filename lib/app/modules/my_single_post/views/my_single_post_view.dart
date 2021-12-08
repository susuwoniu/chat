import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:get/get.dart';
import 'package:chat/app/widges/max_text.dart';
import '../controllers/my_single_post_controller.dart';
import '../../home/controllers/home_controller.dart';

class MySinglePostView extends GetView<MySinglePostController> {
  final _content = Get.arguments['content'];
  final _backgroundColor = Get.arguments['backgroundColor'];

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _homeController = HomeController.to;
    final _postId = Get.arguments['postId'];

    return Scaffold(
        appBar: AppBar(
          title: Text('MySinglePostView'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            margin: EdgeInsets.fromLTRB(_width * 0.03, 10, _width * 0.03, 20),
            padding: EdgeInsets.all(_width * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: HexColor(_backgroundColor),
            ),
            height: _height * 0.4,
            width: _width * 0.95,
            child: MaxText(
              _content,
              context,
              // textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                height: 1.6,
                fontSize: 26.0,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Obx(() => Column(
                children: _homeController.postMap[_postId]!.views != null
                    ? _homeController.postMap[_postId]!.views!
                        .map((e) => Container(child: Text(e)))
                        .toList()
                    : [],
              )),
        ])));
  }
}
