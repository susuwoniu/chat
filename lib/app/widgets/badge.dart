import 'package:flutter/material.dart';
import 'package:chat/app/modules/message/views/unread_count.dart';

class Badge extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onTap;
  final int notificationCount;
  final Color? color;

  const Badge({
    Key? key,
    this.onTap,
    required this.iconData,
    this.notificationCount = 0,
    this.color = const Color(0xff706F73),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 60,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData, size: 32, color: color),
              ],
            ),
            Positioned(
                top: -10,
                left: 35,
                child: CountBubble(count: notificationCount))
          ],
        ),
      ),
    );
  }
}
