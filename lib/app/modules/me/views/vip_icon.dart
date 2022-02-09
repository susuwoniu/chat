import 'package:flutter/material.dart';

class VipIcon extends StatelessWidget {
  final double? iconSize;

  VipIcon({Key? key, this.iconSize = 23}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(Icons.stars_rounded,
            color: Theme.of(context).colorScheme.primary, size: iconSize));
  }
}
