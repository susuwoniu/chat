import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/complete_bio_controller.dart';
import 'package:chat/app/modules/edit_name/views/input_widget.dart';
import '../../complete_age/views/next_button.dart';
import 'package:chat/common.dart';

class CompleteBioView extends GetView<CompleteBioController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('CompleteBio'.tr, style: TextStyle(fontSize: 16)),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: TextButton(
                child: Text(
                  "Skip".tr,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
                style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                onPressed: () async {
                  try {
                    final account =
                        await AccountProvider.to.postAccountInfoChange(
                      {"bio_action": "skip"},
                    );
                    // if next action to next action
                    AuthProvider.to.checkActions(account.actions);
                  } catch (e) {
                    UIUtils.showError(e);
                  }
                },
              ))
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Text('Give_yourself_a_nice_bio'.tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 17.0))),
            SizedBox(height: 30),
            InputWidget(
                fillColor: Theme.of(context).colorScheme.background,
                maxLength: MAX_BIO_LENGTH,
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
