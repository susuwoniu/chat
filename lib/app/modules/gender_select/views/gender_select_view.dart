import 'package:flutter/material.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/gender_select_controller.dart';
import 'gender_picker.dart';
import '../../age_picker/views/next_button.dart';
import 'package:chat/app/providers/providers.dart';

class GenderSelectView extends GetView<GenderSelectController> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('GenderSelect'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: _width * 0.08),
            child: Column(
              children: [
                Column(children: [
                  SizedBox(height: 10),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('I_am'.tr,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 17.0)),
                        SizedBox(height: 5),
                        Obx(() => GenderPicker(
                              selectedGender: controller.selectedGender.value,
                              setGender: controller.setGender,
                            )),
                      ],
                    ),
                  ),
                ]),
                SizedBox(height: _height * 0.05),
                NextButton(
                    action: 'gender',
                    onPressed: () async {
                      try {
                        await AccountProvider.to.postAccountInfoChange(
                            {"gender": controller.selectedGender.value});
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
