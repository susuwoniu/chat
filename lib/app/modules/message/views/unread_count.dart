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
            alignment: Alignment.center,
            // padding: EdgeInsets.all(1),
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red[400],
            ),
            child: Text(unreadCount.toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          )
        : SizedBox.shrink();
  }
}
