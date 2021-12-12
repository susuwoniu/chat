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
      appBar: AppBar(
        title: Text('AgePickerView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 15, 0, 15),
            alignment: Alignment.topLeft,
            child: Text(
              'I_was_born_in'.tr,
              style: TextStyle(color: Colors.black54, fontSize: 18.0),
            ),
          ),
          YearPicker(
              isShowBar: false,
              onChanged: (year) {
                controller.setBirthYear(year.toString());
              }),
          NextButton(
              action: 'age',
              onPressed: () async {
                try {
                  await controller.updateAge();
                } catch (e) {
                  UIUtils.showError(e);
                }
              })
        ]),
      ),
    );
  }
}
