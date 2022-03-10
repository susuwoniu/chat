import 'package:chat/app/modules/complete_age/views/next_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/report_controller.dart';
import '../../edit_info/views/blank_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:async';
import 'dart:io';
import 'package:chat/app/ui_utils/ui_utils.dart';
import '../../edit_info/views/single_image.dart';
import 'bottom_sheet_row.dart';

const Map<String, String> _reportType = {
  "spam": "Fraud",
  "offensive": "Harassing",
  "illegal": "Crime_and_illegal_activities",
  "complaint": "Other",
  'cancel': 'Cancel'
};

const _typeTitle = ["spam", "offensive", "illegal", "complaint", 'cancel'];
const _type = [
  "Fraud",
  "Harassing",
  "Crime_and_illegal_activities",
  "Other",
  'Cancel'
];

class ReportView extends GetView<ReportController> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String? _related_post_id = Get.arguments['related_post_id'];
    final String? _related_account_id = Get.arguments['related_account_id'];
    final tag = _related_post_id ?? "" + (_related_account_id ?? "");
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text('ReportView'.tr, style: TextStyle(fontSize: 16)),
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
        ),
        body: GetBuilder<ReportController>(
            init: ReportController(),
            tag: tag,
            builder: (controller) {
              return GestureDetector(
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
                                      return _reportSheet(context);
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(() => Text(
                                            controller.reportType.value == ''
                                                ? 'Choose_report_type'.tr
                                                : _reportType[controller
                                                        .reportType.value]!
                                                    .tr,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        size: 36,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      )
                                    ]),
                              )),
                          SizedBox(height: 15),
                          TextField(
                            controller: _textController,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(fontSize: 16, height: 1.6),
                            maxLength: 300,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 15),
                              hintText: 'Enter_report_description(Optional)'.tr,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                    width: 1),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                    width: 1),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                    width: 1),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text('Screenshot_of_Evidence(Optional)'.tr,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500))),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Obx(() => controller.isShowBlank.value
                                ? BlankImage(
                                    page: 'report',
                                    onPressed: () {
                                      _uploadScreenshot();
                                    })
                                : SingleImage(img: controller.imgEntity!)),
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
                                    UIUtils.toast(
                                        'Thank_you_for_reporting!'.tr);
                                    _textController.clear();
                                    Get.back();
                                  } catch (e) {
                                    UIUtils.showError(e);
                                  }
                                } else {
                                  UIUtils.showError(
                                      'Please_choose_a_report_type'.tr);
                                }
                              })
                        ]),
                  ));
            }));
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
          try {
            final img = await controller.uploadImg(
                path: pickedImage!.path,
                mimeType: mimeType,
                size: size,
                width: width,
                height: height);
            controller.isShowBlank.value = false;
            controller.setImgEntity(img);
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
      UIUtils.hideLoading();

      UIUtils.showError(e);
    }
  }

  Widget _reportSheet(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _type.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (index < 4) {
                  controller.setReportType(_typeTitle[index]);
                }
              },
              child: BottomSheetRow(text: _type[index].tr),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 1),
        ));
  }
}
