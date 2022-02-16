import 'package:chat/app/modules/me/views/small_post.dart';
import 'package:chat/app/modules/me/views/vip_icon.dart';
import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/me_controller.dart';
import '../../home/views/vip_sheet.dart';
import 'small_post.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../home/controllers/home_controller.dart';
import 'me_icon.dart';
import 'open_avatar.dart';
import 'package:chat/app/providers/account_provider.dart';
import 'create_post.dart';

class MeView extends GetView<MeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('MeView'.tr,
              style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurface)),
          leading: IconButton(
              icon: Icon(Icons.settings_outlined),
              color: Theme.of(context).colorScheme.onSurface,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                Get.toNamed(Routes.SETTING, arguments: {
                  "phone": AuthProvider.to.account.value.phone_number
                });
              }),
          actions: [
            IconButton(
                icon: Icon(Icons.create_outlined),
                color: Theme.of(context).colorScheme.onSurface,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Get.toNamed(Routes.EDIT_INFO);
                })
          ],
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
        ),
        body: RefreshIndicator(
          backgroundColor: Theme.of(context).colorScheme.surface,
          onRefresh: () => Future.sync(
            () => controller.pagingController.refresh(),
          ),
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(child: Obx(() {
              final _account = AuthProvider.to.account.value;
              final postCount = _account.post_count > 0
                  ? _account.post_count > 999
                      ? '999+' + ' Posts'.tr
                      : _account.post_count.toString() + ' Posts'.tr
                  : '0' + ' Post'.tr;
              final likeCount = _account.likeCount > 0
                  ? _account.likeCount > 9999
                      ? '9999+' + ' hearts'.tr
                      : _account.likeCount.toString() + ' hearts'.tr
                  : '0' + ' heart'.tr;
              final totalViewedCount = controller.totalViewedCount.value > 0
                  ? controller.totalViewedCount.value > 9999
                      ? '9999+' + ' Visitors'.tr
                      : controller.totalViewedCount.value.toString() +
                          ' Visitors'.tr
                  : '0' + ' Visitor'.tr;

              final avatar = _account.avatar;

              return Column(children: [
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
                                        color: Theme.of(context).dividerColor)),
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
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(_account.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface))),
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
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      MeIcon(icon: Icons.icecream_outlined, text: postCount),
                      MeIcon(
                          icon: Icons.favorite_border_outlined,
                          text: likeCount,
                          isMe: true),
                      MeIcon(
                        icon: Icons.star_border_rounded,
                        text: postCount,
                        iconSize: 32,
                      ),

                      // Obx(() => MeIcon(
                      //     icon: getTimeStop() > 0
                      //         ? Icons.timer_outlined
                      //         : Icons.add_outlined,
                      //     onPressedCreate: () {
                      //       if (getTimeStop() > 0) {
                      //         if (!AuthProvider.to.account.value.vip) {
                      //           showModalBottomSheet(
                      //               context: context,
                      //               isScrollControlled: true,
                      //               builder: (context) {
                      //                 return VipSheet(
                      //                     context: context, index: 4);
                      //               });
                      //         }
                      //       } else {
                      //         Get.toNamed(Routes.POST);
                      //       }
                      //     },
                      //     time:
                      //         getTimeStop() > 0 ? getTimeStop().toInt() : null)),
                      // MeIcon(
                      //     icon: Icons.pets_outlined,
                      //     text: totalViewedCount,
                      //     newViewers: controller.unreadViewedCount.value,
                      //     toViewers: true,
                      //     onPressedViewer: () async {
                      // if (_account.vip) {
                      //   Get.toNamed(Routes.PROFILE_VIEWERS);
                      // } else {
                      //   showModalBottomSheet(
                      //       context: context,
                      //       isScrollControlled: true,
                      //       builder: (context) {
                      //         return VipSheet(context: context, index: 1);
                      //       });
                      // try {
                      //   await controller.clearUnreadViewerCount();
                      // } catch (e) {
                      //   print(e);
                      // }
                      // }
                      // }),
                    ]),
                  ]),
                ),
                SizedBox(height: 5),
              ]);
            })),
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
                  itemBuilder: (context, id, index) {
                final post = HomeController.to.postMap[id];
                if (index == 0) {
                  return CreatePost(
                    id: id,
                  );
                }
                if (post == null) {
                  return SizedBox.shrink();
                }
                return SmallPost(
                    onTap: () {
                      Get.toNamed(
                        Routes.MY_SINGLE_POST,
                        arguments: {
                          'id': id,
                        },
                      );
                    },
                    postId: id,
                    post: post);
              }),
            ),
            SliverToBoxAdapter(child: Container(height: 100))
          ]),
        ));
  }
}
