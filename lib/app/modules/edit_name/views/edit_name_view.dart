import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../controllers/edit_name_controller.dart';
import 'appbar_save.dart';
import 'input_widget.dart';
import '../../login/controllers/login_controller.dart';

class EditNameView extends GetView<EditNameController> {
  final _loginController = LoginController.to;
  final _authAccount = AuthProvider.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#f0eff4"),
      appBar: AppBar(
        title: Text(_authAccount.account.value.actions[0].type),
        actions: [
          Obx(() {
            final _isActived = controller.isActived.value;
            return AppBarSave(
                isActived: _isActived,
                onPressed: () async {
                  try {
                    await _loginController.postAccountInfoChange(
                        {"name": controller.textController.text.trim()});
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
        child: InputWidget(maxLength: 15, maxLines: 1),
      ),
    );
  }
}
