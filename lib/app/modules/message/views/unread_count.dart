import 'package:flutter/material.dart';

class CountBubble extends StatelessWidget {
  final int count;
  final String type;

  CountBubble({
    Key? key,
    required this.count,
    this.type = "unreadCount",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    late String text;
    final String countStr = count.toString();

    if (count >= 100) {
      //+99
      text = type == "viewers" ? '+99' : '99+';
    } else {
      //+22
      text = type == "viewers" ? "+" + countStr : countStr;
    }

    return count > 0
        ? count < 10
            ? Container(
                alignment: Alignment.center,
                width: type == "viewers" ? 22 : 20,
                height: type == "viewers" ? 22 : 20,
                decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(20)),
                child: TextCount(text))
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(20)),
                child: TextCount(text))
        : SizedBox.shrink();
  }

  Widget TextCount(String count) {
    return Text(count,
        style: TextStyle(
            fontSize: count.length > 2 ? 10 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white));
  }
}
