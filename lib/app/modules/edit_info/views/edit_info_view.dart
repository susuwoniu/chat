import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../controllers/edit_info_controller.dart';
import 'image_list.dart';
import './edit_row.dart';

class EditInfoView extends GetView<EditInfoController> {
  final List<String> imgList = [
    "https://img9.doubanio.com/icon/ul43630113-26.jpg",
    "https://i.loli.net/2021/11/24/If5SQkMWKl2rNvX.png",
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('EditInfoView'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
              color: HexColor("#f0eff4"),
              child: Column(
                children: [
                  ImageList(imgList: imgList),
                  Container(height: 0.3, color: Colors.black26),
                  EditRow(title: 'nickname'.tr, content: 'name'),
                  EditRow(title: 'gender'.tr, content: 'female'),
                  EditRow(title: 'bio'.tr, content: 'fjdksjfkdsjfk'),
                  EditRow(title: 'location'.tr, content: 'china'),
                  EditRow(title: 'birth'.tr, content: '1999'),
                  EditRow(title: 'tags'.tr, content: 'null'),
                ],
              )),
        ));
  }
}
