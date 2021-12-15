import 'package:flutter/material.dart' hide YearPicker;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/providers/providers.dart';
import '../controllers/edit_info_controller.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'image_list.dart';
import 'edit_row.dart';
import 'year_picker.dart';

class EditInfoView extends GetView<EditInfoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('EditInfoView'),
          centerTitle: true,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
              color: HexColor("#f0eff4"),
              child: Obx(() {
                final _account = AuthProvider.to.account.value;
                final _bio = _account.bio == '' ? 'nothing' : _account.bio;
                // final _location = _account.location ?? 'unknown place';
                final _birthday = _account.birthday ?? 'xxxx-xx-xx';

                return Column(children: [
                  ImageList(),
                  Container(height: 0.3, color: Colors.black26),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    color: Colors.white,
                    child: Column(children: [
                      EditRow(
                        title: "name".tr,
                        content: _account.name,
                        onPressed: () {
                          Get.toNamed(Routes.EDIT_NAME, arguments: {
                            "action": 'add_account_name',
                            "mode": "back"
                          });
                        },
                      ),
                      EditRow(
                        title: "gender".tr,
                        content: _account.gender,
                        onPressed: () {
                          Get.toNamed(Routes.GENDER_SELECT,
                              arguments: {"mode": "back"});
                        },
                      ),
                      EditRow(
                        title: "bio".tr,
                        content: _bio!,
                        onPressed: () {
                          Get.toNamed(Routes.EDIT_BIO, arguments: {
                            "action": 'add_account_bio',
                            "mode": "back"
                          });
                        },
                      ),
                      // EditRow(
                      //   title: "location".tr,
                      //   content: _location,
                      //   onPressed: () {
                      //     Get.toNamed(Routes.AGE_PICKER, arguments: {"mode": "back"});
                      //   },
                      // ),
                      EditRow(
                        title: "birth".tr,
                        content: _birthday.substring(0, 4),
                        onPressed: () {
                          controller.setIsShowYearPicked(true);
                          showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return YearPicker(
                                  onSelect: (year) async {
                                    try {
                                      await AccountProvider.to
                                          .postAccountInfoChange({
                                        "birthday": year.toString() + "-01-01"
                                      });
                                      Navigator.pop(context);
                                    } catch (e) {
                                      Navigator.pop(context);
                                      UIUtils.showError(e);
                                    }
                                  },
                                  isShowBar: true,
                                );
                              });
                        },
                      ),
                    ]),
                  ),
                ]);
              })),
        )));
  }
}
