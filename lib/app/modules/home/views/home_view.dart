import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/widgets/max_text.dart';
import 'package:chat/config/config.dart';
import 'package:chat/common.dart';
import 'filter_bottom_sheet.dart';
import 'chat_box.dart';
import 'tag_widget.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final imDomain = AppConfig().config.imDomain;

    final appBar = AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              size: 36,
              color: Colors.white,
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return FilterBottomSheet(
                      context: context,
                      onSubmitted: controller.onSubmittedFilter,
                      initialStartAge: controller.postsFilter.value.startAge,
                      initialEndAge: controller.postsFilter.value.endAge,
                      initialGender: controller.postsFilter.value.gender,
                    );
                  });
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
                  icon: Icon(Icons.border_color_rounded,
                      color: Colors.white, size: 28),
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
        body: Obx(() {
          final isLogin = AuthProvider.to.isLogin;
          final account = AuthProvider.to.account.value;
          final postIndexes = controller.postIndexes;
          final postMap = controller.postMap;
          var isLoading = controller.isLoadingHomePosts.value;
          final isEmpty = controller.isDataEmpty.value;
          final isReachEnd = controller.isReachHomePostsEnd.value;
          final isInit = controller.isHomeInitial.value;
          final isInitError = controller.homeInitError.value;
          return TikTokStyleFullPageScroller(
            contentSize: postIndexes.length + 1,
            swipePositionThreshold: 0.2,
            swipeVelocityThreshold: 2000,
            animationDuration: const Duration(milliseconds: 300),
            onScrollEvent: _handleCallbackEvent,
            builder: (BuildContext context, int index) {
              return Container(
                  color: index < postIndexes.length
                      ? Color(postMap[postIndexes[index]]!.backgroundColor)
                      : Colors.orangeAccent,
                  child: SafeArea(child: Builder(builder: (context) {
                    if (!isInit || (index == postIndexes.length && isLoading)) {
                      return Center(child: Loading());
                    } else if (index == postIndexes.length && isEmpty) {
                      return Center(
                          child: Retry(
                              message: "当前没有更多帖子啦～",
                              onRetry: () async {
                                isLoading = true;
                                try {
                                  await controller.getHomePosts();
                                  isLoading = false;
                                } catch (e) {
                                  isLoading = false;
                                  UIUtils.showError(e);
                                }
                              }));
                    } else if (index == postIndexes.length && isReachEnd) {
                      return Center(
                          child: Retry(
                              message: "没有更多帖子了～",
                              onRetry: () async {
                                isLoading = true;
                                try {
                                  await controller.getHomePosts(
                                      before: controller.homePostsFirstCursor);
                                  isLoading = false;
                                } catch (e) {
                                  isLoading = false;
                                  UIUtils.showError(e);
                                }
                              }));
                    } else if (postIndexes.isNotEmpty &&
                        index < postIndexes.length &&
                        postMap[postIndexes[index]] != null) {
                      return Builder(builder: (BuildContext context) {
                        final post = postMap[postIndexes[index]]!;
                        final author =
                            AuthProvider.to.simpleAccountMap[post.accountId]!;
                        return Stack(children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(
                                  left: 16, top: 16, bottom: 60),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: MaxText(post.content, context,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              height: 1.6,
                                              fontSize: 30.0,
                                              fontWeight: FontWeight.bold,
                                            ))),
                                    Row(children: [
                                      Avatar(
                                          size: 26,
                                          name: author.name,
                                          uri: author.avatar,
                                          onTap: () {
                                            if (AccountStoreProvider.to.getString(
                                                    STORAGE_ACCOUNT_ID_KEY) ==
                                                post.accountId) {
                                              RouterProvider.to.toMe();
                                            } else {
                                              Get.toNamed(Routes.OTHER,
                                                  arguments: {
                                                    "accountId": post.accountId
                                                  });
                                            }
                                          }),
                                      SizedBox(width: 15),
                                      Text(
                                        author.name,
                                        key: Key('$index-text'),
                                        style: const TextStyle(
                                            fontSize: 24, color: Colors.white),
                                      ),
                                    ]),
                                  ])),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Expanded(
                                            child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 16, right: 16),
                                                child: ChatBox(
                                                    account: account,
                                                    isLogin: isLogin,
                                                    postId: postIndexes[index],
                                                    onPressed: () {
                                                      final post = postMap[
                                                          postIndexes[index]];
                                                      if (post != null) {
                                                        Get.toNamed(Routes.ROOM,
                                                            arguments: {
                                                              "id":
                                                                  "im${post.accountId}@$imDomain",
                                                              "post_id":
                                                                  postIndexes[
                                                                      index]
                                                            });
                                                      }
                                                    }))),
                                        IconButton(
                                            icon: Icon(Icons.more_horiz,
                                                color: Colors.white, size: 28),
                                            onPressed: () {})
                                      ]),
                                      Container(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: TagWidget(
                                            text:
                                                "来自问题：${post.post_template_title}",
                                            onPressed: () {
                                              Get.toNamed(Routes.POST_SQUARE,
                                                  arguments: {
                                                    "id": post.post_template_id,
                                                    "title":
                                                        post.post_template_title
                                                  });
                                            },
                                          )),
                                    ]),
                              ))
                        ]);
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
