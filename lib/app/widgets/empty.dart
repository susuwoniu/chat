import 'package:flutter/material.dart';

Widget Empty({
  String message = "这里什么也没有～",
}) {
  return Container(
    margin: EdgeInsets.only(top: 50),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(Icons.error_outline, size: 40, color: Colors.grey.shade500),
        SizedBox(
          height: 20,
        ),
        Text(
          message,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
