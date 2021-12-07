import 'package:flutter/material.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/gender_select_controller.dart';
import 'gender_picker.dart';
import '../../age_picker/views/next_button.dart';

class GenderSelectView extends GetView<GenderSelectController> {
  final _loginController = LoginController.to;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('I_am'.tr,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 17.0)),
                        Obx(() => GenderPicker(
                              selectedGender: controller.selectedGender.value,
                              setGender: controller.setGender,
                            )),
                      ],
                    ),
                  ),
                ]),
                NextButton(
                    action: 'gender',
                    onPressed: () async {
                      try {
                        await _loginController.postAccountInfoChange(
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
