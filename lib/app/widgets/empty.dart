import 'package:flutter/material.dart';

Widget Empty({
  String message = "这里什么也没有～",
}) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.error_outline, size: 50),
        SizedBox(
          height: 20,
        ),
        Text(
          message,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
