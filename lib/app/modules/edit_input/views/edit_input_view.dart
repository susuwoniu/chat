import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../controllers/edit_input_controller.dart';
import 'appbar_save.dart';

class EditInputView extends GetView<EditInputController> {
  final _title = Get.arguments['title'];
  final int _maxLines = Get.arguments['maxLines'] ?? 1;
  final _maxLength = Get.arguments['maxLength'] ?? 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#f0eff4"),
      appBar: AppBar(
        title: Text(_title),
        actions: [
          Obx(() {
            final _isActived = controller.isActived.value;
            return AppBarSave(
                isActived: _isActived,
                onPressed: () async {
                  try {
                    await controller.postChange(
                        _title, controller.textController.text.trim());
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
              maxLines: _maxLines,
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
              maxLength: _maxLength,
            );
          })
        ]),
      ),
    );
  }
}
