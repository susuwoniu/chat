import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_single_post_controller.dart';
import '../../home/controllers/home_controller.dart';
import 'post_single_viewer.dart';
import 'package:intl/intl.dart';
import 'single_post_dot.dart';
import '../../home/views/vip_sheet.dart';
import '../../home/views/more_dots.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/common.dart';

final VisibilityMap = {'public': 'Public', 'private': 'Private'};

// todo use getBuilder, for dynamic path
class MySinglePostView extends StatelessWidget {
  final DateFormat formatter = DateFormat('yyyy-MM-dd  HH:mm');

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'SinglePost'.tr,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
        ),
        body: SafeArea(
          child: GetBuilder<MySinglePostController>(
              init: MySinglePostController(),
              tag: Get.arguments['id'],
              builder: (controller) {
                return RefreshIndicator(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  onRefresh: () => Future.sync(
                    () => controller.pagingController.refresh(),
                  ),
                  child: CustomScrollView(slivers: [
                    SliverToBoxAdapter(child: Obx(() {
                      final _post =
                          HomeController.to.postMap[controller.postId];
                      if (_post == null) {
                        return Container(child: Loading());
                      }
                      final authorId = _post.accountId;
                      final isMe = authorId == AuthProvider.to.accountId;

                      final _content = _post.content;
                      final _backgroundColor = _post.backgroundColor;
                      final _frontColor = _post.color;

                      final String _createAt =
                          formatter.format(DateTime.parse(_post.created_at));
                      return Column(children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(12, 20, 12, 10),
                          padding: EdgeInsets.fromLTRB(16, 5, 0, 25),
                          constraints: BoxConstraints(minHeight: _height * 0.4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(_backgroundColor),
                          ),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _createAt,
                                    style: TextStyle(
                                        color: Color(_frontColor),
                                        fontSize: 15),
                                  ),
                                  Row(children: [
                                    isMe
                                        ? Obx(() => Text(
                                              VisibilityMap[
                                                      controller.visibility]!
                                                  .tr,
                                              style: TextStyle(
                                                  color: Color(_frontColor)),
                                            ))
                                        : SizedBox.shrink(),
                                    _dotIcon(
                                        color: Color(_frontColor),
                                        context: context,
                                        postId: controller.postId,
                                        onDeletePost: controller.onDeletePost,
                                        postChange: controller.postChange,
                                        isMe: isMe)
                                  ])
                                ]),
                            Container(
                                padding: EdgeInsets.only(right: 16),
                                alignment: Alignment.centerLeft,
                                child: Text(_content,
                                    style: TextStyle(
                                        color: Color(_frontColor),
                                        fontSize: 19.0,
                                        height: 1.6))),
                          ]),
                        )
                      ]);
                    })),
                    PagedSliverList<String?, String>(
                      pagingController: controller.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<String>(
                          noItemsFoundIndicatorBuilder: (BuildContext context) {
                        return AuthProvider.to.isLogin && controller.isMe
                            ? Empty(message: "no_one_has_seen_this_post...".tr)
                            : SizedBox.shrink();
                      }, itemBuilder: (context, id, index) {
                        final account = controller.viewerIdMap[id];
                        if (account == null) {
                          return SizedBox.shrink();
                        }
                        return PostSingleViewer(
                          name: account.name,
                          img: account.avatar?.thumbnail.url,
                          likeCount: account.like_count,
                          id: id,
                          isLast: index == controller.viewerIdList.length - 1,
                          isVip: account.vip,
                        );
                      }),
                    )
                  ]),
                );
              }),
        ));
  }

  Widget _dotIcon(
      {required BuildContext context,
      required String postId,
      required bool isMe,
      required Color color,
      required Function postChange,
      required Function onDeletePost,
      String? authorId}) {
    final isVip = AuthProvider.to.account.value.vip;
    final is_can_promote = HomeController.to.postMap[postId]!.is_can_promote;

    return IconButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return isMe
                    ? SinglePostDot(
                        postId: postId,
                        onPressedVisibility: (String visibility) async {
                          try {
                            UIUtils.showLoading();
                            await postChange(type: visibility, postId: postId);
                          } catch (e) {
                            UIUtils.showError(e);
                          }
                          UIUtils.hideLoading();
                          Navigator.pop(context);
                        },
                        onPressedPolish: () async {
                          Navigator.pop(context);

                          if (isVip && is_can_promote) {
                            try {
                              UIUtils.showLoading();
                              await postChange(type: 'promote', postId: postId);
                              UIUtils.toast('Successfully_polished.'.tr);
                            } catch (e) {
                              UIUtils.showError(e);
                            }
                            UIUtils.hideLoading();
                          } else {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return VipSheet(context: context, index: 2);
                                });
                          }
                        },
                        onPressedDelete: () async {
                          try {
                            UIUtils.showLoading();
                            await onDeletePost(postId);
                            UIUtils.toast('Successfully_deleted.'.tr);
                            Get.back();
                          } catch (e) {
                            UIUtils.showError(e);
                          }
                          UIUtils.hideLoading();
                          Navigator.pop(context);
                        },
                      )
                    : MoreDots(
                        context: context,
                        onPressedReport: () {
                          Navigator.pop(context);
                          Get.toNamed(Routes.REPORT, arguments: {
                            "related_post_id": postId,
                            "related_account_id": authorId
                          });
                        });
              });
        },
        icon: Icon(
          Icons.more_vert_rounded,
          size: 26,
          color: color,
        ));
  }
}
