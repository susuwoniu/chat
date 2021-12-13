import 'package:flutter/material.dart';

class LikeCount extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final double? fontSize;
  final double? iconSize;

  LikeCount(
      {Key? key,
      required this.text,
      this.backgroundColor = Colors.black38,
      this.fontSize = 19,
      this.iconSize = 19})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 70,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(children: [
          Icon(
            Icons.favorite_rounded,
            size: iconSize,
            color: Colors.pink.shade300,
          ),
          SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.pink.shade300,
                  fontWeight: FontWeight.bold))
        ]),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(16)));
  }
}
