import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NextButton extends StatelessWidget {
  final String? action;
  final String? text;
  final double? height;
  final double? width;
  final double? size;
  final Color? textColor;
  final double? borderRadius;
  final void Function() onPressed;

  NextButton({
    Key? key,
    this.action,
    required this.onPressed,
    this.height,
    this.width,
    this.text,
    this.size,
    this.textColor,
    this.borderRadius,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: height ?? _height * 0.07,
        width: width ?? _width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          color: Colors.black87,
        ),
        alignment: Alignment.center,
        child: Text(text != null ? text!.tr : 'Next'.tr,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size ?? 19,
                color: textColor ?? Colors.white)),
      ),
    );
  }
}
