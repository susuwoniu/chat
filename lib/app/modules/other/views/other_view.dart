import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../me/views/small_post.dart';
import '../../me/views/like_count.dart';
import '../controllers/other_controller.dart';
import '../../home/views/more_dots.dart';
import 'package:chat/app/common/block.dart';
import 'package:chat/app/common/quote_with_link.dart';
import '../../me/views/me_icon.dart';
import '../../me/views/vip_icon.dart';

class OtherView extends GetView<OtherController> {
  final CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final postMap = controller.postMap;
    final accountId = controller.accountId;
    final _account = AuthProvider.to.simpleAccountMap[accountId] ??
        SimpleAccountEntity.empty();

    final _imgList = List.from(_account.profile_images ?? []);
    if (_imgList.isEmpty) {
      _imgList.add(ProfileImageEntity.empty());
    }
    final name = _account.name;
    // final postCount = _account.post_count > 0
    //     ? _account.post_count > 999
    //         ? '999+' + ' Posts'.tr
    //         : _account.post_count.toString() + ' Posts'.tr
    //     : '0' + ' Post'.tr;
    // final likeCount = _account.like_count > 0
    //     ? _account.like_count > 9999
    //         ? '9999+' + ' Hearts'.tr
    //         : _account.like_count.toString() + ' Hearts'.tr
    //     : '0' + ' Heart'.tr;

    if (_imgList.isEmpty) {
      _imgList.add(ProfileImageEntity.empty());
    }
    final avatar = _imgList[0].url;
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
        ),
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(
              child: Column(children: [
            Column(children: [
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                            name: _account.name,
                            uri: avatar,
                            size: 50)),
                    Positioned(
                      bottom: 0,
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
              SizedBox(height: 8),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(_account.bio ?? '',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          height: 1.5))),
              SizedBox(height: 11),
            ]),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              color: Theme.of(context).colorScheme.surface,
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  MeIcon(icon: Icons.icecream_outlined, text: 'postCount'),
                  MeIcon(
                      icon: Icons.favorite_border_outlined,
                      text: 'likeCount',
                      isMe: true),
                  MeIcon(icon: Icons.send_outlined, text: ''),
                ]),
              ]),
            ),
            SizedBox(height: 5),
          ])),
          PagedSliverGrid<String?, String>(
            showNewPageProgressIndicatorAsGridChild: false,
            showNewPageErrorIndicatorAsGridChild: false,
            showNoMoreItemsIndicatorAsGridChild: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    Get.toNamed(Routes.MY_SINGLE_POST, arguments: {
                      'id': id,
                    });
                  },
                  postId: id,
                  post: post);
            }),
          ),
          SliverToBoxAdapter(child: Container(height: 100))
        ]));
  }
}
