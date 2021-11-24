import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_info_controller.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:carousel_slider/carousel_slider.dart';

import './edit_widget.dart';

class EditInfoView extends GetView<EditInfoController> {
  final List<String> imgList = [
    "https://img9.doubanio.com/icon/ul43630113-26.jpg",
    "https://i.loli.net/2021/11/24/If5SQkMWKl2rNvX.png",
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  ];
  @override
  Widget build(BuildContext context) {
    var _imgItems = imgList;

    _imgItems.add('');

    return Scaffold(
      appBar: AppBar(
        title: Text('EditInfoView'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 180,
              viewportFraction: 0.8,
              enableInfiniteScroll: false,
            ),
            items: imgList.map((item) {
              return Container(
                child: Stack(children: [
                  Image.network(
                    item,
                    fit: BoxFit.cover,
                    height: 160,
                    width: 160,
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Text('x', style: TextStyle(color: Colors.red)))
                ]),
              );
            }).toList(),
          ),
          Container(height: 12, color: Colors.black12),
          EditWidget(title: 'nickname'.tr, content: 'name'),
          EditWidget(title: 'gender'.tr, content: 'female'),
          EditWidget(title: 'bio'.tr, content: 'fjdksjfkdsjfk'),
          EditWidget(title: 'location'.tr, content: 'china'),
          EditWidget(title: 'birth'.tr, content: '1999'),
          EditWidget(title: 'tags'.tr, content: 'null'),
        ],
      )),
    );
  }
}
