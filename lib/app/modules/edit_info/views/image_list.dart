import 'package:flutter/material.dart';
import 'single_image.dart';
import 'blank_image.dart';
import 'image_button.dart';
import 'package:dotted_border/dotted_border.dart';

class ImageList extends StatelessWidget {
  final List<String> imgList;

  // final void Function() onPressed;

  ImageList({
    Key? key,
    required this.imgList,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _margin = _width * 0.03;
    final _paddingLeft = _width * 0.095 - _margin * 2;
    final _paddingRight = _paddingLeft - _margin;

    final List<String> imgList = [
      "https://img9.doubanio.com/icon/ul43630113-26.jpg",
      "https://i.loli.net/2021/11/24/If5SQkMWKl2rNvX.png",
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      "https://img9.doubanio.com/icon/ul43630113-26.jpg",
      "https://img9.doubanio.com/icon/ul43630113-26.jpg",
    ];
    final _blankList = <Widget>[];
    for (var i = 0; i < 9 - imgList.length; i++) {
      _blankList.add(Stack(
        children: [
          Wrap(direction: Axis.horizontal, children: [BlankImage()]),
          Positioned(bottom: 7, right: 7, child: ImageButton(isAdd: true)),
        ],
      ));
      print(_blankList);
    }
    final _imageList = <Widget>[];
    for (var i = 0; i < imgList.length; i++) {
      _imageList.add(
        Stack(
          children: [
            SingleImage(img: imgList[i]),
            Positioned(bottom: 7, right: 7, child: ImageButton(isAdd: false)),
          ],
        ),
      );
    }

    final _fullList = _imageList + _blankList;

    return Container(
        margin: EdgeInsets.fromLTRB(
            _paddingLeft, _width * 0.05, _paddingRight, _width * 0.03),
        child: Wrap(direction: Axis.horizontal, children: [
          Expanded(
            flex: 1,
            child: Wrap(children: _fullList),
          ),
        ]));
  }
}
