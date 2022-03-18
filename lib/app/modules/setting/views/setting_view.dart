import 'package:chat/app/providers/push_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/common.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../controllers/setting_controller.dart';
import 'package:chat/app/providers/providers.dart';
import '../../home_setting/views/lan_row.dart';
import '../../home_setting/views/section_widget.dart';
import '../../home_setting/views/logo_widget.dart';

final LanMap = {'en': 'English', 'zh': 'Simplified-Chinese'.tr};

class SettingView extends GetView<SettingController> {
  @override
  Widget build(BuildContext context) {
    final _account = AuthProvider.to.account.value;
    final currentLanCode = ConfigProvider.to.locale.value.languageCode;

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
                SettingsSection(
                    margin: EdgeInsetsDirectional.only(
                        top: 0, start: 16, end: 16, bottom: 5),
                    title: Text('Account_Security'.tr),
                    tiles: [
                      SettingsTile(
                          title: Text('Phone'.tr),
                          value: Text(_account.phone_number ?? "",
                              style: TextStyle(
                                fontSize: 15,
                              ))),
                    ]),
                SettingsSection(
                    margin: EdgeInsetsDirectional.only(
                        top: 15, start: 16, end: 16, bottom: 0),
                    title: Text('General'.tr),
                    tiles: [
                      SettingsTile(
                          title: Text('Language'.tr),
                          value: Text(
                              LanMap[
                                  ConfigProvider.to.locale.value.languageCode]!,
                              style: TextStyle(
                                fontSize: 15,
                              )),
                          // leading: Icon(Icons.language),
                          onPressed: (BuildContext context) {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return LanRow(
                                    current: currentLanCode,
                                  );
                                });
                          }),
                      SettingsTile.switchTile(
                          initialValue: ConfigProvider.to.nightMode.value,
                          activeSwitchColor:
                              Theme.of(context).colorScheme.primary,
                          title: Text('Night-mode'.tr),
                          onToggle: (bool value) {
                            print("value $value");
                            ConfigProvider.to.toggleNightMode(value);
                          }),
                      SettingsTile(
                          title: Text('push_notification_settings'.tr),
                          onPressed: (BuildContext context) {
                            PushProvider.to.jpush.openSettingsForNotification();
                          }),
                    ]),
                SectionWidget(),
                SettingsSection(
                    margin: EdgeInsetsDirectional.only(
                        top: 15, start: 16, end: 16, bottom: 5),
                    title: Text('pravicy'.tr),
                    tiles: [
                      SettingsTile(
                          title: Text('Blocked_List'.tr),
                          onPressed: (BuildContext context) {
                            Get.toNamed(Routes.BLOCK);
                          }),
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
                          UIUtils.toast("Logged_out".tr);
                          RouterProvider.to.restart(context);
                        } catch (e) {
                          UIUtils.hideLoading();
                          UIUtils.showError(e);
                        }
                      }),
                ]),
                LogonWidget(),
              ],
            )));
  }
}
