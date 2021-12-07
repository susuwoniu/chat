import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../edit_name/views/appbar_save.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/edit_bio_controller.dart';
import '../../edit_name/views/input_widget.dart';

class EditBioView extends GetView<EditBioController> {
  final _loginController = LoginController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#f0eff4"),
      appBar: AppBar(
        title: Text("bio"),
        actions: [
          Obx(() {
            final _isActived = controller.isActived.value;
            return AppBarSave(
                isActived: _isActived,
                onPressed: () async {
                  try {
                    await _loginController.postAccountInfoChange(
                        {"bio": controller.currentBio.value});
                  } catch (e) {
                    UIUtils.showError(e);
                  }
                });
          }),
        ],
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Obx(() {
          return InputWidget(
              maxLength: 50,
              maxLines: 5,
              initialContent: controller.initialContent,
              onChange: controller.onChangeTextValue);
        }),
      ),
    );
  }
}
