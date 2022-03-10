import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/feedback_controller.dart';
import 'package:chat/app/modules/complete_age/views/next_button.dart';
import '../../edit_info/views/blank_image.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import '../../edit_info/views/single_image.dart';
import 'package:chat/app/common/upload_img.dart';
import 'package:chat/app/common/choose_img.dart';

class FeedbackView extends GetView<FeedbackController> {
  final _textController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          centerTitle: true,
          title: Text('FeedbackView'.tr, style: TextStyle(fontSize: 16)),
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
            child: SingleChildScrollView(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    TextField(
                      controller: _textController,
                      maxLines: 5,
                      maxLength: 300,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 16, height: 1.6),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                        hintText:
                            'Please_describe_your_issue_using_at_least_10_characters_so_that_we_can_help_troubleshoot_your_issue_more_quickly'
                                .tr,
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
                    SizedBox(height: 10),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                            'Screenshot_for_troubleshooting(Optional)'.tr,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500))),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Obx(() => controller.isShowBlank.value
                          ? BlankImage(
                              page: 'report',
                              onPressed: () async {
                                try {
                                  final imageFile =
                                      await chooseImage(ratioX: 4, ratioY: 4);

                                  if (imageFile != null) {
                                    final image = await uploadImage(imageFile);
                                    if (image != null) {
                                      controller.isShowBlank.value = false;
                                      controller.setImgEntity(image);
                                    }
                                  }
                                } catch (e) {
                                  UIUtils.showError(e);
                                }
                              })
                          : SingleImage(img: controller.imgEntity!)),
                    ),
                    SizedBox(height: 10),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text('mobile_email_contact'.tr,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500))),
                    TextField(
                      controller: _contactController,
                      maxLines: 1,
                      maxLength: 50,
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 16, height: 1.6),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        hintText: 'Optional'.tr,
                        counterText: "",
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
                    SizedBox(height: 40),
                    NextButton(
                        text: 'Submit'.tr,
                        onPressed: () async {
                          if (_textController.text.length < 10) {
                            UIUtils.showError(
                                'Please_describe_your_issue_using_at_least_10_characters'
                                    .tr);
                          } else {
                            try {
                              await controller.onPressFeedback(
                                  content: _textController.text);
                              UIUtils.toast('Thank_you_for_feedback!'.tr);
                              _textController.clear();
                              Get.back();
                            } catch (e) {
                              UIUtils.showError(e);
                            }
                          }
                        }),
                    SizedBox(height: 60),
                  ]),
            ))));
  }
}
