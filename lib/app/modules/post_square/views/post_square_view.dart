import 'package:flutter/material.dart';
import 'package:chat/utils/random.dart';
import 'package:get/get.dart';
import '../controllers/post_square_controller.dart';
import 'package:chat/common.dart';
import '../../me/views/small_post.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: backgroundColor,
      // ),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: RefreshIndicator(
            onRefresh: () {
              return _pullRefresh(_id);
            },
            child: Column(children: [
              Stack(
                alignment: AlignmentDirectional.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    alignment: Alignment.center,

                    height: _height * 0.25,
                    width: _width,
                    color: backgroundColor,
                    // padding: EdgeInsets.symmetric(
                    //     horizontal: _width * 0.06, vertical: 10),
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
                              color: Colors.white, shape: BoxShape.circle),
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
                final usedCount = controller.usedCount.value;
                return Text(
                    usedCount > 1
                        ? usedCount.toString() + ' Posts'.tr
                        : usedCount.toString() + ' Post'.tr,
                    style: TextStyle(fontSize: 17.0, color: Colors.black54));
              }),
              SizedBox(height: 5),
            ]),
          ),
        ),
        // MyPosts(postTemplateId: _id.toString()),
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
                  content: post.content,
                  backgroundColor: post.backgroundColor);
            })),
      ]),
    );
  }
}

Future<void> _pullRefresh(id) async {
  try {
    await PostSquareController.to
        .getTemplatesSquareData(postTemplateId: id.toString());
  } catch (e) {
    UIUtils.showError(e);
  }
}
