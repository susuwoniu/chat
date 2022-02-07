import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../../home/views/vip_sheet.dart';
import 'package:get/get.dart';
import 'package:chat/app/modules/message/views/unread_count.dart';

class MeIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final int? newViewers;
  final bool isMe;
  final void Function()? onPressed;
  final bool toViewers;

  MeIcon({
    Key? key,
    required this.icon,
    required this.text,
    this.newViewers,
    this.isMe = false,
    this.onPressed,
    this.toViewers = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        GestureDetector(
            onTap: () {
              if (isMe) {
                if (AuthProvider.to.account.value.vip) {
                  Get.toNamed(Routes.LIKEDME);
                } else {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return VipSheet(context: context, index: 1);
                      });
                }
              } else if (toViewers) {
                onPressed!();
              }
            },
            child: Stack(clipBehavior: Clip.none, children: [
              Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 2.5,
                          color: Theme.of(context).colorScheme.onSurface)),
                  child: Icon(icon,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 27)),
              newViewers == null
                  ? SizedBox.shrink()
                  : Positioned(
                      right: -4,
                      top: -6,
                      child: CountBubble(
                          count: newViewers!, isUnreadMessage: false))
            ])),
        SizedBox(height: 10),
        Text(
          text,
          style: TextStyle(color: Color(0xff686A6D)),
        )
      ],
    ));
  }
}
