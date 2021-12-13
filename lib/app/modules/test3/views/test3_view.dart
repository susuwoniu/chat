import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/test3_controller.dart';

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
          Container(
              height: 100, width: 100, color: Colors.red, child: Text("2222"))
        ]));
  }
}
