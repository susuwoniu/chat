import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../me/views/age_widget.dart';
import '../../me/views/./circle_widget.dart';
import '../../me/views/nickname_widget.dart';
import '../../me/views/dots_widget.dart';
import '../../me/views/small_post.dart';
import '../../me/views/like_count.dart';
import '../../other/controllers/other_controller.dart';
import '../../me/views/image_slider.dart';
import '../../home/views/more_dots.dart';
import 'package:chat/app/common/block.dart';
import 'package:chat/app/common/quote_with_link.dart';

class Test2View extends GetView<OtherController> {
  final CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double paddingLeft = width * 0.055;
    final postMap = controller.postMap;
    final accountId = controller.accountId;
    final _account = AuthProvider.to.simpleAccountMap[accountId] ??
        SimpleAccountEntity.empty();
    final _name = _account.name;

    final _vip = _account.vip;

    final _imgList = List.from(_account.profile_images ?? []);
    if (_imgList.isEmpty) {
      _imgList.add(ImageEntity.empty());
    }
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(clipBehavior: Clip.antiAliasWithSaveLayer, children: [
          RefreshIndicator(
              backgroundColor: Theme.of(context).colorScheme.surface,
              onRefresh: () => Future.sync(
                    () => controller.pagingController.refresh(),
                  ),
              child: CustomScrollView(
                  // controller: controller.listScrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(children: [
                        Container(
                            child: Stack(children: [
                          CarouselSlider(
                            items: _imgList
                                .map((img) => ImageSlider(
                                    img: img,
                                    height: height * 0.5,
                                    width: width))
                                .toList(),
                            carouselController: buttonCarouselController,
                            options: CarouselOptions(
                                height: height * 0.5,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  controller.setCurrent(index);
                                }),
                          ),
                          Positioned(
                              left: paddingLeft,
                              bottom: height * 0.025,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: width * 0.85,
                                        child: NicknameWidget(
                                            name: _name, vip: _vip)),
                                    SizedBox(height: 10),
                                    AgeWidget(
                                        gender: AuthProvider
                                            .to
                                            .simpleAccountMap[accountId]!
                                            .gender,
                                        age: AuthProvider
                                                    .to
                                                    .simpleAccountMap[
                                                        accountId]!
                                                    .age ==
                                                null
                                            ? ' ???'
                                            : _account.age.toString()),
                                    SizedBox(height: 10),
                                    Obx(() {
                                      final _likeCount = AuthProvider
                                          .to
                                          .simpleAccountMap[accountId]!
                                          .like_count;
                                      return LikeCount(
                                        count: _likeCount,
                                      );
                                    }),
                                  ])),
                          Positioned(
                              bottom: 6,
                              width: width,
                              child: Obx(
                                () => DotsWidget(
                                    current: controller.current,
                                    onTap:
                                        buttonCarouselController.animateToPage,
                                    count: _account.profile_images == null
                                        ? 0
                                        : _account.profile_images!.length),
                              )),
                        ])),
                        Container(
                          alignment: Alignment.topLeft,
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(16, 15, 25, 10),
                          child: Obx(() {
                            final _account =
                                AuthProvider.to.simpleAccountMap[accountId] ??
                                    SimpleAccountEntity.empty();
                            final _bio = _account.bio == ''
                                ? 'Nothing...'.tr
                                : _account.bio!;

                            return Text(_bio,
                                style: TextStyle(
                                    height: 1.5,
                                    fontSize: 17,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground));
                          }),
                        )
                      ]),
                    ),
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
                          return SmallPost(
                              onTap: () {
                                Get.toNamed(Routes.ROOM, arguments: {
                                  "id": "$accountId@$imDomain",
                                  "reduce": "false",
                                  "quote": quoteWithLink(post.content, id),
                                  "quote_background_color":
                                      post.backgroundColor,
                                });
                              },
                              postId: id,
                              post: post);
                        })),
                    SliverToBoxAdapter(child: Container(height: 80))
                  ])),
          Positioned(
              left: width * 0.04,
              top: height * 0.06,
              child: CircleWidget(
                icon: Icon(Icons.arrow_back_rounded,
                    color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () {
                  Get.back();
                },
              )),
          Positioned(
              right: width * 0.04,
              top: height * 0.06,
              child: CircleWidget(
                icon: Icon(Icons.more_horiz_rounded,
                    color: Theme.of(context).colorScheme.onPrimary),
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
              )),
          Positioned(
              bottom: 0,
              child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                      color: Theme.of(context).dividerColor,
                    )),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3) // changes position of shadow
                          )
                    ],
                    color: Theme.of(context).colorScheme.brightness ==
                            Brightness.light
                        ? Colors.white
                        : Theme.of(context).colorScheme.background,
                  ),
                  padding: EdgeInsets.fromLTRB(35, 13, 35, 25),
                  child: Row(children: [
                    Obx(() {
                      final _account =
                          AuthProvider.to.simpleAccountMap[accountId] ??
                              SimpleAccountEntity.empty();
                      final _is_liked = _account.is_liked;

                      return _chatButton(
                        context: context,
                        text: _is_liked ? 'Liked'.tr : 'Like'.tr,
                        isLiked: _account.is_liked,
                        onPressedLike: (bool increase) async {
                          controller.accountAction(increase: increase);
                          if (increase) {
                            try {
                              await controller.postLikeCount(accountId);
                              UIUtils.toast('Liked!'.tr);
                              final currentAccount =
                                  AuthProvider.to.simpleAccountMap[accountId]!;
                              currentAccount.like_count += 1;
                              AuthProvider.to.simpleAccountMap[accountId] =
                                  currentAccount;
                            } catch (e) {
                              UIUtils.showError(e);
                              controller.accountAction(increase: false);
                            }
                          } else {
                            try {
                              await controller.cancelLikeCount(accountId);
                              UIUtils.toast('Successfully_unliked.'.tr);
                              final currentAccount =
                                  AuthProvider.to.simpleAccountMap[accountId]!;
                              currentAccount.like_count -= 1;
                              AuthProvider.to.simpleAccountMap[accountId] =
                                  currentAccount;
                            } catch (e) {
                              UIUtils.showError(e);
                              controller.accountAction(increase: true);
                            }
                          }
                        },
                        color: Color(0xFFfd79a8),
                      );
                    }),
                    SizedBox(width: 40),
                    _chatButton(
                        context: context,
                        text: 'Chat'.tr,
                        onPressedChat: () {
                          Get.toNamed(Routes.ROOM, arguments: {
                            'id': "$accountId@$imDomain",
                          });
                        },
                        isLiked: _account.is_liked)
                  ]))),
        ]));
  }

  Widget _chatButton(
      {required String text,
      required BuildContext context,
      Function? onPressedLike,
      Function? onPressedChat,
      Color? color,
      required bool isLiked}) {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              if (onPressedChat != null) {
                onPressedChat();
              } else if (onPressedLike != null) {
                onPressedLike(!isLiked);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 7),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: color == null
                          ? ChatThemeData.secondaryBlack
                          : isLiked
                              ? Colors.transparent
                              : color),
                  color: color == null
                      ? Colors.white
                      : isLiked
                          ? color
                          : Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                text.tr,
                style: TextStyle(
                    color: color == null
                        ? ChatThemeData.secondaryBlack
                        : isLiked
                            ? Colors.white
                            : color,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            )));
  }
}
