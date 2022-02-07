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
    this.backgroundColor = Colors.black38,
    this.iconColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final finalIconColor = iconColor ?? Theme.of(context).colorScheme.onPrimary;
    return Container(
      width: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: icon,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.all(0),
        color: finalIconColor,
        iconSize: iconSize!,
        onPressed: onPressed,
      ),
    );
  }
}
