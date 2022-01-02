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
import 'my_posts.dart';
import 'like_count.dart';
import 'profile_viewers_bubble.dart';
import 'image_slider.dart';

class MeView extends GetView<MeController> {
  final CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double paddingLeft = width * 0.055;

    return Scaffold(body: Obx(() {
      final _account = AuthProvider.to.account.value;
      final _name = _account.name;
      final _vip = _account.vip;

      final _likeCount = _account.likeCount.toString();

      final _bio = _account.bio == '' ? 'nothing' : _account.bio;
      final _location = _account.location ?? 'unknown place';
      final _birth = _account.birthday ?? 'xxxx-xx-xx';
      final _imgList = List.from(_account.profileImages);

      if (_imgList.isEmpty) {
        _imgList.add(ProfileImageEntity.empty());
      }

      return ListView(padding: EdgeInsets.all(0), children: [
        Stack(children: [
          CarouselSlider(
            items: _imgList
                .map((img) =>
                    ImageSlider(img: img, height: height * 0.5, width: width))
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
              top: height * 0.06,
              child: CircleWidget(
                icon: Icon(Icons.settings_rounded, color: Colors.white),
                onPressed: () {
                  Get.toNamed(Routes.SETTING,
                      arguments: {"phone": _account.phone_number});
                },
              )),
          Positioned(
              right: paddingLeft,
              top: height * 0.06,
              child: CircleWidget(
                icon: Icon(Icons.create_rounded, color: Colors.white),
                onPressed: () {
                  Get.toNamed(Routes.EDIT_INFO);
                },
              )),
          Positioned(
              left: paddingLeft,
              bottom: height * 0.025,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NicknameWidget(name: _name, vip: _vip),
                    SizedBox(height: 8),
                    AgeWidget(
                        gender: _account.gender, age: _account.age.toString()),
                    SizedBox(height: 15),
                    LikeCount(
                      text: _likeCount,
                    ),
                  ])),
          Positioned(
              right: paddingLeft,
              bottom: height * 0.025,
              child: ProfileViewersBubble(
                totalViewersCount: controller.totalViewedCount.value,
                newViewersCount: controller.unreadViewedCount.value,
                onPressed: () {
                  Get.toNamed(Routes.PROFILE_VIEWERS);
                },
              )),
          Positioned(
            bottom: height * 0.01,
            width: width,
            child: DotsWidget(
                current: controller.current,
                onTap: buttonCarouselController.animateToPage,
                count: _account.profileImages.length),
          ),
        ]),
        Container(
          padding: EdgeInsets.fromLTRB(paddingLeft, 15, 0, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_bio!,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey,
                )),
            SizedBox(height: 8),
            ProfileInfoText(
                text: _location,
                iconName: IconData(61716, fontFamily: 'MaterialIcons')),
            SizedBox(height: 6),
            ProfileInfoText(
                text: _birth,
                iconName: IconData(61505, fontFamily: 'MaterialIcons')),
          ]),
        ),
        MyPosts(),
      ]);
    }));
  }
}
