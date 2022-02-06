import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_name_controller.dart';
import 'appbar_save.dart';
import 'input_widget.dart';

class EditNameView extends GetView<EditNameController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Name".tr, style: TextStyle(fontSize: 16)),
        actions: [
          Obx(() {
            final _isActived = controller.isActived.value;
            return AppBarSave(
                isActived: _isActived,
                onPressed: () async {
                  try {
                    await AccountProvider.to.postAccountInfoChange(
                      {"name": controller.currentName.value},
                    );
                    RouterProvider.to.toNextPage();
                  } catch (e) {
                    UIUtils.showError(e);
                  }
                });
          }),
        ],
      ),
      body: Obx(() {
        return InputWidget(
            maxLength: 14,
            maxLines: 1,
            initialContent: controller.initialContent,
            onChange: controller.onChangeTextValue);
      }),
    );
  }
}
