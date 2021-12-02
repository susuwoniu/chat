import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_info_controller.dart';

class DatePicker extends GetView<EditInfoController> {
  final bool isShowDatePicker;
  // final Function onPressed;

  DatePicker({
    Key? key,
    required this.isShowDatePicker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    // return Container(
    //   height: 216,
    //   padding: const EdgeInsets.only(top: 6.0),
    //   color: CupertinoColors.white,
    //   child: GestureDetector(
    //     // Blocks taps from propagating to the modal sheet and popping.
    //     child: SafeArea(
    //       top: false,
    //       child: isShowDatePicker
    //           ? CupertinoDatePicker(
    //               mode: CupertinoDatePickerMode.dateAndTime,
    //               initialDateTime: dateTime,
    //               onDateTimeChanged: (DateTime newDateTime) {
    //                 // if (mounted) {
    //                 //   print("Your Selected Date: ${newDateTime.day}");
    //                 //   setState(() => dateTime = newDateTime);
    //                 // }
    //               },
    //             )
    //           : SizedBox.shrink(),
    //     ),
    //   ),
    // );

    return isShowDatePicker
        ? Container(
            height: _height * 0.4,
            padding: const EdgeInsets.only(top: 6.0),
            color: CupertinoColors.white,
            child: SafeArea(
              top: false,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime(1969, 1, 1),
                  onDateTimeChanged: (DateTime newDateTime) {
                    // Do something
                  }),
            ),
          )
        : SizedBox.shrink();
  }
}
