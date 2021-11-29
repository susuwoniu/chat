import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:hexcolor/hexcolor.dart';
import '../controllers/edit_info_controller.dart';
import 'package:chat/app/providers/auth_provider.dart';
import 'image_list.dart';
import './edit_row.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditInfoView extends GetView<EditInfoController> {
  final _account = AuthProvider.to.account;

  //  final ImagePicker _picker = ImagePicker();
  // // Pick an image
  // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  // // Capture a photo
  // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  // // Pick a video

  // final List<XFile>? images = await _picker.pickMultiImage();
  @override
  Widget build(BuildContext context) {
    final _bio = _account!.bio == '' ? 'nothing' : _account!.bio;
    final _location = _account!.location ?? 'unknown place';
    final _birth = _account!.birthday ?? 'xxxx-xx-xx';
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
                  EditRow(
                    title: "nickname".tr,
                    content: _account!.name,
                    onPressed: () => {
                      Get.toNamed(Routes.EDIT_INPUT, arguments: {
                        "title": "nickname".tr,
                        "content": _account!.name
                      })
                    },
                  ),
                  EditRow(
                    title: "gender".tr,
                    content: _account!.gender,
                    onPressed: () => {
                      Get.toNamed(Routes.EDIT_INPUT,
                          arguments: {"title": "gender".tr})
                    },
                  ),
                  EditRow(
                    title: "bio".tr,
                    content: _bio!,
                    onPressed: () => {
                      Get.toNamed(Routes.EDIT_INPUT, arguments: {
                        "title": "bio".tr,
                        "maxLines": 3,
                        "maxLength": 50
                      })
                    },
                  ),
                  EditRow(
                    title: "location".tr,
                    content: _location,
                    onPressed: () => {
                      Get.toNamed(Routes.EDIT_INPUT,
                          arguments: {"title": "location".tr})
                    },
                  ),
                  EditRow(
                    title: "birth".tr,
                    content: _birth,
                    onPressed: () => {
                      Get.toNamed(Routes.EDIT_INPUT,
                          arguments: {"title": "birth".tr})
                    },
                  ),
                ],
              )),
        ));
  }
}
