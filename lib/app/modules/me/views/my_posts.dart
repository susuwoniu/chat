import 'package:chat/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../home/controllers/home_controller.dart';
import '../../other/controllers/other_controller.dart';
import 'package:chat/types/types.dart';
import '../../post_square/controllers/post_square_controller.dart';
import 'package:chat/utils/random.dart';
import 'package:chat/common.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

final imDomain = AppConfig().config.imDomain;

class MyPosts extends StatefulWidget {
  final String? profileId;
  final String? postTemplateId;

  MyPosts({
    Key? key,
    this.profileId,
    this.postTemplateId,
  }) : super(key: key);
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  List<String> postsIndexes = [];
  Map<String, PostEntity> postMap = {};
  bool isLoading = true;
  String type = 'home';
  String? lastPostId;

  final PagingController _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    // _pagingController.addPageRequestListener((pageKey) {
    //   // _fetchPage(pageKey);
    // });

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    if (type == 'home') {
      isLoading = true;
      try {
        HomeController.to.getMePosts(after: lastPostId);
      } catch (e) {
        UIUtils.showError(e);
      }
      isLoading = false;
    } else if (type == 'other') {
      isLoading = true;
      try {
        OtherController.to
            .getAccountsPosts(after: lastPostId, id: widget.profileId!);
      } catch (e) {
        UIUtils.showError(e);
      }
      isLoading = false;
    } else if (type == 'square') {
      isLoading = true;
      try {
        PostSquareController.to.getTemplatesSquareData(
            after: lastPostId, postTemplateId: widget.postTemplateId!);
      } catch (e) {
        UIUtils.showError(e);
      }
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColorIndex = get_random_index(BACKGROUND_COLORS.length);

    return Obx(() {
      final _width = MediaQuery.of(context).size.width;
      final double paddingLeft = _width * 0.05;
      final double paddingTop = _width * 0.04;

      if (widget.profileId != null) {
        postsIndexes = OtherController.to.myPostsIndexes;
        postMap = OtherController.to.postMap;
        isLoading = OtherController.to.isLoadingPosts.value;
        type = 'other';
      } else if (widget.postTemplateId != null) {
        postsIndexes = PostSquareController.to.myPostsIndexes;
        postMap = PostSquareController.to.postMap;
        isLoading = PostSquareController.to.isLoadingPosts.value;
        type = 'square';
      } else {
        postsIndexes = HomeController.to.myPostsIndexes;
        postMap = HomeController.to.postMap;
        isLoading = HomeController.to.isLoadingMyPosts.value;
      }
      lastPostId = postsIndexes.last;
      final _myPostsList = <Widget>[];

      for (var id in postsIndexes) {
        final post = postMap[id]!;
        _myPostsList.add(
          GestureDetector(
              onTap: () {
                if (widget.profileId != null || widget.postTemplateId != null) {
                  Get.toNamed(Routes.ROOM, arguments: {
                    "id": "im${post.accountId}@$imDomain",
                    "quote": post.content
                  });
                } else {
                  Get.toNamed(Routes.MY_SINGLE_POST, arguments: {
                    'postId': id,
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
                height: _width * 0.5,
                width: _width * 0.4,
                child: Text(postMap[id]!.content,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                    )),
              )),
        );
      }
      if (widget.profileId == null && widget.postTemplateId == null) {
        _myPostsList.insert(0, createPost(context: context));
      } else if (widget.postTemplateId != null) {
        _myPostsList.insert(
            0,
            createPost(
                context: context,
                type: 'toCreate',
                id: widget.postTemplateId,
                backgroundColorIndex: backgroundColorIndex));
      }
      return isLoading
          ? Loading()
          : SizedBox(
              width: double.infinity,
              child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: _myPostsList),
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
          height: _width * 0.5,
          width: _width * 0.4,
          decoration: BoxDecoration(
              color: Color(0xffe4e6ec), borderRadius: BorderRadius.circular(8)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 52,
              color: Colors.black54,
            ),
            SizedBox(height: 10),
            Text("Create_Post",
                style: TextStyle(color: Colors.black54, fontSize: 16))
          ]),
        ));
  }
}
