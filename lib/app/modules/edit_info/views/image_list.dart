import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'single_image.dart';
import 'blank_image.dart';
import 'image_button.dart';
import '../controllers/edit_info_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat/app/ui_utils/crop_image.dart';
import 'package:chat/types/types.dart';
import 'package:mime_type/mime_type.dart';

class ImageList extends StatelessWidget {
  ImageList({
    Key? key,
  }) : super(key: key);
  final authProvider = AuthProvider.to;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final blankList = <Widget>[];

      final _width = MediaQuery.of(context).size.width;
      final _margin = _width * 0.03;
      final _paddingLeft = _width * 0.095 - _margin * 2;
      final _paddingRight = _paddingLeft - _margin;
      final account = authProvider.account.value;
      final imgList = account.profile_images;

      for (var i = 0; i < 6 - imgList.length; i++) {
        blankList.add(Stack(
          children: [
            Wrap(direction: Axis.horizontal, children: [
              BlankImage(onPressed: () {
                _pickImage(imgList.length);
              })
            ]),
            Positioned(
                bottom: 2,
                right: 7,
                child: ImageButton(
                    isAdd: true,
                    onPressed: () {
                      _pickImage(imgList.length);
                    })),
          ],
        ));
        print(blankList);
      }
      final _imageList = <Widget>[];
      for (var i = 0; i < imgList.length; i++) {
        _imageList.add(
          Stack(
            children: [
              Obx(() {
                return SingleImage(
                    img: authProvider.account.value.profile_images[i]);
              }),
              Positioned(
                  bottom: 2,
                  right: 7,
                  child: ImageButton(isAdd: false, onPressed: deleteImage(i))),
            ],
          ),
        );
      }

      final _fullList = _imageList + blankList;

      return Container(
          margin: EdgeInsets.fromLTRB(
              _paddingLeft, _width * 0.05, _paddingRight, _width * 0.03),
          child: Wrap(direction: Axis.horizontal, children: _fullList));
    });
  }

  DeleteImageFn deleteImage(int i) {
    return () async {
      try {
        await EditInfoController.to.deleteImg(i);
      } catch (e) {
        UIUtils.showError(e);
      }
    };
  }

  Future<void> _pickImage(int i) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      final imageFile = pickedImage != null ? File(pickedImage.path) : null;
      if (imageFile != null) {
        final file = await cropImage(imageFile.path);
        if (file != null) {
          UIUtils.showLoading();
          final bytes = await file.readAsBytes();
          var decodedImage = await decodeImageFromList(bytes);
          final width = decodedImage.width.toDouble();
          final height = decodedImage.height.toDouble();
          final size = bytes.length;
          final mimeType = mime(file.path);

          if (mimeType != null) {
            final img = ProfileImageEntity(
                mime_type: mimeType,
                url: file.path,
                width: width,
                height: height,
                size: size,
                order: i,
                thumbtail: ThumbtailEntity(
                    height: height,
                    width: width,
                    url: file.path,
                    mime_type: mimeType));

            await EditInfoController.to.addImg(i, img);
            await EditInfoController.to.sendProfileImage(img, index: i);
            UIUtils.hideLoading();
          } else {
            UIUtils.hideLoading();

            throw Exception('wrong image type');
          }
        }
      }
    } catch (e) {
      UIUtils.showError(e);
    }
  }
}

typedef DeleteImageFn = void Function();
