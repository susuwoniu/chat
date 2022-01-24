import 'package:flutter/material.dart';
import 'package:chat/utils/random.dart';
import 'package:get/get.dart';
import '../controllers/post_square_controller.dart';
import 'package:chat/common.dart';
import '../../me/views/small_post.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../me/views/circle_widget.dart';
import 'package:chat/app/routes/app_pages.dart';

class PostSquareView extends GetView<PostSquareController> {
  final _title = Get.arguments['title'];
  final _id = int.parse(Get.arguments['id']);
  final backgroundColorIndex = get_random_index(BACKGROUND_COLORS.length);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final backgroundColor = BACKGROUND_COLORS[backgroundColorIndex];
    final postMap = controller.postMap;

    return RefreshIndicator(
        onRefresh: () => Future.sync(
              () => controller.pagingController.refresh(),
            ),
        child: Scaffold(
          body: Stack(alignment: AlignmentDirectional.topCenter, children: [
            CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () {},
                  ),
                  child: Column(children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                          height: _height * 0.35,
                          width: _width,
                          color: backgroundColor,
                          child: Text(_title,
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                        Positioned(
                            bottom: -_width * 0.1,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                height: _width * 0.16,
                                width: _width * 0.16,
                                child: Icon(
                                  Icons.face_outlined,
                                  size: _width * 0.1.toDouble(),
                                  color: Colors.black54,
                                ))),
                      ],
                    ),
                    SizedBox(height: _height * 0.06),
                    Obx(() {
                      final usedCount = controller.usedCount;
                      return Text(
                          usedCount > 1
                              ? usedCount.toString() + ' Posts'.tr
                              : usedCount.toString() + ' Post'.tr,
                          style:
                              TextStyle(fontSize: 17.0, color: Colors.black54));
                    }),
                    SizedBox(height: 5),
                  ]),
                ),
              ),
              PagedSliverGrid<String?, String>(
                  showNewPageProgressIndicatorAsGridChild: false,
                  showNewPageErrorIndicatorAsGridChild: false,
                  showNoMoreItemsIndicatorAsGridChild: false,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.75,
                    crossAxisCount: 2,
                  ),
                  pagingController: controller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<String>(
                      itemBuilder: (context, id, index) {
                    final post = postMap[id]!;
                    return SmallPost(
                        postId: id,
                        onTap: () {
                          controller.setIndex(index: index);
                          Get.toNamed(
                            Routes.POST_SQUARE_CARD_VIEW,
                          );
                        },
                        content: post.content,
                        backgroundColor: post.backgroundColor);
                  })),
            ]),
            Positioned(
                left: 20,
                top: 50,
                child: CircleWidget(
                  icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                )),
            Positioned(
                bottom: 30,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black),
                  child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.CREATE, arguments: {
                          "id": _id.toString(),
                        });
                      },
                      child: Row(children: [
                        Icon(Icons.tag_rounded, color: Colors.white, size: 20),
                        Text('Join_topic'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            )),
                      ])),
                )),
          ]),
        ));
  }
}
