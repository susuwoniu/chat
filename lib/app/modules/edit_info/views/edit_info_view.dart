import 'package:flutter/material.dart' hide YearPicker;
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import '../controllers/edit_info_controller.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'image_list.dart';
import 'year_picker.dart';

class EditInfoView extends GetView<EditInfoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.onPrimary,
        appBar: AppBar(
          title: Text('EditInfoView'.tr, style: TextStyle(fontSize: 16)),
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
        ),
        body: SingleChildScrollView(
          child: Container(child: Obx(() {
            final _account = AuthProvider.to.account.value;
            final _bio = _account.bio == '' ? 'Nothing...'.tr : _account.bio;
            print("_bio: $_bio");
            // final _location = _account.location == ''
            //     ? 'Unknown_place'.tr
            //     : _account.location;
            final _birthday = _account.birthday ?? '????';

            return Column(children: [
              ImageList(),
              Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                // color: Theme.of(context).colorScheme.onPrimary,
                child: Column(children: [
                  ListTile(
                      title: Text("Nickname".tr),
                      trailing: Text(_account.name),
                      onTap: () {
                        Get.toNamed(Routes.EDIT_NAME,
                            arguments: {"mode": "back"});
                      }),
                  ListTile(
                      title: Text("gender".tr),
                      trailing: Text(_account.gender.tr),
                      onTap: () {
                        Get.toNamed(Routes.GENDER_SELECT, arguments: {
                          "mode": "back",
                          "current-value": _account.gender
                        });
                      }),
                  ListTile(
                      title: Text("Bio".tr),
                      subtitle: Container(
                          child: Text(
                        _bio ?? "",
                        // maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      // subtitleMaxLines: 5,
                      onTap: () {
                        Get.toNamed(Routes.EDIT_BIO,
                            arguments: {"mode": "back"});
                      }),
                  ListTile(
                      title: Text("birth".tr, style: TextStyle(fontSize: 16)),
                      trailing: Text(_birthday.substring(0, 4)),
                      onTap: () {
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
        ));
  }
}
