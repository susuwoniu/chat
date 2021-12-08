import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/me_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

import './profile_text.dart';
import './age_widget.dart';
import './circle_widget.dart';
import 'nickname_widget.dart';
import './dot_widget.dart';
import 'my_posts.dart';

final List<String> imgList = [
  "https://img9.doubanio.com/icon/ul43630113-26.jpg",
  "https://i.loli.net/2021/11/24/If5SQkMWKl2rNvX.png",
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
];

class MeView extends GetView<MeController> {
  final CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double paddingLeft = width * 0.055;

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Image.network(
                      item,
                      fit: BoxFit.cover,
                      height: height,
                      width: width,
                    ),
                  ],
                ),
              ),
            ))
        .toList();

    return Scaffold(body: Obx(() {
      final _account = AuthProvider.to.account.value;
      final _name = _account.name;
      final _vip = _account.vip;
      final _genderIcon = _account.gender == 'female' ? 63293 : 63645;
      final _likeCount = _account.likeCount.toString();

      final _bio = _account.bio == '' ? 'nothing' : _account.bio;
      final _location = _account.location ?? 'unknown place';
      final _birth = _account.birthday ?? 'xxxx-xx-xx';
      return SingleChildScrollView(
          child: Column(
        children: [
          Stack(children: [
            CarouselSlider(
              items: imageSliders,
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                  height: width,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    controller.setCurrent(index);
                  }),
            ),
            Positioned(
              bottom: height * 0.01,
              width: width,
              child: DotWidget(
                  current: controller.current,
                  onTap: buttonCarouselController.animateToPage,
                  count: 3),
            ),
            Positioned(
                left: paddingLeft,
                top: height * 0.06,
                child: CircleWidget(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Get.back();
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
                bottom: height * 0.04,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NicknameWidget(name: _name, vip: _vip),
                      SizedBox(height: 8),
                      AgeWidget(
                          text: _account.age.toString(),
                          iconName: IconData(_genderIcon,
                              fontFamily: 'MaterialIcons'),
                          borderRadius: 6,
                          backgroundColor: _account.gender == 'female'
                              ? Colors.pink
                              : Colors.blue,
                          paddingLeft: 2,
                          paddingRight: 6,
                          paddingTop: 2,
                          fontSize: 16,
                          iconSize: 18),
                      SizedBox(height: 15),
                      AgeWidget(
                          text: _likeCount,
                          iconName:
                              IconData(63288, fontFamily: 'MaterialIcons'),
                          iconColor: Colors.pink,
                          borderRadius: 20,
                          backgroundColor: Colors.black38,
                          paddingLeft: 11,
                          paddingRight: 10,
                          paddingTop: 3,
                          fontSize: 19,
                          iconSize: 22),
                    ])),
          ]),
          Container(
            padding: EdgeInsets.fromLTRB(paddingLeft, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_bio!,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                    )),
                SizedBox(height: 10),
                ProfileText(
                    text: _location,
                    iconName: IconData(61716, fontFamily: 'MaterialIcons')),
                ProfileText(
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
