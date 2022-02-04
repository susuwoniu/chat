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
                color: Colors.grey.shade400,
              ),
              preferredSize: Size.fromHeight(0)),
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.arrow_back,
          //   ),
          //   onPressed: Get.popHistory,
          // ),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          title: Text('SettingView'.tr, style: TextStyle(fontSize: 18)),
        ),
        body: Obx(() => SettingsList(
              sections: [
                SettingsSection(title: 'Account_Security'.tr, tiles: [
                  SettingsTile(
                    title: 'Phone'.tr,
                    subtitle: _account.phone_number,
                  ),
                ]),
                SettingsSection(title: 'General'.tr, tiles: [
                  SettingsTile(
                    title: 'Language'.tr,
                    subtitle: 'English',
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
                    title: 'Night-mode'.tr,
                    // leading: Icon(Icons.mode_night),
                    switchValue: ConfigProvider.to.nightMode.value,
                    onToggle: (bool value) {
                      print("value $value");
                      ConfigProvider.to.toggleNightMode(value);
                    },
                  ),
                ]),
                SettingsSection(title: 'Privacy'.tr, tiles: [
                  SettingsTile(
                    title: 'Blocked_Users'.tr,
                    onPressed: (BuildContext context) {
                      Get.toNamed(Routes.BLOCK);
                    },
                  ),
                ]),
                SettingsSection(tiles: [
                  SettingsTile(
                    title: 'Clear_Cache'.tr,
                    onPressed: (BuildContext context) {
                      CacheProvider.to.clear();
                    },
                  ),
                  SettingsTile(
                    title: 'Help&Feedback'.tr,
                    onPressed: (BuildContext context) {
                      Get.toNamed(Routes.FEEDBACK);
                    },
                  ),
                  SettingsTile(
                    title: 'About'.tr,
                    onPressed: (BuildContext context) {
                      Get.toNamed(Routes.ABOUT);
                    },
                  ),
                ]),
                SettingsSection(tiles: [
                  SettingsTile(
                      iosChevron: null,
                      titleWidget: Container(
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
