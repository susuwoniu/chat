import 'package:chat/common.dart';
import 'package:flutter/material.dart' hide YearPicker;
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import '../controllers/edit_info_controller.dart';
import 'year_picker.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat/app/ui_utils/crop_image.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:async';
import 'dart:io';

class EditInfoView extends GetView<EditInfoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EditInfoView'.tr, style: TextStyle(fontSize: 16)),
        bottom: PreferredSize(
            child: Container(
              height: 0.5,
              color: Theme.of(context).dividerColor,
            ),
            preferredSize: Size.fromHeight(0)),
      ),
      body: Obx(() {
        final _account = AuthProvider.to.account.value;
        final _bio = _account.bio == '' ? 'Nothing...'.tr : _account.bio;
        final _birthday = _account.birthday ?? '????';

        return SettingsList(
            contentPadding: EdgeInsets.all(0),
            darkTheme: SettingsThemeData(
                settingsListBackground: Theme.of(context).backgroundColor,
                settingsSectionBackground:
                    Theme.of(context).colorScheme.surface),
            sections: [
              SettingsSection(tiles: [
                SettingsTile(
                    title: _title("Avatar".tr),
                    trailing: Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        child: Avatar(
                            elevation: 0,
                            name: _account.name,
                            uri: AuthProvider
                                    .to.account.value.profile_images.isEmpty
                                ? null
                                : AuthProvider
                                    .to.account.value.profile_images[0].url,
                            size: 35)),
                    onPressed: (BuildContext context) {
                      _pickImage(0);
                    }),
                SettingsTile(
                    title: _title("Nickname".tr),
                    trailing: _trail(_account.name),
                    onPressed: (BuildContext context) {
                      Get.toNamed(Routes.EDIT_NAME,
                          arguments: {"mode": "back"});
                    }),
                SettingsTile(
                    title: _title("gender".tr),
                    trailing: _trail(_account.gender.tr),
                    onPressed: (BuildContext context) {
                      Get.toNamed(Routes.CHANGE_GENDER, arguments: {
                        "mode": "back",
                        "current-value": _account.gender
                      });
                    }),
                SettingsTile(
                    title: _title("Bio".tr),
                    trailing: _trail(_bio ?? ''),
                    onPressed: (BuildContext context) {
                      Get.toNamed(Routes.EDIT_BIO, arguments: {"mode": "back"});
                    }),
                SettingsTile(
                    title: _title("birth".tr),
                    trailing: _trail(_birthday.substring(0, 4)),
                    onPressed: (BuildContext context) {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return YearPicker(
                              onSelect: (year) async {
                                try {
                                  await AccountProvider.to
                                      .postAccountInfoChange({
                                    "birthday": year.toString() + "-01-01"
                                  }, ignoreActions: true);
                                  Navigator.pop(context);
                                } catch (e) {
                                  Navigator.pop(context);
                                  UIUtils.showError(e);
                                }
                              },
                              isShowBar: true,
                            );
                          });
                    }),
              ]),
            ]);
      }),
    );
  }

  Future<void> _pickImage(int i) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      final imageFile = pickedImage != null ? File(pickedImage.path) : null;
      if (imageFile != null) {
        final file = await cropImage(imageFile.path);
        if (file != null) {
          UIUtils.showLoading();
          final bytes = await file.readAsBytes();
          var decodedImage = await decodeImageFromList(bytes);
          final width = decodedImage.width.toDouble();
          final height = decodedImage.height.toDouble();
          final size = bytes.length;
          final mimeType = mime(file.path);

          if (mimeType != null) {
            final img = ProfileImageEntity(
                mime_type: mimeType,
                url: file.path,
                width: width,
                height: height,
                size: size,
                order: i,
                thumbtail: ThumbtailEntity(
                    height: height,
                    width: width,
                    url: file.path,
                    mime_type: mimeType));

            // await EditInfoController.to.addImg(i, img);
            await EditInfoController.to.sendProfileImage(img, index: i);
            UIUtils.hideLoading();
          } else {
            UIUtils.hideLoading();

            throw Exception('wrong image type');
          }
        }
      }
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  Widget _title(String text) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        child:
            Text(text, style: TextStyle(color: ChatThemeData.secondaryBlack)));
  }

  Widget _trail(String text) {
    return Expanded(
        child: Text(
      text,
      textDirection: TextDirection.rtl,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 15, color: Color(0xff686A6D)),
    ));
  }
}
