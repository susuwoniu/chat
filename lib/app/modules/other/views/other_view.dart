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

    final _bio = _account.bio == null
        ? 'nothing'
        : _account.bio == ''
            ? 'nothing'
            : _account.bio;
    final _location = _account.location;
    final _birth = _account.birthday;
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
                        enableInfiniteScroll: false,
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
                            NicknameWidget(name: _name, vip: _vip),
                            SizedBox(height: 10),
                            AgeWidget(
                                gender: _account.gender,
                                age: _account.age == null
                                    ? ' ???'
                                    : _account.age.toString()),
                            SizedBox(height: 15),
                            Obx(() {
                              final _likeCount = AuthProvider
                                  .to
                                  .simpleAccountMap[Get.arguments['accountId']]!
                                  .like_count;
                              return LikeCount(
                                text: _likeCount.toString(),
                              );
                            }),
                          ])),
                  Positioned(
                    bottom: height * 0.01,
                    width: width,
                    child: DotsWidget(
                        current: controller.current,
                        onTap: buttonCarouselController.animateToPage,
                        count: _account.profile_images == null
                            ? 0
                            : _account.profile_images!.length),
                  ),
                ]),
                Container(
                  padding: EdgeInsets.fromLTRB(paddingLeft, 15, 0, 0),
                  alignment: Alignment.topLeft,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileInfoText(
                            text: _bio!,
                            icon: Icons.face_retouching_natural_outlined),
                        SizedBox(height: 6),
                        ProfileInfoText(
                            text: _location,
                            icon: Icons.location_city_outlined),
                        SizedBox(height: 6),
                        ProfileInfoText(text: _birth, icon: Icons.cake_outlined)
                      ]),
                )
              ]),
            ),
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
                  final post = postMap[id]!;
                  return SmallPost(
                      onTap: () {
                        Get.toNamed(Routes.ROOM, arguments: {
                          "id": "im$accountId@$imDomain",
                          "quote": post.content
                        });
                      },
                      postId: id,
                      content: post.content,
                      backgroundColor: post.backgroundColor);
                })),
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
                        bottomText: 'Ban',
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
                Obx(() => _chatButton(
                      text: _account.is_liked ? 'Liked' : 'Like',
                      onPressed: () {
                        controller.toggleLike();

                        if (_account.is_liked) {
                          try {
                            controller.postLikeCount(accountId);
                            UIUtils.toast('okkk');
                            final currentAccount =
                                AuthProvider.to.simpleAccountMap[accountId]!;
                            currentAccount.like_count += 1;
                            AuthProvider.to.simpleAccountMap[accountId] =
                                currentAccount;
                          } catch (e) {
                            UIUtils.showError(e);
                          }
                        } else {
                          try {
                            controller.cancelLikeCount(accountId);
                            UIUtils.toast('okkk-cancel');
                            final currentAccount =
                                AuthProvider.to.simpleAccountMap[accountId]!;
                            currentAccount.like_count -= 1;
                            AuthProvider.to.simpleAccountMap[accountId] =
                                currentAccount;
                          } catch (e) {
                            UIUtils.showError(e);
                          }
                        }
                      },
                      color: HexColor("#fd79a8"),
                    )),
                SizedBox(width: 30),
                _chatButton(
                  text: 'Chat',
                  onPressed: () {
                    Get.toNamed(Routes.ROOM, arguments: {
                      'id': "im$accountId@$imDomain",
                    });
                  },
                )
              ]))),
    ]);
  }

  Widget _chatButton(
      {required String text, required Function onPressed, Color? color}) {
    final accountId = controller.accountId;
    final _account = AuthProvider.to.simpleAccountMap[accountId] ??
        SimpleAccountEntity.empty();
    return Expanded(
        child: GestureDetector(
            onTap: () {
              onPressed();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 7),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: color == null
                          ? Colors.black
                          : _account.is_liked
                              ? Colors.transparent
                              : color),
                  color: _account.is_liked ? color : Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                text,
                style: TextStyle(
                    color: color == null
                        ? Colors.black
                        : _account.is_liked
                            ? Colors.white
                            : color,
                    fontSize: 20),
              ),
            )));
  }
}
