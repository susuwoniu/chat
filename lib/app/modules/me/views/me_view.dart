import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/types/account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/me_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/utils/string.dart';
import 'profile_info_text.dart';
import './age_widget.dart';
import './circle_widget.dart';
import 'nickname_widget.dart';
import 'dots_widget.dart';
import 'my_posts.dart';
import 'like_count.dart';
import 'profile_viewers_bubble.dart';
import 'dart:io';

class MeView extends GetView<MeController> {
  final CarouselController buttonCarouselController = CarouselController();
  Widget imageSlider(ProfileImageEntity img,
      {required double height, required double width}) {
    ImageProvider _image;
    final isNet = isUrl(img.url);
    if (isNet) {
      _image = CachedNetworkImageProvider(img.url);
    } else {
      _image = FileImage(File(img.url));
    }
    return Container(
      child: Container(
        child: Stack(
          children: <Widget>[
            Image(
              image: _image,
              fit: BoxFit.cover,
              height: height,
              width: width,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double paddingLeft = width * 0.055;

    return Scaffold(body: Obx(() {
      final _account = AuthProvider.to.account.value;
      final _name = _account.name;
      final _vip = _account.vip;
      final _genderIcon =
          _account.gender == 'female' ? Icons.female : Icons.male;
      final _likeCount = _account.likeCount.toString();

      final _bio = _account.bio == '' ? 'nothing' : _account.bio;
      final _location = _account.location ?? 'unknown place';
      final _birth = _account.birthday ?? 'xxxx-xx-xx';
      final _imgList = List.from(_account.profileImages);

      if (_imgList.isEmpty) {
        final img = ProfileImageEntity(
            mime_type: "image/jpg",
            url:
                "http://p1.music.126.net/jcKLW8e0n4dqVywaBvGqrA==/109951166712826330.jpg?param=140y140",
            width: 140,
            height: 140,
            size: 45,
            order: 0,
            thumbtail: ThumbtailEntity(
                height: 140,
                width: 140,
                url:
                    "http://p1.music.126.net/jcKLW8e0n4dqVywaBvGqrA==/109951166712826330.jpg?param=140y140",
                mime_type: "image/jpg"));
        _imgList.add(img);
      }

      return SingleChildScrollView(
          child: Column(
        children: [
          Stack(children: [
            CarouselSlider(
              items: _imgList
                  .map((img) =>
                      imageSlider(img, height: height * 0.5, width: width))
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
                ProfileInfoText(
                    text: _location,
                    iconName: IconData(61716, fontFamily: 'MaterialIcons')),
                SizedBox(height: 6),
                ProfileInfoText(
                    text: _birth,
                    iconName: IconData(61505, fontFamily: 'MaterialIcons')),
              ],
            ),
          ),
          MyPosts(),
        ],
      ));
    }));
  }
}
