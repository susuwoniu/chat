import 'package:flutter/material.dart';

class AgeWidget extends StatelessWidget {
  final String age;
  final IconData iconName;
  final double borderRadius;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final double iconSize;
  final double fontSize;
  final Color backgroundColor;
  final Color? iconColor;

  AgeWidget({
    Key? key,
    required this.age,
    required this.iconName,
    required this.borderRadius,
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingTop,
    required this.paddingBottom,
    required this.fontSize,
    required this.iconSize,
    required this.backgroundColor,
    this.iconColor = Colors.white,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(
            paddingLeft, paddingTop, paddingRight, paddingBottom),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(children: [
          Container(
            padding: EdgeInsets.only(right: 3),
            child: Icon(iconName, color: iconColor, size: iconSize),
          ),
          Text(age,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
              )),
        ]));
  }
}
