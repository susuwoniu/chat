import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../../home/views/vip_sheet.dart';
import 'package:get/get.dart';

class LikeCount extends StatelessWidget {
  final int count;
  final Color? backgroundColor;
  final double fontSize;
  final double iconSize;
  final bool? isMe;
  final bool? isLiked;
  final Function? onTap;

  LikeCount(
      {Key? key,
      required this.count,
      this.backgroundColor = Colors.black54,
      this.isMe,
      this.isLiked,
      this.onTap,
      this.fontSize = 17,
      this.iconSize = 17})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (onTap != null && isMe != null) {
            if (!isMe!) {
              onTap!();
            }
          }
        },
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: 8, vertical: fontSize * 0.1),
          child: Row(children: [
            Icon(
              Icons.favorite_rounded,
              size: iconSize,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 4),
            Text(count > 99999 ? '99999+' : count.toString(),
                style: TextStyle(
                    fontSize: fontSize,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold))
          ]),
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(16)),
        ));
  }
}
