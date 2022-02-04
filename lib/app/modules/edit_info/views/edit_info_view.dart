import 'package:flutter/material.dart' hide YearPicker;
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import '../controllers/edit_info_controller.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'image_list.dart';
import 'year_picker.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/services.dart';

class EditInfoView extends GetView<EditInfoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        appBar: AppBar(
          title: Text('EditInfoView'.tr, style: TextStyle(fontSize: 18)),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Colors.grey.shade400,
              ),
              preferredSize: Size.fromHeight(0)),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
              color: Color(0xfff0eff4),
              child: Obx(() {
                final _account = AuthProvider.to.account.value;
                final _bio =
                    _account.bio == '' ? 'Nothing...'.tr : _account.bio;
                // final _location = _account.location == ''
                //     ? 'Unknown_place'.tr
                //     : _account.location;
                final _birthday = _account.birthday ?? '????';

                return Column(children: [
                  ImageList(),
                  Container(
                    height: 0.5,
                    color: Colors.grey.shade400,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: Column(children: [
                      SettingsTile(
                          title: "Nickname".tr,
                          subtitle: _account.name,
                          onPressed: (BuildContext context) {
                            Get.toNamed(Routes.EDIT_NAME, arguments: {
                              "action": 'add_account_name',
                              "mode": "back"
                            });
                          }),
                      SettingsTile(
                          title: "gender".tr,
                          subtitle: _account.gender.tr,
                          onPressed: (BuildContext context) {
                            Get.toNamed(Routes.GENDER_SELECT,
                                arguments: {"mode": "back"});
                          }),
                      SettingsTile(
                          title: "Bio".tr,
                          subtitle: _bio!,
                          // subtitleMaxLines: 5,
                          onPressed: (BuildContext context) {
                            Get.toNamed(Routes.EDIT_BIO, arguments: {
                              "action": 'add_account_bio',
                              "mode": "back"
                            });
                          }),
                      // SettingsTile(
                      //     title: "location".tr,
                      //     subtitle: _location,
                      //     onPressed: (BuildContext context) {
                      //       Get.toNamed(Routes.AGE_PICKER,
                      //           arguments: {"mode": "back"});
                      //     }),
                      SettingsTile(
                          title: "birth".tr,
                          titleTextStyle: TextStyle(fontSize: 16),
                          subtitle: _birthday.substring(0, 4),
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
                  ),
                ]);
              })),
        )));
  }
}
