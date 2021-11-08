import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';

import '../controllers/test3_controller.dart';
import 'package:chat/app/widges/max_text.dart';

class Test3View extends GetView<Test3Controller> {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.blue;

    var path = Path();
    path.lineTo(-10, 0);
    path.lineTo(0, 10);
    path.lineTo(10, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(100),
        child: Column(children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text("your message goes here"),
          ),
        ]));
  }
}
