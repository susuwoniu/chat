import 'package:chat/app/modules/home/views/social_share.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:get/get.dart';
import '../controllers/post_square_controller.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/widgets/max_text.dart';
import 'package:chat/common.dart';
import 'package:chat/app/modules/home/views/chat_box.dart';
import 'package:chat/app/modules/home/views/tag_widget.dart';
import 'package:chat/app/modules/home/views/author_name.dart';
import 'package:chat/app/modules/home/views/action_buttons.dart';
import 'package:chat/app/modules/home/views/more_dots.dart';

class PostSquareCardView extends GetView<PostSquareController> {
  @override
  Widget build(BuildContext context) {
    final imDomain = AppConfig().config.imDomain;
    final appBar = AppBar(
        backgroundColor: Colors.transparent,
        title: Text("CardView"),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: 36),
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

          var isLoading = controller.isLoadingPosts;
          final isEmpty = false;
          final isReachEnd = controller.isReachHomePostsEnd;
          final isInit = controller.isInitial;
          final isInitError = controller.homeInitError;

          return TikTokStyleFullPageScroller(
            contentSize: postIndexes.length + 1,
            cardIndex: controller.currentIndex,
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
                                controller.refreshHomePosts();
                              }));
                    } else if (index == postIndexes.length && isReachEnd) {
                      return Center(
                          child: Retry(
                              message: "没有更多帖子了～",
                              onRetry: () async {
                                controller.refreshHomePosts();
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
                                  left: 16, right: 16, top: 16, bottom: 60),
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
                                    SizedBox(height: 15),
                                    AuthorName(
                                        accountId: post.accountId,
                                        authorName: author.name,
                                        avatarUri: author.avatar,
                                        index: index),
                                    SizedBox(height: 30),
                                  ])),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 20, left: 16, right: 8),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                                child: ChatBox(
                                                    postAuthorName: author.name,
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
                                                              "quote_background_color":
                                                                  post.backgroundColor,
                                                              "quote":
                                                                  post.content
                                                            });
                                                      }
                                                    })),
                                            SizedBox(width: 8),
                                            ActionButtons(
                                                onAdd: () {
                                                  Get.toNamed(Routes.POST);
                                                },
                                                onRefresh: () {
                                                  controller.refreshHomePosts();
                                                },
                                                isRefreshing:
                                                    controller.isLoadingPosts,
                                                onMore: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return MoreDots(
                                                            context: context,
                                                            onPressedShare: () {
                                                              Navigator.pop(
                                                                  context);
                                                              showModalBottomSheet(
                                                                  context:
                                                                      context,
                                                                  isScrollControlled:
                                                                      true,
                                                                  builder:
                                                                      (context) {
                                                                    return SocialShare();
                                                                  });
                                                            },
                                                            onPressedReport:
                                                                () {
                                                              Navigator.pop(
                                                                  context);
                                                              Get.toNamed(
                                                                  Routes.REPORT,
                                                                  arguments: {
                                                                    "related_post_id":
                                                                        postIndexes[
                                                                            index],
                                                                    "related_account_id":
                                                                        post.accountId
                                                                  });
                                                            });
                                                      });
                                                })
                                          ]),
                                    ]),
                              )),
                        ]);
                      });
                    } else if (isInitError.isNotEmpty) {
                      return Retry(
                          message: isInitError,
                          onRetry: () async {
                            controller.refreshHomePosts();
                          });
                    } else {
                      return Container(
                          padding: EdgeInsets.all(16), child: Text("未知错误"));
                    }
                  })));
            },
          );
        }));
  }

  void _handleCallbackEvent(ScrollEventType type, {int? currentIndex}) {
    if (currentIndex != null && currentIndex >= 0) {
      controller.setIndex(index: currentIndex);
    }
    print(
        "Scroll callback received with data: {type: $type, and index: ${currentIndex ?? 'not given'}}");
  }
}
