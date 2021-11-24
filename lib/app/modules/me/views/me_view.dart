import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/me_controller.dart';

import 'package:carousel_slider/carousel_slider.dart';

import './profile_text.dart';

import './age_widget.dart';

final List<String> imgList = [
  "https://img9.doubanio.com/icon/ul43630113-26.jpg",
  "https://i.loli.net/2021/11/24/If5SQkMWKl2rNvX.png",
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
];

class MeView extends GetView<MeController> {
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double paddingLeft = width * 0.06;

    return Scaffold(
      appBar: AppBar(
        title: Text('MeView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: height / 2,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
            ),
            items: imgList
                .map((item) => Container(
                      child: Stack(children: [
                        Image.network(
                          item,
                          fit: BoxFit.cover,
                          height: height,
                          width: width,
                        ),
                        Positioned(
                            left: paddingLeft,
                            bottom: height * 0.02,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 5, 5),
                                          child: Text('name',
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),
                                        ),
                                        Icon(Icons.stars_rounded,
                                            color: Colors.pink, size: 38),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  AgeWidget(
                                      age: '24',
                                      iconName: IconData(0xe261,
                                          fontFamily: 'MaterialIcons'),
                                      borderRadius: 6,
                                      backgroundColor: Colors.pink,
                                      paddingLeft: 2,
                                      paddingRight: 6,
                                      paddingTop: 2,
                                      paddingBottom: 2,
                                      fontSize: 16,
                                      iconSize: 18),
                                  SizedBox(height: 15),
                                  AgeWidget(
                                      age: '9999',
                                      iconName: IconData(63288,
                                          fontFamily: 'MaterialIcons'),
                                      iconColor: Colors.pink,
                                      borderRadius: 20,
                                      backgroundColor: Colors.black38,
                                      paddingLeft: 11,
                                      paddingRight: 10,
                                      paddingTop: 3,
                                      paddingBottom: 3,
                                      fontSize: 19,
                                      iconSize: 22),
                                ])),
                      ]),
                    ))
                .toList(),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(paddingLeft, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('bio' * 5,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                    )),
                SizedBox(height: 10),
                ProfileText(
                    text: 'location',
                    iconName: IconData(61716, fontFamily: 'MaterialIcons')),
                ProfileText(
                    text: 'tags',
                    iconName: IconData(61505, fontFamily: 'MaterialIcons')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
