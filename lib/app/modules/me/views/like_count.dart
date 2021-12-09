import 'package:flutter/material.dart';

class LikeCount extends StatelessWidget {
  final String text;

  LikeCount({
    Key? key,
    required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        child: Row(children: [
          Text('💗', style: TextStyle(fontSize: 18)),
          SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold))
        ]),
        decoration: BoxDecoration(
            color: Colors.black38, borderRadius: BorderRadius.circular(16)));
  }
}
