import 'package:flutter/material.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import '../controllers/change_gender_controller.dart';
import 'gender_picker.dart';
import '../../complete_age/views/next_button.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:flutter/services.dart';

class ChangeGenderView extends GetView<ChangeGenderController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ChangeGender'.tr, style: TextStyle(fontSize: 16)),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text('I_am'.tr, style: TextStyle(fontSize: 17.0)),
                SizedBox(height: 10),
                Obx(() => GenderPicker(
                      selectedGender: controller.selectedGender.value,
                      setGender: controller.setGender,
                    )),
                NextButton(
                    text: "Save".tr,
                    onPressed: () async {
                      try {
                        await AccountProvider.to.postAccountInfoChange(
                            {"gender": controller.selectedGender.value});
                        RouterProvider.to.toNextPage();
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                    })
              ],
            ),
          ),
        ));
  }
}
