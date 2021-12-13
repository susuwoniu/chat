import 'package:flutter/material.dart';

class UnreadCount extends StatelessWidget {
  final int unreadCount;

  UnreadCount({
    Key? key,
    required this.unreadCount,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return unreadCount > 0
        ? unreadCount < 10
            ? Container(
                alignment: Alignment.center,
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(20)),
                child: TextWidget(unreadCount.toString()))
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(20)),
                child: TextWidget(
                  unreadCount < 100 ? unreadCount.toString() : "99+",
                ))
        : SizedBox.shrink();
  }

  Widget TextWidget(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white));
  }
}
