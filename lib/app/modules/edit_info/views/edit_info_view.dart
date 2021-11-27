import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../controllers/edit_info_controller.dart';
import 'image_list.dart';
import './edit_row.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditInfoView extends GetView<EditInfoController> {
  //  final ImagePicker _picker = ImagePicker();
  // // Pick an image
  // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  // // Capture a photo
  // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  // // Pick a video

  // final List<XFile>? images = await _picker.pickMultiImage();
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
                  ImageList(),
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
