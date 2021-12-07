import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../controllers/edit_name_controller.dart';
import 'appbar_save.dart';
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
                    await _loginController.postAccountInfoChange({
                      controller.title: controller.textController.text.trim()
                    });
                    UIUtils.toast("ok");
                    Get.back();
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
              maxLines: 1,
              keyboardType: TextInputType.multiline,
              minLines: 1,
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
              maxLength: 15,
            );
          }),
          Positioned(
            bottom: 0,
            child: TextButton(
                onPressed: () {
                  Get.toNamed(Routes.EDIT_BIO,
                      arguments: {"aciton": 'add_account_bio'});
                },
                child: Text('fosdjfs')),
          )
        ]),
      ),
    );
  }
}
