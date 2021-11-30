import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Root'),
        centerTitle: true,
      ),
      body: Column(children: [
        Text(
          'RootView is working1',
          style: TextStyle(fontSize: 20),
        ),
        TextButton(
            onPressed: () {
              controller.clearAll();
            },
            child: Text("clear all"))
      ]),
    );
  }
}
