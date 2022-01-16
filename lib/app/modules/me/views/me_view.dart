import 'package:chat/app/modules/me/views/small_post.dart';
import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/types/account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/me_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'profile_info_text.dart';
import './age_widget.dart';
import './circle_widget.dart';
import 'nickname_widget.dart';
import 'dots_widget.dart';
import 'like_count.dart';
import 'profile_viewers_bubble.dart';
import 'image_slider.dart';
import '../../home/views/vip_sheet.dart';
import 'small_post.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../home/controllers/home_controller.dart';
import './create_post.dart';

class MeView extends GetView<MeController> {
  final CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double paddingLeft = width * 0.055;
    final phone = AuthProvider.to.account.value.phone_number;
    return RefreshIndicator(
        onRefresh: () => Future.sync(
              () => controller.pagingController.refresh(),
            ),
        child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: _appbar(
                iconLeft: Icons.settings_rounded,
                leftTap: () {
                  Get.toNamed(Routes.SETTING, arguments: {"phone": phone});
                },
                iconRight: Icons.create_rounded,
                rightTap: () {
                  Get.toNamed(Routes.EDIT_INFO);
                }),
            body: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: Obx(() {
                  final _account = AuthProvider.to.account.value;
                  final _name = _account.name;
                  final _vip = _account.vip;
                  final _likeCount = _account.likeCount.toString();

                  final _bio =
                      _account.bio == '' ? 'Nothing...'.tr : _account.bio!;

                  final _location = _account.location == ''
                      ? 'Unknown_place'.tr
                      : _account.location!;
                  final _imgList = List.from(_account.profile_images);

                  if (_imgList.isEmpty) {
                    _imgList.add(ProfileImageEntity.empty());
                  }
                  return Column(children: [
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
                                    age: _account.age.toString()),
                                SizedBox(height: 15),
                                LikeCount(
                                  text: _likeCount,
                                ),
                              ])),
                      Positioned(
                          right: paddingLeft,
                          bottom: height * 0.025,
                          child: ProfileViewersBubble(
                              totalViewersCount:
                                  controller.totalViewedCount.value,
                              newViewersCount:
                                  controller.unreadViewedCount.value,
                              onPressed: () {
                                if (_vip) {
                                  Get.toNamed(Routes.PROFILE_VIEWERS);
                                } else {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      enableDrag: false,
                                      builder: (context) {
                                        return VipSheet(
                                            context: context, index: 1);
                                      });
                                }
                              })),
                      Positioned(
                          bottom: 10,
                          width: width,
                          child: Obx(
                            () => DotsWidget(
                                current: controller.current,
                                onTap: buttonCarouselController.animateToPage,
                                count: _account.profile_images.length),
                          )),
                    ]),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 17, 25, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _bio,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  height: 1.4,
                                  fontSize: 18,
                                  color: Colors.grey.shade800),
                            ),
                            SizedBox(height: 8),
                            ProfileInfoText(
                                text: _location,
                                icon: Icons.location_on_outlined),
                            SizedBox(height: 2),
                          ]),
                    )
                  ]);
                }),
              ),
              // SliverToBoxAdapter(child: CreatePost()),
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
                  final post = HomeController.to.postMap[id];
                  if (index == 0) {
                    return CreatePost(
                        id: id,
                        isCreate:
                            AuthProvider.to.account.value.is_can_post ?? true,
                        nextCreateTime: controller.nextCreateTime);
                  }
                  if (post == null) {
                    return SizedBox.shrink();
                  }
                  return SmallPost(
                      onTap: () {
                        Get.toNamed(Routes.MY_SINGLE_POST, arguments: {
                          'postId': id,
                        });
                      },
                      postId: id,
                      content: post.content,
                      backgroundColor: post.backgroundColor);
                }),
              ),
              SliverToBoxAdapter(child: Container(height: 100))
            ])));
  }

  PreferredSizeWidget _appbar(
      {required IconData iconLeft,
      required Function leftTap,
      IconData? iconRight,
      Function? rightTap}) {
    return AppBar(
        leading: Container(
            padding: EdgeInsets.only(left: 16),
            child: CircleWidget(
              icon: Icon(iconLeft, color: Colors.white),
              onPressed: () {
                leftTap();
              },
            )),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 17),
              child: CircleWidget(
                icon: Icon(iconRight, color: Colors.white),
                onPressed: () {
                  if (rightTap != null) {
                    rightTap();
                  }
                },
              )),
        ]);
  }
}
