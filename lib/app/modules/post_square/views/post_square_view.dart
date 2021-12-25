import 'package:flutter/material.dart';
import 'package:chat/utils/random.dart';
import 'package:get/get.dart';
import '../controllers/post_square_controller.dart';
import 'package:chat/common.dart';
import '../../me/views/my_posts.dart';

class PostSquareView extends GetView<PostSquareController> {
  final _title = Get.arguments['title'];
  final _id = int.parse(Get.arguments['id']);
  final backgroundColorIndex = get_random_index(BACKGROUND_COLORS.length);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final backgroundColor = BACKGROUND_COLORS[backgroundColorIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: _height * 0.2,
                width: _width,
                color: backgroundColor,
                padding: EdgeInsets.symmetric(
                    horizontal: _width * 0.06, vertical: 10),
                child: Text(_title,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Positioned(
                  bottom: -_width * 0.1,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(_width * 0.2)),
                      height: _width * 0.2,
                      width: _width * 0.2,
                      child: Icon(
                        Icons.face_outlined,
                        size: _width * 0.13.toDouble(),
                        color: Colors.black54,
                      ))),
            ],
          ),
          SizedBox(height: _height * 0.06),
          Obx(() {
            final usedCount = controller.usedCount.value;
            return Text(
                usedCount > 1
                    ? usedCount.toString() + ' Posts'.tr
                    : usedCount.toString() + ' Post'.tr,
                style: TextStyle(fontSize: 17.0, color: Colors.black54));
          }),
          MyPosts(postTemplateId: _id.toString()),
        ],
      )),
    );
  }
}
