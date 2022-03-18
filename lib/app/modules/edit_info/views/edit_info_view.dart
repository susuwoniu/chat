import 'package:chat/common.dart';
import 'package:flutter/material.dart' hide YearPicker;
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import '../controllers/edit_info_controller.dart';
import 'year_picker.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:chat/app/common/upload_img.dart';
import 'package:chat/app/common/choose_img.dart';

class EditInfoView extends GetView<EditInfoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                            uri: AuthProvider
                                .to.account.value.avatar?.thumbnail.url,
                            size: 35)),
                    onPressed: (BuildContext context) async {
                      try {
                        final imageFile =
                            await chooseImage(ratioX: 4, ratioY: 4);
                        if (imageFile != null) {
                          final getUrl = await uploadImage(imageFile);
                          if (getUrl != null) {
                            await AccountProvider.to.postAccountInfoChange({
                              "avatar": getUrl,
                            });
                          }
                        }
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                    }),
                SettingsTile(
                    title: _title("Nickname".tr),
                    trailing: _trail(_account.name),
                    onPressed: (BuildContext context) {
                      Get.toNamed(Routes.EDIT_NAME,
                          arguments: {"mode": "back"});
                    }),
                SettingsTile(
                    title: _title("Gender".tr),
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
                          enableDrag: false,
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
