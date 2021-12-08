import 'package:chat/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../home/controllers/home_controller.dart';
import 'package:hexcolor/hexcolor.dart';

class MyPosts extends StatelessWidget {
  MyPosts({
    Key? key,
  }) : super(key: key);
  final _controller = HomeController.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _width = MediaQuery.of(context).size.width;
      final double paddingLeft = _width * 0.07;

      final _myPostsList = <Widget>[];
      for (var id in _controller.myPostsIndexes) {
        _myPostsList.add(
          GestureDetector(
              onTap: () {
                Get.toNamed(Routes.MY_SINGLE_POST, arguments: {
                  'postId': id,
                  'content': _controller.postMap[id]!.content,
                  "backgroundColor": _controller.postMap[id]!.backgroundColor,
                });
              },
              child: Container(
                margin: EdgeInsets.all(paddingLeft / 2),
                padding: EdgeInsets.all(_width * 0.03),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: HexColor(_controller.postMap[id]!.backgroundColor),
                ),
                height: _width * 0.4,
                width: _width * 0.4,
                child: Text(
                  _controller.postMap[id]!.content,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                  ),
                ),
              )),
        );
      }

      return SizedBox(
        width: double.infinity,
        child: Wrap(alignment: WrapAlignment.center, children: _myPostsList),
      );
    });
  }
}
