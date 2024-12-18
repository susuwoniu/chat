import 'package:flutter/material.dart';
import '../../message/views/unread_count.dart';
import 'package:get/get.dart';

class ProfileViewersBubble extends StatelessWidget {
  final int totalViewersCount;
  final int newViewersCount;
  final void Function() onPressed;

  ProfileViewersBubble({
    Key? key,
    required this.totalViewersCount,
    required this.newViewersCount,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          child: Column(children: [
            Stack(clipBehavior: Clip.none, children: [
              Positioned(
                  right: newViewersCount > 9 ? -31 : -21,
                  top: -14,
                  child: CountBubble(
                      count: newViewersCount, isUnreadMessage: false)),
              Text(
                  totalViewersCount > 9999
                      ? '9999+'
                      : totalViewersCount.toString(),
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold)),
            ]),
            Text("Visitors".tr,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500))
          ]),
          decoration: BoxDecoration(
              color: Colors.white54, borderRadius: BorderRadius.circular(30)),
        ));
  }
}
