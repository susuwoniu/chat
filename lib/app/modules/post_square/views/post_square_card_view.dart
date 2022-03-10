import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:get/get.dart';
import '../controllers/post_square_controller.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/widgets/max_text.dart';
import 'package:chat/common.dart';
import 'package:chat/app/modules/home/views/chat_box.dart';
import 'package:chat/app/modules/home/views/author_name.dart';
import 'package:chat/app/modules/home/views/action_buttons.dart';
import 'package:chat/app/modules/home/views/dot_widget.dart';
import 'package:chat/app/common/quote_with_link.dart';

class PostSquareCardView extends GetView<PostSquareController> {
  @override
  Widget build(BuildContext context) {
    final imDomain = AppConfig().config.imDomain;
    final color = Get.arguments['color'];

    final appBar = AppBar(
        iconTheme: IconThemeData(),
        backgroundColor: Colors.transparent,
        leading: IconButton(
            iconSize: 26,
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Color(color),
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Get.back();
            }),
        actions: <Widget>[
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                      icon: Icon(Icons.add, color: Color(color), size: 36),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Get.toNamed(
                          Routes.POST,
                        );
                      })),
            ],
          )
        ]);

    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                              message: "no_more_now".tr,
                              onRetry: () async {
                                controller.refreshHomePosts();
                              }));
                    } else if (index == postIndexes.length && isReachEnd) {
                      return Center(
                          child: Retry(
                              message: "no_more".tr,
                              onRetry: () async {
                                controller.refreshHomePosts();
                              }));
                    } else if (postIndexes.isNotEmpty &&
                        index < postIndexes.length &&
                        postMap[postIndexes[index]] != null) {
                      return Builder(builder: (BuildContext context) {
                        final post = postMap[postIndexes[index]]!;
                        final author =
                            AuthProvider.to.simpleAccountMap[post.accountId];
                        return Stack(children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.fromLTRB(16, 10, 16, 90),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: MaxText(post.content, context,
                                            textAlign: TextAlign.center,
                                            id: postIndexes[index],
                                            style: TextStyle(
                                              color: Color(post.color),
                                              fontSize: 20.0,
                                              height: 1.6,
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    SizedBox(height: 15),
                                    AuthorName(
                                        color: Color(post.color),
                                        accountId: post.accountId,
                                        authorName: author?.name ?? "--",
                                        nameSize: 18,
                                        avatarUri:
                                            author?.avatar?.thumbnail.url,
                                        index: index),
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
                                                    postAuthorName:
                                                        author?.name ?? "--",
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
                                                                  "${post.accountId}@$imDomain",
                                                              "quote_background_color":
                                                                  post.backgroundColor,
                                                              "reduce": "false",
                                                              "quote": quoteWithLink(
                                                                  post.content,
                                                                  postIndexes[
                                                                      index])
                                                            });
                                                      }
                                                    })),
                                            SizedBox(width: 8),
                                            ActionButtons(
                                                color: Color(post.color),
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
                                                        return DotWidget(
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
                                                            },
                                                            postId: postIndexes[
                                                                index]);
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
