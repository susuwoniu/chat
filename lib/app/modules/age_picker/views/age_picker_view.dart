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
        appBar: AppBar(),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 15, 0, 25),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'I_was_born_in'.tr,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 18.0),
                    ),
                  ),
                  YearPicker(
                      isShowBar: false,
                      onChanged: (year) {
                        controller.setBirthYear(year.toString());
                      }),
                  SizedBox(height: 30),
                  NextButton(onPressed: () async {
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
