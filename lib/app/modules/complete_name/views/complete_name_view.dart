import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:chat/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/complete_name_controller.dart';
import 'package:chat/app/modules/edit_name/views/input_widget.dart';
import '../../complete_age/views/next_button.dart';

class CompleteNameView extends GetView<CompleteNameController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text('CompleteName'.tr, style: TextStyle(fontSize: 16)),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15),
                child: Text('Give_yourself_a_nice_name'.tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 17.0))),
            SizedBox(height: 10),
            InputWidget(
                underline: true,
                maxLength: MAX_NAME_LENGTH,
                maxLines: 1,
                initialContent: controller.initialContent,
                onChange: controller.onChangeTextValue),
            SizedBox(height: 30),
            Obx(() => NextButton(
                text: controller.actionText,
                disabled: !controller.isActived.value,
                confirm: false,
                onPressed: () async {
                  try {
                    final account =
                        await AccountProvider.to.postAccountInfoChange(
                      {"name": controller.currentName.value},
                    );
                    // if next action to next action
                    AuthProvider.to.checkActions(account.actions);
                  } catch (e) {
                    UIUtils.showError(e);
                  }
                }))
          ])),
    );
  }
}
