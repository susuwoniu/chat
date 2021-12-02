import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_info_controller.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';

class DatePicker extends GetView<EditInfoController> {
  final bool isShowDatePicker;
  final Function(DateTime newTime) onChangeNewDate;

  DatePicker(
      {Key? key, required this.isShowDatePicker, required this.onChangeNewDate})
      : super(key: key);
  final int _initialYear = DateTime.parse(DateTime.now().toString()).year;
  // var _initialMonth =
  //     DateTime.parse(DateTime.now().toString()).month.toString();
  // var _initialDate = DateTime.parse(DateTime.now().toString()).day.toString();
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    // if (_initialMonth.length < 2) {
    //   _initialMonth = "0" + _initialMonth;
    // }
    // if (_initialDate.length < 2) {
    //   _initialDate = "0" + _initialDate;
    // }
    // final _initialtime = DateTime.parse(
    //     "$_initialYear-$_initialMonth-$_initialDate 00:00:00.000");

    return isShowDatePicker
        ? Stack(children: [
            Container(
                height: _height * 0.35,
                padding: const EdgeInsets.only(top: 35),
                color: CupertinoColors.white,
                child: GestureDetector(
                  // Blocks taps from propagating to the modal sheet and popping.
                  onTap: () {},
                  child: SafeArea(
                    top: false,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        maximumYear: _initialYear,
                        minimumYear: _initialYear - 80,
                        onDateTimeChanged: (DateTime newDateTime) {
                          onChangeNewDate(newDateTime);
                        }),
                  ),
                )),
            Container(
              margin: EdgeInsets.fromLTRB(15, 6, 0, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close_rounded)),
                  TextButton(
                      onPressed: () async {
                        try {
                          await controller.postChange(
                              "birthday", controller.datePicked);
                          Navigator.pop(context);
                          UIUtils.toast('ok');
                        } catch (e) {
                          Navigator.pop(context);
                          UIUtils.showError(e);
                        }
                      },
                      child: Text(
                        '确认',
                        style: TextStyle(fontSize: 13),
                      )),
                ],
              ),
            ),
          ])
        : SizedBox.shrink();
  }
}
