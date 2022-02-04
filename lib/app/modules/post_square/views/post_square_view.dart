import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/utils/random.dart';
import 'package:get/get.dart';
import '../controllers/post_square_controller.dart';
import 'package:chat/common.dart';
import '../../me/views/small_post.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter/services.dart';

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
    final height = AppBar().preferredSize.height;
    final safePadding = MediaQuery.of(context).padding.top;

    return RefreshIndicator(
        color: backgroundColor,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        onRefresh: () => Future.sync(
              () => controller.pagingController.refresh(),
            ),
        child: Scaffold(
          body: Stack(alignment: AlignmentDirectional.topCenter, children: [
            CustomScrollView(slivers: [
              SliverAppBar(
                systemOverlayStyle:
                    SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
                iconTheme: IconThemeData(
                    color: Theme.of(context).colorScheme.onPrimary),
                stretch: true,
                pinned: true,
                backgroundColor: backgroundColor,
                actions: [
                  Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: IconButton(
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.share_rounded,
                            color: Theme.of(context).colorScheme.onPrimary),
                        onPressed: () async {
                          final FlutterShareMe flutterShareMe =
                              FlutterShareMe();
                          // TODO right share url
                          final response =
                              await flutterShareMe.shareToSystem(msg: "test");
                          print(response);
                        },
                      ))
                ],
                expandedHeight: _height * 0.25,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(
                        20, safePadding + height + 20, 20, 0),
                    width: _width,
                    child: Text('# ' + _title,
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: Obx(() {
                final usedCount = controller.usedCount;
                return Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                        usedCount > 1
                            ? usedCount.toString() + ' Posts'.tr
                            : usedCount.toString() + ' Post'.tr,
                        style:
                            TextStyle(fontSize: 17.0, color: Colors.black54)));
              })),
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
                        Avatar(
                            name: AuthProvider.to.account.value.name,
                            uri: AuthProvider.to.account.value.avatar,
                            size: 16),
                        SizedBox(width: 8),
                        Text('Join_topic'.tr,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16,
                            )),
                      ])),
                )),
          ]),
        ));
  }
}
