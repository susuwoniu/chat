import 'package:chat/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../home/controllers/home_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat/app/widges/max_text.dart';

class MyPosts extends StatelessWidget {
  MyPosts({
    Key? key,
  }) : super(key: key);
  final _controller = HomeController.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _width = _controller.screenSize[0];

      final _myPostsList = <Widget>[];
      for (var id in _controller.myPostsIndexes) {
        _myPostsList.add(
          Column(
            children: [
              GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.MY_SINGLE_POST);
                  },
                  child: Container(
                    margin: EdgeInsets.all(_width * 0.025),
                    padding: EdgeInsets.all(_width * 0.025),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: HexColor(_controller.postMap[id]!.backgroundColor),
                    ),
                    height: _width * 0.4,
                    width: _width * 0.4,
                    child: MaxText(
                      _controller.postMap[id]!.content,
                      context,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white,
                      ),
                    ),
                  ))
            ],
          ),
        );
      }

      return Container(
          child: Wrap(direction: Axis.horizontal, children: [
        Expanded(
          flex: 1,
          child: Wrap(children: _myPostsList),
        ),
      ]));
    });
  }
}
