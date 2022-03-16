import 'package:flutter/material.dart';
import 'package:chat/common.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/common/link.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

class SectionWidget extends AbstractSettingsSection {
  final InAppReview inAppReview = InAppReview.instance;

  SectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
        margin:
            EdgeInsetsDirectional.only(top: 20, start: 16, end: 16, bottom: 0),
        title: Text('Old School'.tr),
        tiles: [
          SettingsTile(
              title: Text('Clear_Cache'.tr),
              onPressed: (BuildContext context) {
                CacheProvider.to.clear();
              }),
          SettingsTile(
              title: Text('Help&Feedback'.tr),
              onPressed: (BuildContext context) {
                Get.toNamed(Routes.FEEDBACK);
              }),
          SettingsTile(
              title: Text('rate_us_on_app_store'.tr),
              onPressed: (BuildContext context) async {
                if (await inAppReview.isAvailable()) {
                  // inAppReview.requestReview();
                }
              }),
          SettingsTile(
              title: Text('share'.tr),
              onPressed: (BuildContext context) async {
                Navigator.pop(context);
                final FlutterShareMe flutterShareMe = FlutterShareMe();
                // TODO right share url
                final response =
                    await flutterShareMe.shareToSystem(msg: "test");
                print(response);
              }),
          SettingsTile(
              title: Text('user_agreement'.tr),
              onPressed: (BuildContext context) async {
                await openLink(USER_AGREEMENT);
              }),
        ]);
  }
}
