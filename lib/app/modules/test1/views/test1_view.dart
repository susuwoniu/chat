import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/test1_controller.dart';

class Test1View extends GetView<Test1Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test1View2'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blue,
        width: 300.0,
        height: 200.0,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text("Whee"),
        ),
      ),
    );
  }
}
