import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'single_image.dart';
import 'blank_image.dart';
import 'image_button.dart';
import '../controllers/edit_info_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

final ImagePicker _picker = ImagePicker();

class ImageList extends StatefulWidget {
  ImageList({
    Key? key,
  }) : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _ImageListState extends State<ImageList> {
  late AppState state;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    var blankList = <Widget>[];

    return Obx(() {
      final _width = MediaQuery.of(context).size.width;
      final _margin = _width * 0.03;
      final _paddingLeft = _width * 0.095 - _margin * 2;
      final _paddingRight = _paddingLeft - _margin;
      final imgList = EditInfoController.to.imgList;

      for (var i = 0; i < 9 - imgList.length; i++) {
        blankList.add(Stack(
          children: [
            Wrap(direction: Axis.horizontal, children: [BlankImage()]),
            Positioned(
                bottom: 7,
                right: 7,
                child: ImageButton(isAdd: true, onPressed: addImage)),
          ],
        ));
        print(blankList);
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

      final _fullList = _imageList + blankList;

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

  addImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print(image);
    // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  }

  DeleteImageFn deleteImage(int i) {
    return () {
      EditInfoController.to.deleteImg(i);
    };
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Future<Null> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }
}

typedef DeleteImageFn = void Function();
