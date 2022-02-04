import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../edit_name/views/appbar_save.dart';
import '../controllers/edit_bio_controller.dart';
import '../../edit_name/views/input_widget.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:flutter/services.dart';

class EditBioView extends GetView<EditBioController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0eff4),
      appBar: AppBar(
        title: Text("Bio".tr, style: TextStyle(fontSize: 18)),
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        actions: [
          Obx(() {
            final _isActived = controller.isActived.value;
            return AppBarSave(
                isActived: _isActived,
                onPressed: () async {
                  try {
                    await AccountProvider.to.postAccountInfoChange(
                      {"bio": controller.currentBio.value},
                    );
                  } catch (e) {
                    UIUtils.showError(e);
                  }
                });
          }),
        ],
      ),
      body: Obx(() {
        return InputWidget(
            maxLength: 100,
            maxLines: 10,
            minLines: 3,
            initialContent: controller.initialContent,
            onChange: controller.onChangeTextValue);
      }),
    );
  }
}
