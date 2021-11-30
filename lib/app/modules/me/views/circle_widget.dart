import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  final Widget icon;
  final double? height;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  final void Function() onPressed;

  CircleWidget({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.height = 40,
    this.iconSize = 22,
    this.backgroundColor = Colors.black26,
    this.iconColor = Colors.white,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: height,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height! / 2),
      ),
      child: IconButton(
        icon: icon,
        color: iconColor,
        padding: EdgeInsets.all(0),
        iconSize: iconSize!,
        onPressed: onPressed,
      ),
    );
  }
}
