import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarSave extends StatelessWidget {
  final bool isActived;
  final Function onPressed;

  AppBarSave({
    Key? key,
    required this.isActived,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return TextButton(
        onPressed: () {
          onPressed();
        },
        style: ButtonStyle(splashFactory: NoSplash.splashFactory),
        child: Container(
          child: Text("Save".tr,
              style: TextStyle(
                  fontSize: 15,
                  color: isActived
                      ? Theme.of(context).colorScheme.onPrimary
                      : Colors.black38)),
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isActived ? Colors.blue : Colors.black12,
          ),
        ));
  }
}
