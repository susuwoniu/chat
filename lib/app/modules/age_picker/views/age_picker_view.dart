import 'package:chat/app/modules/age_picker/views/next_button.dart';
import 'package:flutter/material.dart' hide YearPicker;
import 'package:get/get.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';

import '../controllers/age_picker_controller.dart';
import '../../edit_info/views/year_picker.dart';

class AgePickerView extends GetView<AgePickerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                child: Text(
                  'I_was_born_in'.tr,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 18.0),
                ),
              ),
              SizedBox(height: 5),
              Text("Please_take_care".tr,
                  style: TextStyle(color: Theme.of(context).hintColor)),
              YearPicker(
                  isShowBar: false,
                  onChanged: (year) {
                    controller.setBirthYear(year.toString());
                  }),
              SizedBox(height: 30),
              NextButton(
                  text: controller.actionText,
                  onPressed: () async {
                    try {
                      await controller.updateAge();
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  })
            ]),
          ),
        ));
  }
}
