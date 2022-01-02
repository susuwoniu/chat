import 'package:chat/app/modules/age_picker/views/next_button.dart';
import 'package:chat/types/account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/report_controller.dart';
import '../../edit_info/views/blank_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat/types/types.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:async';
import 'dart:io';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'report_sheet.dart';
import '../../edit_info/views/single_image.dart';

const Map<String, String> Type = {
  "spam": "Fraud",
  "offensive": "Harassing",
  "illegal": "Crime_and_illegal_activities",
  "complaint": "Other"
};

class ReportView extends GetView<ReportController> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ReportView'),
          centerTitle: true,
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ReportSheet();
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 8),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[200]!,
                      ),
                    )),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Text(
                                controller.reportType.value == ''
                                    ? 'choose_report_type'
                                    : Type[controller.reportType.value]!,
                                style: TextStyle(fontSize: 17),
                              )),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 40,
                          )
                        ]),
                  )),
              SizedBox(height: 15),
              TextField(
                controller: _textController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: 17, height: 1.6),
                cursorColor: Colors.pink,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  hintText: 'Enter_report_description(Optional)',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text('Screenshot_of_Evidence(Optional)',
                      style: TextStyle(fontSize: 16))),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Obx(() => controller.isShowBlank.value
                    ? BlankImage(
                        page: 'report',
                        onPressed: () {
                          _uploadScreenshot();
                        })
                    : SingleImage(img: controller.imgEntity)),
              ),
              SizedBox(height: 20),
              NextButton(
                  text: 'Submit',
                  onPressed: () async {
                    if (controller.reportType.value != '') {
                      try {
                        await controller.onPressReport(
                            content: _textController.text);
                        UIUtils.toast('okk');
                        _textController.clear();
                        Get.back();
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                    } else {
                      UIUtils.showError('choose type');
                    }
                  })
            ])));
  }

  Future<void> _uploadScreenshot() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      final imageFile = pickedImage != null ? File(pickedImage.path) : null;
      if (imageFile != null) {
        UIUtils.showLoading();
        final bytes = await imageFile.readAsBytes();
        var decodedImage = await decodeImageFromList(bytes);
        final width = decodedImage.width.toDouble();
        final height = decodedImage.height.toDouble();
        final size = bytes.length;
        final mimeType = mime(imageFile.path);

        if (mimeType != null) {
          final img = ProfileImageEntity(
              mime_type: mimeType,
              url: imageFile.path,
              width: width,
              height: height,
              size: size,
              order: 0,
              thumbtail: ThumbtailEntity(
                  height: height,
                  width: width,
                  url: imageFile.path,
                  mime_type: mimeType));

          controller.isShowBlank.value = false;
          controller.setImgEntity(img);
          try {
            await controller.uploadImg(img: controller.imgEntity);
          } catch (e) {
            UIUtils.showError(e);
          }
          UIUtils.hideLoading();
        } else {
          UIUtils.hideLoading();
          throw Exception('wrong image type');
        }
      }
    } catch (e) {
      UIUtils.showError(e);
    }
  }
}
