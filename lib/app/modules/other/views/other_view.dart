import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
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
import '../controllers/other_controller.dart';
import '../../me/views/image_slider.dart';
import 'package:chat/types/types.dart';
import '../../home/views/more_dots.dart';
import '../../me/views/profile_info_text.dart';
import 'package:hexcolor/hexcolor.dart';

class OtherView extends GetView<OtherController> {
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
      _imgList.add(ProfileImageEntity.empty());
    }
    return Stack(clipBehavior: Clip.antiAliasWithSaveLayer, children: [
      CustomScrollView(
          // controller: controller.listScrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(children: [
                Stack(children: [
                  CarouselSlider(
                    items: _imgList
                        .map((img) => ImageSlider(
                            img: img, height: height * 0.5, width: width))
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
                                child: NicknameWidget(name: _name, vip: _vip)),
                            SizedBox(height: 10),
                            AgeWidget(
                                gender: AuthProvider
                                    .to.simpleAccountMap[accountId]!.gender,
                                age: AuthProvider.to
                                            .simpleAccountMap[accountId]!.age ==
                                        null
                                    ? ' ???'
                                    : _account.age.toString()),
                            SizedBox(height: 15),
                            Obx(() {
                              final _likeCount = AuthProvider
                                  .to.simpleAccountMap[accountId]!.like_count;
                              return LikeCount(
                                count: _likeCount,
                              );
                            }),
                          ])),
                  Positioned(
                      bottom: 10,
                      width: width,
                      child: Obx(
                        () => DotsWidget(
                            current: controller.current,
                            onTap: buttonCarouselController.animateToPage,
                            count: _account.profile_images == null
                                ? 0
                                : _account.profile_images!.length),
                      )),
                ]),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 17, 25, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          final _account =
                              AuthProvider.to.simpleAccountMap[accountId] ??
                                  SimpleAccountEntity.empty();
                          final _bio = _account.bio == ''
                              ? 'Nothing...'.tr
                              : _account.bio!;

                          return Text(_bio,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  height: 1.4,
                                  fontSize: 18,
                                  color: Colors.grey.shade800));
                        }),
                        SizedBox(height: 8),
                        Obx(() {
                          final _account =
                              AuthProvider.to.simpleAccountMap[accountId] ??
                                  SimpleAccountEntity.empty();
                          final _location = _account.location == ''
                              ? 'Unknown_place'.tr
                              : _account.location!;
                          return ProfileInfoText(
                              text: _location,
                              icon: Icons.location_on_outlined);
                        }),
                        SizedBox(height: 2)
                      ]),
                )
              ]),
            ),
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
                  return SmallPost(
                      onTap: () {
                        Get.toNamed(Routes.ROOM, arguments: {
                          "id": "$accountId@$imDomain",
                          "quote": post.content
                        });
                      },
                      postId: id,
                      content: post.content,
                      backgroundColor: post.backgroundColor);
                })),
            SliverToBoxAdapter(child: Container(height: 80))
          ]),
      Positioned(
          left: width * 0.04,
          top: height * 0.06,
          child: CircleWidget(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          )),
      Positioned(
          right: width * 0.04,
          top: height * 0.06,
          child: CircleWidget(
            icon: Icon(Icons.more_horiz_rounded, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return MoreDots(
                        context: context,
                        bottomIcon: Icons.face_retouching_off_rounded,
                        bottomText: 'Ban'.tr,
                        onPressedShare: () {
                          Navigator.pop(context);
                        },
                        onPressedReport: () {
                          Navigator.pop(context);
                          Get.toNamed(Routes.REPORT,
                              arguments: {"related_account_id": accountId});
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
                  color: Colors.grey.shade200,
                )),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3) // changes position of shadow
                      )
                ],
                color: Colors.white,
              ),
              padding: EdgeInsets.fromLTRB(30, 13, 30, 25),
              child: Row(children: [
                Obx(() {
                  final _account =
                      AuthProvider.to.simpleAccountMap[accountId] ??
                          SimpleAccountEntity.empty();
                  final _is_liked = _account.is_liked;

                  return _chatButton(
                    text: _is_liked ? 'Liked' : 'Like',
                    isLiked: _account.is_liked,
                    onPressedLike: (bool increase) async {
                      controller.likeAction(increase);
                      if (increase) {
                        try {
                          await controller.postLikeCount(accountId);
                          UIUtils.toast('okkk');
                          final currentAccount =
                              AuthProvider.to.simpleAccountMap[accountId]!;
                          currentAccount.like_count += 1;
                          AuthProvider.to.simpleAccountMap[accountId] =
                              currentAccount;
                        } catch (e) {
                          UIUtils.showError(e);
                          controller.likeAction(false);
                        }
                      } else {
                        try {
                          await controller.cancelLikeCount(accountId);
                          UIUtils.toast('okkk-cancel');
                          final currentAccount =
                              AuthProvider.to.simpleAccountMap[accountId]!;
                          currentAccount.like_count -= 1;
                          AuthProvider.to.simpleAccountMap[accountId] =
                              currentAccount;
                        } catch (e) {
                          UIUtils.showError(e);
                          controller.likeAction(true);
                        }
                      }
                    },
                    color: HexColor("#fd79a8"),
                  );
                }),
                SizedBox(width: 30),
                _chatButton(
                    text: 'Chat',
                    onPressedChat: () {
                      Get.toNamed(Routes.ROOM, arguments: {
                        'id': "$accountId@$imDomain",
                      });
                    },
                    isLiked: _account.is_liked)
              ]))),
    ]);
  }

  Widget _chatButton(
      {required String text,
      Function? onPressedLike,
      Function? onPressedChat,
      Color? color,
      required bool isLiked}) {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              if (text == 'Chat') {
                onPressedChat!();
              } else {
                onPressedLike!(!isLiked);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 7),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: color == null
                          ? Colors.black
                          : isLiked
                              ? Colors.transparent
                              : color),
                  color: isLiked ? color : Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                text.tr,
                style: TextStyle(
                    color: color == null
                        ? Colors.black
                        : isLiked
                            ? Colors.white
                            : color,
                    fontSize: 20),
              ),
            )));
  }
}
