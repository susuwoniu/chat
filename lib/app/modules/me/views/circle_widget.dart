import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  final Widget icon;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? iconSize;
  final Color? backgroundColor;
  final void Function() onPressed;

  CircleWidget({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.borderRadius = 20,
    this.height = 40,
    this.width = 40,
    this.iconSize = 22,
    this.backgroundColor = Colors.black26,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius!),
      ),
      child: IconButton(
        icon: icon,
        padding: EdgeInsets.all(0),
        iconSize: iconSize!,
        onPressed: onPressed,
      ),
    );
  }
}
