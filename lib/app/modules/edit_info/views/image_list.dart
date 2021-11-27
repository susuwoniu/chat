import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'single_image.dart';
import 'blank_image.dart';
import 'image_button.dart';
import '../controllers/edit_info_controller.dart';

class ImageList extends StatelessWidget {
  ImageList({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _width = MediaQuery.of(context).size.width;
      final _margin = _width * 0.03;
      final _paddingLeft = _width * 0.095 - _margin * 2;
      final _paddingRight = _paddingLeft - _margin;
      final imgList = EditInfoController.to.imgList;
      final _blankList = <Widget>[];
      for (var i = 0; i < 9 - imgList.length; i++) {
        _blankList.add(Stack(
          children: [
            Wrap(direction: Axis.horizontal, children: [BlankImage()]),
            Positioned(
                bottom: 7,
                right: 7,
                child: ImageButton(isAdd: true, onPressed: addImage)),
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
              Positioned(
                  bottom: 7,
                  right: 7,
                  child: ImageButton(isAdd: false, onPressed: deleteImage(i))),
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
    });
  }

  void addImage() {}

  DeleteImageFn deleteImage(int i) {
    return () {
      EditInfoController.to.deleteImg(i);
    };
  }
}

typedef DeleteImageFn = void Function();
