import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_single_post_controller.dart';
import '../../home/controllers/home_controller.dart';
import 'viewers_list.dart';
import 'package:intl/intl.dart';
import 'single_post_dot.dart';
import '../../home/views/vip_sheet.dart';
import 'package:flutter/services.dart';
import '../../home/views/more_dots.dart';
import 'package:chat/app/routes/app_pages.dart';

final VisibilityMap = {'public': 'Public', 'private': 'Private'};

class MySinglePostView extends GetView<MySinglePostController> {
  final _postId = (Get.arguments['id']);
  final DateFormat formatter = DateFormat('yyyy-MM-dd  HH:mm');

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _homeController = HomeController.to;

    final _post = HomeController.to.postMap[_postId]!;
    final authorId = _post.accountId;
    final isMe = authorId == AuthProvider.to.accountId;

    final _content = _post.content;
    final _backgroundColor = _post.backgroundColor;

    final String _createAt = formatter.format(DateTime.parse(_post.created_at));

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'SinglePost'.tr,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
          ),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
        ),
        body: SafeArea(
          child: ListView(children: [
            Container(
                margin: EdgeInsets.fromLTRB(12, 20, 12, 20),
                padding: EdgeInsets.fromLTRB(16, 5, 0, 25),
                constraints: BoxConstraints(minHeight: _height * 0.4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(_backgroundColor),
                ),
                width: _width * 0.9,
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _createAt,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 15),
                        ),
                        Row(children: [
                          isMe
                              ? Obx(() => Text(
                                    VisibilityMap[controller.visibility]!.tr,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ))
                              : SizedBox.shrink(),
                          _dotIcon(
                              context: context, postId: _postId, isMe: isMe)
                        ])
                      ]),
                  Container(
                      padding: EdgeInsets.only(right: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(_content,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 19.0,
                              height: 1.6))),
                ])),
            Obx(() {
              final post = _homeController.postMap[_postId]!;

              final isLoading = post.isLoadingViewersList;

              final List<Widget> list = post.views != null
                  ? post.views!.isNotEmpty
                      ? post.views!.map((e) {
                          final account = AuthProvider.to.simpleAccountMap[e];
                          return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: _width * 0.04),
                              child: ViewersList(
                                  name: account!.name,
                                  img: account.avatar,
                                  likeCount: account.like_count,
                                  viewerId: e));
                        }).toList()
                      : [
                          Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "no_one_has_seen...".tr,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                  Icon(
                                    Icons.lunch_dining_rounded,
                                    color: Colors.yellow.shade700,
                                    size: 22,
                                  )
                                ]),
                          )
                        ]
                  : [];

              final Widget loadingWidget =
                  isLoading ? Container(child: Text("loading")) : Container();

              list.add(loadingWidget);

              return Column(children: list);
            }),
          ]),
        ));
  }

  Widget _dotIcon(
      {required BuildContext context,
      required String postId,
      required bool isMe,
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
                            await controller.postChange(
                                type: visibility, postId: postId);
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
                              await controller.postChange(
                                  type: 'promote', postId: postId);
                              UIUtils.toast('Successfully_polished'.tr);
                            } catch (e) {
                              UIUtils.showError(e);
                            }
                            UIUtils.hideLoading();
                          } else {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                enableDrag: false,
                                builder: (context) {
                                  return VipSheet(context: context, index: 2);
                                });
                          }
                        },
                        onPressedDelete: () async {
                          try {
                            UIUtils.showLoading();
                            await controller.onDeletePost(postId);
                            UIUtils.toast('Successfully_deleted'.tr);
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
          color: Theme.of(context).colorScheme.onPrimary,
        ));
  }
}
