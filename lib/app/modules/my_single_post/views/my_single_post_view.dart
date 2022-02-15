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
import '../../home/views/chat_box.dart';
import 'package:chat/app/common/quote_with_link.dart';
import '../../home/views/tag_widget.dart';

// todo use getBuilder, for dynamic path
class MySinglePostView extends StatelessWidget {
  final DateFormat formatter = DateFormat('yyyy-MM-dd  HH:mm');
  final imDomain = AppConfig().config.imDomain;
  final postId = Get.arguments['id'];

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final isLogin = AuthProvider.to.isLogin;
    final account = AuthProvider.to.account.value;
    final _post = HomeController.to.postMap[postId];
    final authorId = _post!.accountId;

    final author = AuthProvider.to.simpleAccountMap[authorId]?.name;

    final isMe = authorId == AuthProvider.to.accountId;

    final _content = _post.content;
    final _backgroundColor = _post.backgroundColor;
    final _frontColor = _post.color;
    // final String _createAt =
    //     formatter.format(DateTime.parse(_post.created_at));

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: GetBuilder<MySinglePostController>(
              init: MySinglePostController(),
              tag: postId,
              builder: (controller) {
                return RefreshIndicator(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  onRefresh: () => Future.sync(
                    () => controller.pagingController.refresh(),
                  ),
                  child: CustomScrollView(slivers: [
                    SliverToBoxAdapter(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(13, 20, 13, 10),
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 13),
                            constraints:
                                BoxConstraints(minHeight: _height * 0.4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(_backgroundColor),
                            ),
                            child: Stack(children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                              padding: EdgeInsets.all(0),
                                              onPressed: () {
                                                Get.back();
                                              },
                                              icon: Icon(
                                                Icons.arrow_back_outlined,
                                                size: 26,
                                                color: Color(_frontColor),
                                              )),
                                          // Text(
                                          //   _createAt,
                                          //   style: TextStyle(
                                          //       color: Color(_frontColor),
                                          //       fontSize: 15),
                                          // ),
                                          Obx(() => Row(children: [
                                                _dotIcon(
                                                    visibility:
                                                        controller.visibility,
                                                    color: Color(_frontColor),
                                                    context: context,
                                                    postId: controller.postId,
                                                    onDeletePost:
                                                        controller.onDeletePost,
                                                    postChange:
                                                        controller.postChange,
                                                    isMe: isMe)
                                              ]))
                                        ]),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        alignment: Alignment.centerLeft,
                                        child: Text(_content,
                                            style: TextStyle(
                                                color: Color(_frontColor),
                                                fontSize: 18.0,
                                                height: 1.6))),
                                    Container(
                                        margin: EdgeInsets.only(
                                            bottom: isMe ? 26 : 66,
                                            left: 16,
                                            right: 16),
                                        child: TagWidget(
                                            color: Color(_post.color),
                                            text: _post.post_template_title,
                                            onPressed: () {
                                              Get.toNamed(Routes.POST_SQUARE,
                                                  arguments: {
                                                    "id":
                                                        _post.post_template_id,
                                                    "title": _post
                                                        .post_template_title
                                                  });
                                            })),
                                  ]),
                              isMe
                                  ? Positioned(
                                      bottom: 0,
                                      left: 16,
                                      child: Row(children: [
                                        Icon(
                                          Icons.pets_outlined,
                                          size: 22,
                                          color: Color(_frontColor),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          _post.viewed_count.toString(),
                                          style: TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.w500,
                                              color: Color(_frontColor)),
                                        )
                                      ]))
                                  : Positioned(
                                      bottom: 5,
                                      right: 16,
                                      left: 16,
                                      child: ChatBox(
                                          postAuthorName: author ?? '--',
                                          account: account,
                                          isLogin: isLogin,
                                          postId: postId,
                                          onPressed: () {
                                            Get.toNamed(Routes.ROOM,
                                                arguments: {
                                                  "id":
                                                      "${_post.accountId}@$imDomain",
                                                  "quote_background_color":
                                                      _post.backgroundColor,
                                                  "reduce": "false",
                                                  "quote": quoteWithLink(
                                                      _content, postId)
                                                });
                                          }),
                                    ),
                            ]))),
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
      required String visibility,
      String? authorId}) {
    final isVip = AuthProvider.to.account.value.vip;
    final is_can_promote = HomeController.to.postMap[postId]!.is_can_promote;

    return IconButton(
        padding: EdgeInsets.all(0),
        splashColor: Colors.transparent,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return isMe
                    ? SinglePostDot(
                        postId: postId,
                        visibility: visibility,
                        onPressedVisibility: (String visibility) async {
                          try {
                            UIUtils.showLoading();
                            await postChange(type: visibility, postId: postId);
                            UIUtils.toast('Successfully.'.tr);
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
          size: 27,
          color: color,
        ));
  }
}
