import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/widgets/max_text.dart';
import 'package:chat/common.dart';
import 'filter_bottom_sheet.dart';
import 'chat_box.dart';
import 'tag_widget.dart';
import 'author_name.dart';
import './action_buttons.dart';
import 'more_dots.dart';
import 'nearby_switch.dart';
import 'vip_sheet.dart';
import 'package:chat/app/common/quote_with_link.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final imDomain = AppConfig().config.imDomain;
    final isCreate = AuthProvider.to.account.value.next_post_not_before == null
        ? true
        : DateTime.now().isAfter(
            DateTime.parse(AuthProvider.to.account.value.next_post_not_before));
    final appBar = AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
            padding: EdgeInsets.only(left: 4),
            child: IconButton(
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
                          initialStartAge:
                              controller.postsFilter.value.startAge,
                          initialEndAge: controller.postsFilter.value.endAge,
                          initialGender: controller.postsFilter.value.gender,
                          initialEndDistance:
                              controller.postsFilter.value.endDistance,
                          isNearby:
                              controller.currentPage == 'nearby' ? true : false,
                        );
                      });
                })),
        title: NearbySwitch(onPressedTabSwitch: controller.onPressedTabSwitch),
        actions: <Widget>[
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                    icon: Text("🔑",
                        style: Theme.of(context).textTheme.headline6),
                    onPressed: () {
                      Get.toNamed(
                        Routes.DEBUG,
                      );
                    }),
                // IconButton(
                //     icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary, size: 36),
                //     onPressed: () {
                //       if (isCreate) {
                //         Get.toNamed(
                //           Routes.POST,
                //         );
                //       } else {
                //         showModalBottomSheet(
                //             context: context,
                //             isScrollControlled: true,
                //             enableDrag: false,
                //             builder: (context) {
                //               return VipSheet(context: context, index: 4);
                //             });
                //       }
                //     })
              ),
            ],
          )
        ]);

    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: appBar,
        body: Obx(() {
          final currentPage = controller.currentPage;
          final currentPageState = controller.pageState[currentPage]!;
          final isLogin = AuthProvider.to.isLogin;
          final account = AuthProvider.to.account.value;

          final postIndexes = currentPageState.postIndexes;

          final postMap = controller.postMap;

          var isLoading = controller.isLoadingHomePosts.value;
          final isEmpty = currentPageState.isDataEmpty;
          final isReachEnd = currentPageState.isReachHomePostsEnd;
          final isInit = currentPageState.isHomeInitial;
          final isInitError = currentPageState.homeInitError;

          return TikTokStyleFullPageScroller(
            contentSize: postIndexes.length + 1,
            cardIndex: currentPageState.currentIndex,
            swipePositionThreshold: 0.2,
            swipeVelocityThreshold: 2000,
            animationDuration: const Duration(milliseconds: 300),
            onScrollEvent: _handleCallbackEvent,
            builder: (BuildContext context, int index) {
              return Container(
                  color: index < postIndexes.length
                      ? Color(postMap[postIndexes[index]]!.backgroundColor)
                      : BACKGROUND_COLORS[0],
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
                              padding: EdgeInsets.fromLTRB(16, 5, 16, 90),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: MaxText(post.content, context,
                                            textAlign: TextAlign.center,
                                            id: postIndexes[index],
                                            style: TextStyle(
                                              fontSize: 26.0,
                                              color: Color(post.color),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    SizedBox(height: 4),
                                    TagWidget(
                                        color:
                                            Color(controller.currentFrontColor),
                                        text: post.post_template_title,
                                        onPressed: () {
                                          Get.toNamed(Routes.POST_SQUARE,
                                              arguments: {
                                                "id": post.post_template_id,
                                                "title":
                                                    post.post_template_title
                                              });
                                        }),
                                    SizedBox(height: 4),
                                    AuthorName(
                                        color:
                                            Color(controller.currentFrontColor),
                                        accountId: post.accountId,
                                        authorName: author.name,
                                        avatarUri: author.avatar,
                                        nameSize: 18,
                                        index: index),
                                    SizedBox(
                                      height: 30,
                                    )
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
                                                  if (isCreate) {
                                                    Get.toNamed(
                                                      Routes.POST,
                                                    );
                                                  } else {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        enableDrag: false,
                                                        builder: (context) {
                                                          return VipSheet(
                                                              context: context,
                                                              index: 4);
                                                        });
                                                  }
                                                },
                                                onRefresh: () {
                                                  controller.refreshHomePosts();
                                                },
                                                isRefreshing: controller
                                                    .isLoadingHomePosts.value,
                                                onMore: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return MoreDots(
                                                            context: context,
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
