import 'package:flutter/material.dart';

class CountBubble extends StatelessWidget {
  final int count;
  final bool isUnreadMessage;

  CountBubble({
    Key? key,
    required this.count,
    this.isUnreadMessage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String text;
    final String countStr = count.toString();

    if (count >= 100) {
      //+99
      text = isUnreadMessage ? '99+' : '+99';
    } else {
      //+22
      text = isUnreadMessage ? countStr : "+" + countStr;
    }

    return count > 0
        ? count < 10
            ? Container(
                alignment: Alignment.center,
                width: isUnreadMessage ? 20 : 22,
                height: isUnreadMessage ? 20 : 22,
                decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(20)),
                child: TextCount(text, context: context))
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(20)),
                child: TextCount(text, context: context))
        : SizedBox.shrink();
  }

  Widget TextCount(String count, {required BuildContext context}) {
    return Text(count,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimary));
  }
}
