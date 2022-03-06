import 'package:chat/app/modules/complete_age/views/next_button.dart';
import 'package:flutter/material.dart' hide YearPicker;
import 'package:get/get.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';

import '../controllers/complete_age_controller.dart';
import '../../edit_info/views/year_picker.dart';

class CompleteAgeView extends GetView<CompleteAgeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
            centerTitle: true,
            title: Text('CompleteAge'.tr, style: TextStyle(fontSize: 16))),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 10),
              Container(
                child: Text(
                  'I_was_born_in'.tr,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 17.0),
                ),
              ),
              SizedBox(height: 10),
              Text("Please_take_care".tr,
                  style: TextStyle(color: Theme.of(context).hintColor)),
              YearPicker(
                  isShowBar: false,
                  onChanged: (year) {
                    controller.setBirthYear(year.toString());
                  }),
              SizedBox(height: 10),
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
