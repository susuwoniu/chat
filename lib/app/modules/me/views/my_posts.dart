import 'package:chat/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../home/controllers/home_controller.dart';
import '../../other/controllers/other_controller.dart';
import 'package:chat/types/types.dart';
import 'package:chat/config/config.dart';
import '../../post_square/controllers/post_square_controller.dart';
import 'package:chat/utils/random.dart';
import 'package:chat/common.dart';

final imDomain = AppConfig().config.imDomain;

class MyPosts extends StatelessWidget {
  final String? profileId;
  final String? postTemplateId;

  MyPosts({
    Key? key,
    this.profileId,
    this.postTemplateId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late List<String> postsIndexes;
    late Map<String, PostEntity> postMap;
    final backgroundColorIndex = get_random_index(BACKGROUND_COLORS.length);

    return Obx(() {
      if (profileId != null) {
        postsIndexes = OtherController.to.myPostsIndexes;
        postMap = OtherController.to.postMap;
      } else if (postTemplateId != null) {
        postsIndexes = PostSquareController.to.myPostsIndexes;
        postMap = PostSquareController.to.postMap;
      } else {
        postsIndexes = HomeController.to.myPostsIndexes;
        postMap = HomeController.to.postMap;
      }

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
      if (profileId == null && postTemplateId == null) {
        _myPostsList.insert(0, createPost(context: context));
      } else if (postTemplateId != null) {
        _myPostsList.insert(
            0,
            createPost(
                context: context,
                type: 'toCreate',
                id: postTemplateId,
                backgroundColorIndex: backgroundColorIndex));
      }
      return SizedBox(
        width: double.infinity,
        child:
            Wrap(alignment: WrapAlignment.spaceBetween, children: _myPostsList),
      );
    });
  }

  Widget createPost(
      {required BuildContext context,
      String? type,
      String? id,
      int? backgroundColorIndex}) {
    final _width = MediaQuery.of(context).size.width;
    final double paddingLeft = _width * 0.05;
    final double paddingTop = _width * 0.04;

    return GestureDetector(
        onTap: () {
          if (type != null) {
            Get.toNamed(Routes.CREATE, arguments: {
              "id": id,
              "background-color-index": backgroundColorIndex
            });
          } else {
            Get.toNamed(Routes.POST);
          }
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
                  if (type == 'toCreate') {
                    Get.toNamed(Routes.CREATE, arguments: {
                      "id": id,
                      "background-color-index": backgroundColorIndex
                    });
                  } else {
                    Get.toNamed(Routes.POST);
                  }
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
