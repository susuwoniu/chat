import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/test2_controller.dart';
// import 'package:csc_picker/csc_picker.dart';

class Test2View extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _MyHomePageState extends State<Test2View> {
  late AppState state;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test2'),
      ),
      body: Center(
        child: imageFile != null ? Image.file(imageFile!) : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          if (state == AppState.free)
            _pickImage();
          else if (state == AppState.picked)
            _cropImage();
          else if (state == AppState.cropped) _clearImage();
        },
        child: _buildButtonIcon(),
      ),
    );
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
        await ImagePicker().getImage(source: ImageSource.gallery);
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
        aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 5),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings:
            IOSUiSettings(title: 'Cropper', aspectRatioLockEnabled: true));
    if (croppedFile != null) {
      imageFile = croppedFile;
      final bytes = await imageFile!.readAsBytes();
      var decodedImage = await decodeImageFromList(bytes);
      final width = decodedImage.width;
      final height = decodedImage.height;
      final size = bytes.length;
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
