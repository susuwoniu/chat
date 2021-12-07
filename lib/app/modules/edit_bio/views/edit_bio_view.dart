import 'package:chat/app/providers/auth_provider.dart';
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
                        {"bio": controller.textController.text.trim()});
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
        child: Stack(children: [
          Obx(() {
            final _isShowClear = controller.isShowClear.value;
            return TextFormField(
              controller: controller.textController,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              autofocus: true,
              style: TextStyle(
                fontSize: 17,
                height: 1.5,
              ),
              decoration: InputDecoration(
                suffixIcon: _isShowClear
                    ? IconButton(
                        onPressed: () => {controller.textController.clear()},
                        icon: Icon(Icons.clear),
                        splashColor: Colors.transparent,
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(17),
              ),
              maxLength: 50,
            );
          })
        ]),
      ),
    );
  }
}
