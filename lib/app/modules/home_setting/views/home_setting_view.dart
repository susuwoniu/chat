import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../controllers/home_setting_controller.dart';
import 'package:chat/app/providers/providers.dart';
import './lan_row.dart';

final LanMap = {'en': 'English', 'zh': 'Simplified-Chinese'.tr};

class HomeSettingView extends GetView<HomeSettingController> {
  final currentLanCode = ConfigProvider.to.locale.value.languageCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
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
                SettingsSection(tiles: [
                  SettingsTile(
                    title: Text('Language'.tr),
                    value: Text(
                      LanMap[ConfigProvider.to.locale.value.languageCode]!,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    // leading: Icon(Icons.language),
                    onPressed: (BuildContext context) {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return LanRow(
                              current: currentLanCode,
                            );
                          });
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
                          child: Text('Login'.tr,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 17))),
                      onPressed: (BuildContext context) async {
                        Get.toNamed(Routes.LOGIN);
                      }),
                ]),
              ],
            )));
  }
}
