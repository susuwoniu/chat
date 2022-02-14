import 'package:flutter/material.dart';
import 'package:chat/common.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../controllers/setting_controller.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:flutter/services.dart';

class SettingView extends GetView<SettingController> {
  @override
  Widget build(BuildContext context) {
    final _account = AuthProvider.to.account.value;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
          title: Text('SettingView'.tr, style: TextStyle(fontSize: 16)),
        ),
        body: Obx(() => SettingsList(
              darkTheme: SettingsThemeData(
                  settingsListBackground: Theme.of(context).backgroundColor,
                  settingsSectionBackground:
                      Theme.of(context).colorScheme.surface),
              sections: [
                SettingsSection(title: Text('Account_Security'.tr), tiles: [
                  SettingsTile(
                    title: Text('Phone'.tr),
                    value: Text(
                      _account.phone_number ?? "",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                ]),
                SettingsSection(title: Text('General'.tr), tiles: [
                  SettingsTile(
                    title: Text('Language'.tr),
                    value: Text(
                      'English',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    // leading: Icon(Icons.language),
                    onPressed: (BuildContext context) {
                      Get.bottomSheet(
                          Container(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                    title: Text('simplified-chinese'.tr),
                                    onTap: () {}),
                                ListTile(
                                  title: Text('English'.tr),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          ignoreSafeArea: false,
                          backgroundColor: context.theme.backgroundColor);
                    },
                  ),
                  SettingsTile.switchTile(
                    initialValue: ConfigProvider.to.nightMode.value,
                    title: Text('Night-mode'.tr),
                    onToggle: (bool value) {
                      print("value $value");
                      ConfigProvider.to.toggleNightMode(value);
                    },
                  ),
                ]),
                SettingsSection(title: Text('Privacy'.tr), tiles: [
                  SettingsTile(
                    title: Text('Blocked_Users'.tr),
                    onPressed: (BuildContext context) {
                      Get.toNamed(Routes.BLOCK);
                    },
                  ),
                ]),
                SettingsSection(tiles: [
                  SettingsTile(
                    title: Text('Clear_Cache'.tr),
                    onPressed: (BuildContext context) {
                      CacheProvider.to.clear();
                    },
                  ),
                  SettingsTile(
                    title: Text('Help&Feedback'.tr),
                    onPressed: (BuildContext context) {
                      Get.toNamed(Routes.FEEDBACK);
                    },
                  ),
                  SettingsTile(
                    title: Text('About'.tr),
                    onPressed: (BuildContext context) {
                      Get.toNamed(Routes.ABOUT);
                    },
                  ),
                ]),
                SettingsSection(tiles: [
                  SettingsTile(
                      title: Container(
                          alignment: Alignment.center,
                          child: Text('Log_out'.tr,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 17))),
                      onPressed: (BuildContext context) async {
                        try {
                          UIUtils.showLoading();
                          await AccountProvider.to.handleLogout();
                          UIUtils.hideLoading();
                          UIUtils.toast("Logged_out.".tr);
                          RouterProvider.to.restart(context);
                        } catch (e) {
                          UIUtils.hideLoading();
                          UIUtils.showError(e);
                        }
                      }),
                ]),
              ],
            )));
  }
}
