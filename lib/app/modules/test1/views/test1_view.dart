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
          height: 320.0,
          width: 300.0,
          color: Colors.red,
          child: Stack(
            children: [
              Text("left text"),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("bottom")],
                ),
              )
            ],
          ),
        ));
  }
}
