import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:chat/common.dart';
import 'package:get/get.dart';
import 'package:chat/app/common/upload_img.dart';
import '../controllers/complete_avatar_controller.dart';
import '../../complete_age/views/next_button.dart';
import 'package:chat/app/common/choose_img.dart';

class CompleteAvatarView extends GetView<CompleteAvatarController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
            title: Text('CompleteAvatar'.tr, style: TextStyle(fontSize: 16)),
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
                            {"avatar_action": "skip"},
                          );
                          // if next action to next action
                          AuthProvider.to.checkActions(account.actions);
                        } catch (e) {
                          UIUtils.showError(e);
                        }
                      })),
            ]),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: 15),
            Text("Please_choose_a_photo_that_best_represents_you.".tr,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 17)),
            SizedBox(height: 20),
            Obx(() {
              return controller.avatar.value != null
                  ? Container(
                      child: Avatar(
                          uri: controller.avatar.value!.thumbnail.url,
                          size: 59))
                  : GestureDetector(
                      onTap: handleImageUpload,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xfff2f2f7)),
                        padding: EdgeInsets.all(35),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          iconSize: 30,
                          icon: Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Theme.of(context).hintColor,
                          ),
                          onPressed: handleImageUpload,
                        ),
                      ));
            }),
            SizedBox(height: 20),
            Text("Photo_can_be_edited_later.".tr,
                style: TextStyle(color: Theme.of(context).hintColor)),
            SizedBox(height: 25),
            Obx(() => NextButton(
                  disabled: controller.avatar.value == null,
                  text: controller.actionText,
                  onPressed: () async {
                    try {
                      final account =
                          await AccountProvider.to.postAccountInfoChange({
                        "avatar": controller.avatar.value,
                      });
                      // if next action to next action
                      AuthProvider.to.checkActions(account.actions);
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                )),
          ]),
        ));
  }

  handleImageUpload() async {
    try {
      final imageFile = await chooseImage(ratioX: 4, ratioY: 4);

      if (imageFile != null) {
        final image = await uploadImage(imageFile);
        if (image != null) {
          controller.avatar.value = image;
        }
      }
    } catch (e) {
      UIUtils.showError(e);
    }
  }
}
