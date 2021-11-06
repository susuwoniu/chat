import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

import '../controllers/setting_controller.dart';
import 'package:chat/app/services/services.dart';

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
                SettingsSection(
                  title: 'general'.tr,
                  tiles: [
                    SettingsTile(
                      title: 'language'.tr,
                      subtitle: 'English',
                      leading: Icon(Icons.language),
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
                      leading: Icon(Icons.mode_night),
                      switchValue: ConfigService.to.nightMode.value,
                      onToggle: (bool value) {
                        print("value $value");
                        ConfigService.to.toggleNightMode(value);
                      },
                    ),
                  ],
                ),
              ],
            )));
  }
}
