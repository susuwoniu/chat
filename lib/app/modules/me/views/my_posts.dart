import 'package:chat/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../home/controllers/home_controller.dart';
import '../../other/controllers/other_controller.dart';

import 'package:chat/config/config.dart';

final imDomain = AppConfig().config.imDomain;

class MyPosts extends StatelessWidget {
  final String? profileId;
  MyPosts({
    Key? key,
    this.profileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postsIndexes = profileId != null
        ? OtherController.to.myPostsIndexes
        : HomeController.to.myPostsIndexes;
    final postMap = profileId != null
        ? OtherController.to.postMap
        : HomeController.to.postMap;

    return Obx(() {
      final _width = MediaQuery.of(context).size.width;
      final double paddingLeft = _width * 0.05;
      final double paddingTop = _width * 0.04;
      final _myPostsList = <Widget>[];

      for (var id in postsIndexes) {
        _myPostsList.add(
          GestureDetector(
              onTap: () {
                if (profileId != null) {
                  Get.toNamed(Routes.ROOM, arguments: {
                    "id": "im$profileId@$imDomain",
                    "post_id": id
                  });
                } else {
                  Get.toNamed(Routes.MY_SINGLE_POST, arguments: {
                    'postId': id,
                    'content': postMap[id]!.content,
                    "backgroundColor": postMap[id]!.backgroundColor,
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(
                    paddingLeft, paddingTop, paddingLeft, paddingTop),
                padding: EdgeInsets.all(_width * 0.03),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(postMap[id]!.backgroundColor),
                ),
                height: _width * 0.4,
                width: _width * 0.4,
                child: Text(
                  postMap[id]!.content,
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
      if (profileId == null) {
        _myPostsList.insert(0, createPost(context));
      }
      return SizedBox(
        width: double.infinity,
        child:
            Wrap(alignment: WrapAlignment.spaceBetween, children: _myPostsList),
      );
    });
  }

  Widget createPost(context) {
    final _width = MediaQuery.of(context).size.width;
    final double paddingLeft = _width * 0.05;
    final double paddingTop = _width * 0.04;

    return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.POST);
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(
              paddingLeft, paddingTop, paddingLeft, paddingTop),
          padding: EdgeInsets.all(_width * 0.03),
          height: _width * 0.4,
          width: _width * 0.4,
          decoration: BoxDecoration(
              color: Color(0xffe4e6ec), borderRadius: BorderRadius.circular(8)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Get.toNamed(Routes.POST);
                },
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  size: 52,
                  color: Colors.black54,
                )),
            SizedBox(height: 10),
            Text("Create_Post",
                style: TextStyle(color: Colors.black54, fontSize: 16))
          ]),
        ));
  }
}
