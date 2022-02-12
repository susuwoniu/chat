import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../me/views/small_post.dart';
import 'package:flutter/cupertino.dart';
import '../controllers/other_controller.dart';
import '../../home/views/more_dots.dart';
import 'package:chat/app/common/block.dart';
import '../../me/views/me_icon.dart';
import '../../me/views/vip_icon.dart';
import '../../me/views/open_avatar.dart';

class OtherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtherController>(
        init: OtherController(),
        tag: Get.arguments['id'],
        // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
        builder: (controller) {
          final postMap = controller.postMap;
          final accountId = controller.accountId;
          final _account = AuthProvider.to.simpleAccountMap[accountId] ??
              SimpleAccountEntity.empty();
          final name = _account.name;
          final postCount = _account.post_count > 0
              ? _account.post_count > 999
                  ? '999+' + ' Posts'.tr
                  : _account.post_count.toString() + ' Posts'.tr
              : '0' + ' Post'.tr;

          final avatar = _account.avatar;
          return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text(name,
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface)),
                bottom: PreferredSize(
                    child: Container(
                      height: 0.5,
                      color: Theme.of(context).dividerColor,
                    ),
                    preferredSize: Size.fromHeight(0)),
                actions: [
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(Icons.more_vert_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 28),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Obx(() {
                              final _account =
                                  AuthProvider.to.simpleAccountMap[accountId] ??
                                      SimpleAccountEntity.empty();
                              final is_blocked = _account.is_blocked;

                              return MoreDots(
                                  context: context,
                                  bottomIcon: Icons.face_retouching_off_rounded,
                                  bottomText:
                                      is_blocked ? 'Unblock'.tr : 'Block'.tr,
                                  onPressedBlock: () async {
                                    controller.accountAction(
                                        isLiked: false, increase: !is_blocked);
                                    try {
                                      if (is_blocked) {
                                        await toggleBlock(
                                            id: accountId, toBlocked: false);
                                        UIUtils.toast('Unblocked.'.tr);
                                      } else {
                                        await toggleBlock(
                                            id: accountId, toBlocked: true);
                                        UIUtils.toast('Blocked.'.tr);
                                      }
                                    } catch (e) {
                                      UIUtils.showError(e);
                                      controller.accountAction(
                                          isLiked: false, increase: is_blocked);
                                    }
                                  },
                                  onPressedReport: () {
                                    Navigator.pop(context);
                                    Get.toNamed(Routes.REPORT, arguments: {
                                      "related_account_id": accountId
                                    });
                                  });
                            });
                          });
                    },
                  ),
                ],
              ),
              body: RefreshIndicator(
                backgroundColor: Theme.of(context).colorScheme.surface,
                onRefresh: () => Future.sync(
                  () => controller.pagingController.refresh(),
                ),
                child: CustomScrollView(slivers: [
                  SliverToBoxAdapter(
                      child: Column(children: [
                    Column(children: [
                      Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(clipBehavior: Clip.none, children: [
                                Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 1,
                                            color: Theme.of(context)
                                                .dividerColor)),
                                    padding: EdgeInsets.all(10),
                                    child: Avatar(
                                        elevation: 0,
                                        onTap: () {
                                          if (avatar != null) {
                                            showCupertinoModalPopup(
                                                barrierColor: Colors.black87,
                                                context: context,
                                                builder: (context) {
                                                  return OpenAvatar(
                                                      avatar: avatar.url);
                                                });
                                          }
                                        },
                                        name: _account.name,
                                        uri: avatar?.thumbnail.url,
                                        size: 50)),
                                Positioned(
                                  bottom: 5,
                                  right: 8,
                                  child: _account.vip
                                      ? VipIcon(iconSize: 28)
                                      : SizedBox.shrink(),
                                )
                              ])
                            ]),
                      ),
                      Text(_account.name,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface)),
                      _account.bio == null || _account.bio == ''
                          ? SizedBox.shrink()
                          : Container(
                              padding: EdgeInsets.fromLTRB(30, 12, 30, 0),
                              child: Text(_account.bio!,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                      height: 1.5))),
                    ]),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 22, 15, 10),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MeIcon(
                                  icon: Icons.icecream_outlined,
                                  text: postCount),
                              Obx(() {
                                final _account = AuthProvider
                                        .to.simpleAccountMap[accountId] ??
                                    SimpleAccountEntity.empty();
                                final likeCount = _account.like_count > 0
                                    ? _account.like_count > 9999
                                        ? '9999+' + ' Hearts'.tr
                                        : _account.like_count.toString() +
                                            ' Hearts'.tr
                                    : '0' + ' Heart'.tr;
                                return MeIcon(
                                  icon: Icons.favorite_border_outlined,
                                  text: likeCount,
                                  isLiked: _account.is_liked,
                                  onPressedLike: (bool increase) async {
                                    controller.accountAction(
                                        increase: increase);
                                    if (increase) {
                                      try {
                                        await controller
                                            .postLikeCount(accountId);
                                        UIUtils.toast('Liked!'.tr);
                                        final currentAccount = AuthProvider
                                            .to.simpleAccountMap[accountId]!;
                                        currentAccount.like_count += 1;
                                        AuthProvider.to
                                                .simpleAccountMap[accountId] =
                                            currentAccount;
                                      } catch (e) {
                                        UIUtils.showError(e);
                                        controller.accountAction(
                                            increase: false);
                                      }
                                    } else {
                                      try {
                                        await controller
                                            .cancelLikeCount(accountId);
                                        UIUtils.toast(
                                            'Successfully_unliked.'.tr);
                                        final currentAccount = AuthProvider
                                            .to.simpleAccountMap[accountId]!;
                                        currentAccount.like_count -= 1;
                                        AuthProvider.to
                                                .simpleAccountMap[accountId] =
                                            currentAccount;
                                      } catch (e) {
                                        UIUtils.showError(e);
                                        controller.accountAction(
                                            increase: true);
                                      }
                                    }
                                  },
                                );
                              }),
                              MeIcon(
                                  icon: Icons.mail_outlined,
                                  text: 'Chat_now'.tr,
                                  onPressedChat: () {
                                    Get.toNamed(Routes.ROOM, arguments: {
                                      'id': "$accountId@$imDomain",
                                    });
                                  }),
                            ]),
                      ]),
                    ),
                    SizedBox(height: 5),
                  ])),
                  PagedSliverGrid<String?, String>(
                    showNewPageProgressIndicatorAsGridChild: false,
                    showNewPageErrorIndicatorAsGridChild: false,
                    showNoMoreItemsIndicatorAsGridChild: false,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.8,
                      crossAxisCount: 2,
                    ),
                    pagingController: controller.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<String>(
                        itemBuilder: (context, id, index) {
                      final post = postMap[id]!;

                      if (post == null) {
                        return SizedBox.shrink();
                      }
                      return SmallPost(
                          onTap: () {
                            Get.toNamed(Routes.MY_SINGLE_POST,
                                arguments: {"id": id});
                          },
                          postId: id,
                          post: post);
                    }),
                  ),
                  SliverToBoxAdapter(child: Container(height: 100))
                ]),
              ));
        });
  }
}
