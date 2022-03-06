import 'package:flutter/material.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import '../controllers/complete_gender_controller.dart';
import 'package:chat/app/modules/change_gender/views/gender_picker.dart';
import '../../complete_age/views/next_button.dart';
import 'package:chat/app/providers/providers.dart';

class CompleteGenderView extends GetView<CompleteGenderController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          centerTitle: true,
          title: Text('CompleteGender'.tr, style: TextStyle(fontSize: 16)),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text('I_am'.tr,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 17.0)),
              SizedBox(height: 10),
              Text("Please_take_care".tr,
                  style: TextStyle(color: Theme.of(context).hintColor)),
              Obx(() => GenderPicker(
                    selectedGender: controller.selectedGender.value,
                    setGender: controller.setGender,
                  )),
              Obx(() => NextButton(
                  text: controller.actionText,
                  disabled: controller.selectedGender.value == "",
                  confirm: true,
                  onPressed: () async {
                    try {
                      final account = await AccountProvider.to
                          .postAccountInfoChange(
                              {"gender": controller.selectedGender.value});
                      // if next action to next action
                      AuthProvider.to.checkActions(account.actions);
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  }))
            ],
          ),
        ));
  }
}
