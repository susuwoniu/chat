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
import 'package:chat/common.dart';
import 'package:chat/app/common/get_time_stop.dart';

class PostSquareView extends GetView<PostSquareController> {
  final _title = Get.arguments['title'];
  final _id = int.parse(Get.arguments['id']);
  final backgroundColorIndex = get_random_index(BACKGROUND_COLORS.length);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final backgroundColor = BACKGROUND_COLORS[backgroundColorIndex];
    final frontColor = FRONT_COLORS[backgroundColorIndex];

    final postMap = controller.postMap;
    final height = AppBar().preferredSize.height;
    final safePadding = MediaQuery.of(context).padding.top;

    return RefreshIndicator(
        color: backgroundColor,
        backgroundColor: Colors.white,
        onRefresh: () => Future.sync(
              () => controller.pagingController.refresh(),
            ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(alignment: AlignmentDirectional.topCenter, children: [
            CustomScrollView(slivers: [
              SliverAppBar(
                systemOverlayStyle:
                    SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
                iconTheme: IconThemeData(color: frontColor),
                stretch: true,
                pinned: true,
                backgroundColor: backgroundColor,
                actions: [
                  Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: IconButton(
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.share_rounded, color: frontColor),
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
                expandedHeight: (safePadding + height) * 2,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                      padding: EdgeInsets.fromLTRB(
                          25, safePadding + height + 10, 25, 0),
                      width: _width,
                      child: Column(children: [
                        Text('# ' + _title,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                color: frontColor)),
                        SizedBox(height: 20),
                        Obx(() {
                          final usedCount = controller.usedCount;
                          return Text(
                              usedCount > 1
                                  ? usedCount > 9999
                                      ? '9999+' + ' Posts'.tr
                                      : usedCount.toString() + ' Posts'.tr
                                  : usedCount.toString() + ' Post'.tr,
                              style:
                                  TextStyle(fontSize: 16.0, color: frontColor));
                        }),
                      ])),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 15)),
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
                      noItemsFoundIndicatorBuilder: (BuildContext context) {
                    return Empty();
                  }, itemBuilder: (context, id, index) {
                    final post = postMap[id]!;
                    final author =
                        AuthProvider.to.simpleAccountMap[post.accountId]!;
                    return SmallPost(
                        postId: id,
                        type: 'square',
                        name: author.name,
                        uri: author.avatar?.thumbnail.url,
                        index: index,
                        onTap: () {
                          controller.setIndex(index: index);
                          Get.toNamed(Routes.POST_SQUARE_CARD_VIEW,
                              arguments: {'color': post.color});
                        },
                        post: post);
                  })),
            ]),
            Positioned(
                bottom: 35,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: ChatThemeData.baseBlack),
                  child: GestureDetector(
                      onTap: () {
                        if (getTimeStop() > 0) {
                          UIUtils.showError("It's_not_time_to_post_yet".tr);
                        } else {
                          Get.toNamed(Routes.CREATE, arguments: {
                            "id": _id.toString(),
                            "background-color-index": backgroundColorIndex,
                          });
                        }
                      },
                      child: Row(children: [
                        Avatar(
                            name: AuthProvider.to.account.value.name,
                            uri: AuthProvider
                                .to.account.value.avatar?.thumbnail.url,
                            size: 16),
                        SizedBox(width: 8),
                        Text('Join_topic'.tr,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 15,
                            )),
                      ])),
                )),
          ]),
        ));
  }
}
