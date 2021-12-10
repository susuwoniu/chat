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
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            color: Colors.red[400],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Text(unreadCount < 100 ? unreadCount.toString() : "99+",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ))
        : SizedBox.shrink();
  }
}
