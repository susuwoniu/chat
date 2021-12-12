import 'package:flutter/material.dart';

Widget Retry({
  String message = "出了点问题",
  required Function onRetry,
}) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("ℹ️", style: TextStyle(fontSize: 50)),
        SizedBox(
          height: 20,
        ),
        Text(
          message,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          child: Text(
            '🔄 刷新看看',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onPressed: () {
            onRetry();
          },
        ),
      ],
    ),
  );
}
