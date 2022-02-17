import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../../home/views/vip_sheet.dart';
import 'package:get/get.dart';
import 'package:chat/app/modules/message/views/unread_count.dart';
import 'package:timer_count_down/timer_count_down.dart';

class MeIcon extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  final bool isMe;
  final bool isLiked;
  final Function? onPressedLike;
  final Function? onPressedChat;
  final Function? onPressedStar;
  // final void Function()? onPressedViewer;
  // final int? newViewers;
  // final bool toViewers;
  // final int? time;

  MeIcon({
    Key? key,
    required this.icon,
    this.iconSize = 27,
    this.text = "",
    this.isMe = false,
    this.isLiked = false,
    this.onPressedLike,
    this.onPressedChat,
    this.onPressedStar,
    // this.onPressedViewer,
    // this.toViewers = false,
    // this.newViewers,
    // this.time,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
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
        } else if (onPressedLike != null) {
          onPressedLike!(!isLiked);
        } else if (onPressedStar != null) {
          onPressedStar!();
        } else if (onPressedChat != null) {
          onPressedChat!();
        }
        // else if (toViewers) {
        //   onPressedViewer!();
        // }
      },
      child: Column(children: [
        Stack(clipBehavior: Clip.none, children: [
          Container(
              width: 44,
              height: 44,
              // padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 2.5,
                      color: isLiked == true
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface)),
              child: Icon(icon,
                  color: isLiked == true
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  size: iconSize)),
          // newViewers == null
          //     ? SizedBox.shrink()
          //     : Positioned(
          //         left: 28,
          //         top: -6,
          //         child:
          //             CountBubble(count: newViewers!, isUnreadMessage: false))
        ]),
        SizedBox(height: 10),
        Text(
          text == "" ? 'Create_Post'.tr : text,
          style: TextStyle(color: Color(0xff686A6D)),
        ),
        //  Countdown(
        //     seconds: time!.toInt(),
        //     build: (BuildContext context, double time) {
        //       return Text(getCountDown(time),
        //           style: TextStyle(color: Color(0xff686A6D)));
        //     },
        //     interval: Duration(milliseconds: 1000),
        //     onFinished: () {
        //       AuthProvider.to.account.update((value) {
        //         if (value != null) {
        //           value.is_can_post = true;
        //         }
        //       });
        //     },
        //   )
      ]),
    ));
  }

  getCountDown(double time) {
    int h, m, s;

    h = time ~/ 3600;

    m = ((time - h * 3600)) ~/ 60;

    s = time.toInt() - (h * 3600) - (m * 60);
    // String hourLeft =
    //     h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();

    // String result = "$hourLeft:$minuteLeft:$secondsLeft";
    String result = "$minuteLeft:$secondsLeft";

    return result;
  }
}
