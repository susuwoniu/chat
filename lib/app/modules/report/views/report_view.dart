import 'package:chat/app/modules/complete_age/views/next_button.dart';
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
import 'package:flutter/services.dart';

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
        backgroundColor: Theme.of(context).colorScheme.surface,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('ReportView'.tr, style: TextStyle(fontSize: 16)),
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
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
                              color: Theme.of(context).dividerColor,
                            ),
                          )),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Text(
                                      controller.reportType.value == ''
                                          ? 'Choose_report_type'.tr
                                          : Type[controller.reportType.value]!
                                              .tr,
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
                      style: TextStyle(fontSize: 16, height: 1.6),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        hintText: 'Enter_report_description(Optional)'.tr,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).dividerColor, width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).dividerColor, width: 1),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).dividerColor, width: 1),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text('Screenshot_of_Evidence(Optional)'.tr,
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
                        text: 'Submit'.tr,
                        onPressed: () async {
                          if (controller.reportType.value != '') {
                            try {
                              await controller.onPressReport(
                                  content: _textController.text.isEmpty
                                      ? ''
                                      : _textController.text);
                              UIUtils.toast('Thank_you_for_reporting!'.tr);
                              _textController.clear();
                              Get.back();
                            } catch (e) {
                              UIUtils.showError(e);
                            }
                          } else {
                            UIUtils.showError(
                                'Please_choose_a_report_type.'.tr);
                          }
                        })
                  ]),
            )));
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
