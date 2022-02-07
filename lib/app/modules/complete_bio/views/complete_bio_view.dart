import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/complete_bio_controller.dart';
import 'package:chat/app/modules/edit_name/views/input_widget.dart';
import '../../age_picker/views/next_button.dart';

class CompleteBioView extends GetView<CompleteBioController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            SizedBox(height: 10),
            Container(
                child: Text('Give_yourself_a_nice_bio'.tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 17.0))),
            SizedBox(height: 30),
            InputWidget(
                fillColor: Theme.of(context).colorScheme.background,
                maxLength: 144,
                maxLines: 10,
                minLines: 3,
                initialContent: controller.initialContent,
                onChange: controller.onChangeTextValue),
            SizedBox(height: 20),
            Obx(() => NextButton(
                text: controller.actionText,
                disabled: !controller.isActived.value,
                confirm: false,
                onPressed: () async {
                  try {
                    final account =
                        await AccountProvider.to.postAccountInfoChange(
                      {"bio": controller.currentBio.value},
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
