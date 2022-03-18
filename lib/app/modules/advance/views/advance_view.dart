import 'package:chat/app/providers/push_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:chat/common.dart';
import '../controllers/advance_controller.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:clipboard/clipboard.dart';

final LanMap = {'en': 'English', 'zh': 'Simplified-Chinese'.tr};

class AdvanceView extends GetView<AdvanceController> {
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
          title:
              Text('experimental_feature'.tr, style: TextStyle(fontSize: 16)),
        ),
        body: Obx(() => SettingsList(
              darkTheme: SettingsThemeData(
                  settingsListBackground: Theme.of(context).backgroundColor,
                  settingsSectionBackground:
                      Theme.of(context).colorScheme.surface),
              sections: [
                SettingsSection(
                    margin: EdgeInsetsDirectional.only(
                        top: 15, start: 16, end: 16, bottom: 0),
                    title: Text('experimental_feature'.tr),
                    tiles: [
                      SettingsTile.switchTile(
                          initialValue: ConfigProvider.to.skipViewedPost.value,
                          activeSwitchColor:
                              Theme.of(context).colorScheme.primary,
                          title: Text('Skip Viewed Posts?'.tr),
                          onToggle: (bool value) {
                            print("value $value");
                            ConfigProvider.to.toggleSkipViewedPost();
                          }),
                      if (AuthProvider.to.isLogin)
                        SettingsTile(
                            title: Text('Disable Chat Notification'.tr),
                            onPressed: (BuildContext context) async {
                              try {
                                await ChatProvider.to.pushManager
                                    ?.disablePush();
                                UIUtils.toast("已禁用聊天推送");
                              } catch (e) {
                                UIUtils.showError(e);
                              }
                            }),
                      if (AuthProvider.to.isLogin)
                        SettingsTile(
                            title: Text('Enable Chat Notification'.tr),
                            onPressed: (BuildContext context) async {
                              PushProvider.to.jpush
                                  .getRegistrationID()
                                  .then((id) {
                                final push_service =
                                    GetPlatform.isIOS ? 'apns' : 'fcm';
                                ChatProvider.to.pushManager?.initPush(
                                    service: push_service,
                                    deviceId: id,
                                    mode: AppConfig.to.isDev ? 'dev' : 'prod');
                              });
                            }),
                      if (AuthProvider.to.isLogin)
                        SettingsTile(
                          title: Text(
                            'Copy Account ID'.tr +
                                '：  ${AuthProvider.to.accountId}',
                          ),
                          onPressed: (BuildContext context) async {
                            // copy
                            await FlutterClipboard.copy(
                                AuthProvider.to.accountId ?? "");
                            UIUtils.toast("已复制");
                          },
                        ),
                      if (AuthProvider.to.isLogin)
                        SettingsTile(
                            title: Text('Clear all Notifications'.tr),
                            onPressed: (BuildContext context) async {
                              try {
                                PushProvider.to.jpush.clearAllNotifications();
                                UIUtils.toast("清除成功");
                              } catch (e) {
                                UIUtils.showError(e);
                              }
                            }),
                    ]),
              ],
            )));
  }
}
