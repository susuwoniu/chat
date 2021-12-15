import 'package:flutter/material.dart';
import 'package:chat/common.dart';

import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../controllers/setting_controller.dart';
import 'package:chat/app/providers/providers.dart';

class SettingView extends GetView<SettingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.arrow_back,
          //   ),
          //   onPressed: Get.popHistory,
          // ),
          title: Text('SettingView'),
          centerTitle: true,
        ),
        body: Obx(() => SettingsList(
              sections: [
                SettingsSection(tiles: [
                  SettingsTile(
                    title: 'Phone'.tr,
                  ),
                ]),
                SettingsSection(
                  // title: 'general'.tr,
                  tiles: [
                    SettingsTile(
                      title: 'language'.tr,
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
                                    title: Text('english'.tr),
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
                      title: 'night-mode'.tr,
                      // leading: Icon(Icons.mode_night),
                      switchValue: ConfigProvider.to.nightMode.value,
                      onToggle: (bool value) {
                        print("value $value");
                        ConfigProvider.to.toggleNightMode(value);
                      },
                    ),
                    SettingsTile(
                      title: 'Clear'.tr,
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
                    SettingsTile(
                        title: 'Log_out'.tr,
                        onPressed: (BuildContext context) async {
                          try {
                            UIUtils.showLoading();
                            await AccountProvider.to.handleLogout();
                            UIUtils.hideLoading();
                            UIUtils.toast("退出成功");
                            RouterProvider.to.restart(context);
                          } catch (e) {
                            UIUtils.hideLoading();
                            UIUtils.showError(e);
                          }
                        }),
                  ],
                ),
              ],
            )));
  }
}
