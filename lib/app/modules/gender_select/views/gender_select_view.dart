import 'package:flutter/material.dart' hide YearPicker;
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import '../../edit_info/controllers/edit_info_controller.dart';
import '../controllers/gender_select_controller.dart';
import 'gender_picker.dart';
import '../../edit_info/views/year_picker.dart';

class GenderSelectView extends GetView<GenderSelectController> {
  final _editInfoController = EditInfoController.to;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('GenderSelect'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: _width * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('I_am'.tr,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 17.0)),
                        Obx(() => GenderPicker(
                              selectedGender: controller.selectedGender.value,
                              setGender: controller.setGender,
                            )),
                      ],
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            'I_was_born_in'.tr,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 17.0),
                          ),
                        ),
                        YearPicker(
                            isShowBar: false,
                            onChanged: (year) {
                              controller.setBirthYear(year.toString());
                            })
                      ]),
                ]),
                GestureDetector(
                  onTap: () async {
                    try {
                      await _editInfoController.postChange({
                        "birthday": controller.birthYear.value + "-01-01",
                        "gender": controller.selectedGender.value
                      });
                      UIUtils.toast('ok');
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                  child: Container(
                    height: _height * 0.07,
                    width: _width * 0.95,
                    margin: EdgeInsets.only(bottom: _height * 0.06),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    alignment: Alignment.center,
                    child: Text('Find_Friends'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
