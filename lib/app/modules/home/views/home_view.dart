import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/widgets/max_text.dart';
import 'package:chat/config/config.dart';
import 'package:chat/common.dart';
import 'tag_widget.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final imDomain = AppConfig().config.imDomain;
    final appBar = AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Text("✨", style: Theme.of(context).textTheme.headline6),
            onPressed: () {
              Get.toNamed(Routes.SETTING);
            }),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                  icon:
                      Text("🐱", style: Theme.of(context).textTheme.headline6),
                  onPressed: () {
                    Get.toNamed(
                      Routes.ADD_PROFILE_IMAGE,
                    );
                  }),
              IconButton(
                  icon:
                      Text("🔑", style: Theme.of(context).textTheme.headline6),
                  onPressed: () {
                    Get.toNamed(
                      Routes.DEBUG,
                    );
                  }),
              IconButton(
                  icon:
                      Text("✍️", style: Theme.of(context).textTheme.headline6),
                  onPressed: () {
                    Get.toNamed(
                      Routes.POST,
                    );
                  }),
            ],
          )
        ]);

    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: appBar,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: Align(
          alignment: Alignment(0.9, 0.51),
          child: Text("💭", style: TextStyle(fontSize: 50)),
        ),
        body: Obx(() {
          final isLogin = AuthProvider.to.isLogin;
          final account = AuthProvider.to.account.value;
          final isLoading = controller.isLoadingHomePosts.value;
          final isEmpty = controller.isDataEmpty.value;
          final isReachEnd = controller.isReachHomePostsEnd.value;
          final isInit = controller.isHomeInitial.value;
          final isInitError = controller.homeInitError.value;
          return TikTokStyleFullPageScroller(
            contentSize: controller.postIndexes.length + 1,
            swipePositionThreshold: 0.2,
            swipeVelocityThreshold: 2000,
            animationDuration: const Duration(milliseconds: 300),
            onScrollEvent: _handleCallbackEvent,
            builder: (BuildContext context, int index) {
              return Container(
                  color: index < controller.postIndexes.length
                      ? HexColor(controller
                          .postMap[controller.postIndexes[index]]!
                          .backgroundColor)
                      : Colors.orangeAccent,
                  alignment: Alignment.topLeft,
                  child: SafeArea(child: Builder(builder: (context) {
                    if (!isInit ||
                        (index == controller.postIndexes.length && isLoading)) {
                      return Center(child: Loading());
                    } else if (index == controller.postIndexes.length &&
                        isEmpty) {
                      return Center(
                          child: Retry(
                              message: "当前没有更多帖子啦～",
                              onRetry: () async {
                                controller.isLoadingHomePosts.value = true;
                                try {
                                  await controller.getHomePosts();
                                  controller.isLoadingHomePosts.value = false;
                                } catch (e) {
                                  controller.isLoadingHomePosts.value = false;
                                  UIUtils.showError(e);
                                }
                              }));
                    } else if (index == controller.postIndexes.length &&
                        isReachEnd) {
                      return Center(
                          child: Retry(
                              message: "没有更多帖子了～",
                              onRetry: () async {
                                controller.isLoadingHomePosts.value = true;
                                try {
                                  await controller.getHomePosts(
                                      before: controller.homePostsFirstCursor);
                                  controller.isLoadingHomePosts.value = false;
                                } catch (e) {
                                  controller.isLoadingHomePosts.value = false;
                                  UIUtils.showError(e);
                                }
                              }));
                    } else if (controller.postIndexes.isNotEmpty &&
                        index < controller.postIndexes.length &&
                        controller.postMap[controller.postIndexes[index]] !=
                            null) {
                      return Builder(builder: (BuildContext context) {
                        final post =
                            controller.postMap[controller.postIndexes[index]]!;
                        final author =
                            AuthProvider.to.simpleAccountMap[post.accountId]!;
                        return Stack(
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TagWidget(
                                      text: '今天下班后的计划是：',
                                      onPressed: () {
                                        Get.toNamed(Routes.POST_SQUARE,
                                            arguments: {
                                              "id": post.post_template_id,
                                              "content": post.content,
                                              "color": post.backgroundColor
                                            });
                                      },
                                    ),
                                    MaxText(
                                      post.content,
                                      context,
                                      // textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        height: 1.6,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 120),
                                      child: Row(children: [
                                        Avatar(
                                            size: 26,
                                            name: author.name,
                                            uri: author.avatar),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0)),
                                        Text(
                                          author.name,
                                          key: Key('$index-text'),
                                          style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.white),
                                        ),
                                      ]),
                                    ),
                                  ]),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: GestureDetector(
                                      onTap: () {
                                        final post = controller.postMap[
                                            controller.postIndexes[index]];
                                        if (post != null) {
                                          Get.toNamed(Routes.ROOM, arguments: {
                                            "id":
                                                "im${post.accountId}@$imDomain",
                                            "post_id":
                                                controller.postIndexes[index]
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 60,
                                        width: screenWidth * 0.88,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.white,
                                        ),
                                        child: Row(children: [
                                          TextButton(
                                              onPressed: () async {},
                                              child: isLogin
                                                  ? Avatar(
                                                      size: 20,
                                                      uri: account.avatar,
                                                      name: account.name)
                                                  : Text("🤠",
                                                      style: const TextStyle(
                                                          fontSize: 32,
                                                          color:
                                                              Colors.white))),
                                        ]),
                                      ),
                                    )))
                          ],
                        );
                      });
                    } else if (isInitError != null) {
                      return Text(isInitError);
                    } else {
                      return Text("error");
                    }
                  })));
            },
          );
        }));
  }

  void _handleCallbackEvent(ScrollEventType type, {int? currentIndex}) {
    if (currentIndex != null && currentIndex > 0) {
      controller.setIndex(currentIndex);
    }
    print(
        "Scroll callback received with data: {type: $type, and index: ${currentIndex ?? 'not given'}}");
  }
}
