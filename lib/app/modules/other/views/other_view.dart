import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/types/account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../me/views/profile_info_text.dart';
import '../../me/views/age_widget.dart';
import '../../me/views/./circle_widget.dart';
import '../../me/views/nickname_widget.dart';
import '../../me/views/dots_widget.dart';
import '../../me/views/my_posts.dart';
import '../../me/views/like_count.dart';
import '../../me/views/profile_viewers_bubble.dart';
import '../controllers/other_controller.dart';
import '../../me/views/image_slider.dart';

class OtherView extends GetView<OtherController> {
  final CarouselController buttonCarouselController = CarouselController();
  final accountId = Get.arguments['accountId'];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double paddingLeft = width * 0.055;

    return Scaffold(body: Obx(() {
      final _account = AuthProvider.to.simpleAccountMap[accountId]!;
      final _name = _account.name;
      final _vip = _account.vip;
      final _genderIcon =
          _account.gender == 'female' ? Icons.female : Icons.male;
      final _likeCount = _account.like_count.toString();

      final _bio = _account.bio == '' ? 'nothing' : _account.bio;
      final _imgList = List.from(_account.profileImages);
      if (_imgList.isEmpty) {
        _imgList.add(ProfileImageEntity.empty());
      }

      return SingleChildScrollView(
          child: Column(
        children: [
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
            // Positioned(
            //     left: paddingLeft,
            //     top: height * 0.06,
            //     child: CircleWidget(
            //       icon: Icon(Icons.settings_rounded, color: Colors.white),
            //       onPressed: () {
            //         Get.toNamed(Routes.SETTING,
            //             arguments: {"phone": _account.phone_number});
            //       },
            //     )),
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
                          icon: _genderIcon, text: _account.age.toString()),
                      SizedBox(height: 15),
                      LikeCount(
                        text: _likeCount,
                      ),
                    ])),
            Positioned(
                right: paddingLeft,
                bottom: height * 0.025,
                child: ProfileViewersBubble(
                  totalViewersCount: 0,
                  newViewersCount: 10,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_bio!,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey,
                    )),
                SizedBox(height: 8),
                // ProfileInfoText(
                //     text: _location,
                //     iconName: IconData(61716, fontFamily: 'MaterialIcons')),
                // SizedBox(height: 6),
                // ProfileInfoText(
                //     text: _birth,
                //     iconName: IconData(61505, fontFamily: 'MaterialIcons')),
              ],
            ),
          ),
          MyPosts(),
        ],
      ));
    }));
  }
}
