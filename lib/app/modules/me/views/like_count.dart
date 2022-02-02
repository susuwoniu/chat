import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../../home/views/vip_sheet.dart';
import 'package:get/get.dart';

class LikeCount extends StatelessWidget {
  final int count;
  final Color? backgroundColor;
  final double? fontSize;
  final double? iconSize;

  LikeCount(
      {Key? key,
      required this.count,
      this.backgroundColor = Colors.black38,
      this.fontSize = 18,
      this.iconSize = 18})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (AuthProvider.to.account.value.vip) {
            Get.toNamed(Routes.LIKEDME);
          } else {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                enableDrag: false,
                builder: (context) {
                  return VipSheet(context: context, index: 1);
                });
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(children: [
            Icon(
              Icons.favorite_rounded,
              size: iconSize,
              color: Colors.pink.shade300,
            ),
            SizedBox(width: 4),
            Text(count > 99999 ? '99999+' : count.toString(),
                style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.pink.shade300,
                    fontWeight: FontWeight.bold))
          ]),
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(16)),
        ));
  }
}
