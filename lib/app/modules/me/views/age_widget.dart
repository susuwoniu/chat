import 'package:flutter/material.dart';

class AgeWidget extends StatelessWidget {
  final String text;
  final IconData iconName;
  final double borderRadius;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double iconSize;
  final double fontSize;
  final Color backgroundColor;
  final Color? iconColor;

  AgeWidget({
    Key? key,
    required this.text,
    required this.iconName,
    required this.borderRadius,
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingTop,
    required this.fontSize,
    required this.iconSize,
    required this.backgroundColor,
    this.iconColor = Colors.white,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(
            paddingLeft, paddingTop, paddingRight, paddingTop),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(children: [
          Container(
            padding: EdgeInsets.only(right: 3),
            child: Icon(iconName, color: iconColor, size: iconSize),
          ),
          Text(text,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
              )),
        ]));
  }
}
