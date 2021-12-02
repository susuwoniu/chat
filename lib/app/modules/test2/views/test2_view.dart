import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';

import '../controllers/test2_controller.dart';

class Test2View extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Test2View> {
  // Value that is shown in the date picker in dateAndTime mode.
  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return _buildBottomPicker(
                CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: dateTime,
                  onDateTimeChanged: (DateTime newDateTime) {
                    if (mounted) {
                      print("Your Selected Date: ${newDateTime.day}");
                      setState(() => dateTime = newDateTime);
                    }
                  },
                ),
              );
            },
          );
        },
        child: Text('show date picker'),
      ),
    );
  }

  double _kPickerSheetHeight = 216.0;
  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}
