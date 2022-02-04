import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NextButton extends StatelessWidget {
  final String? text;
  final void Function() onPressed;

  NextButton({
    Key? key,
    required this.onPressed,
    this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(48),
          splashFactory: NoSplash.splashFactory),
      onPressed: onPressed,
      child: Text(text == null ? 'Next'.tr : text!.tr,
          style: TextStyle(fontSize: 16)),
    );
  }
}
