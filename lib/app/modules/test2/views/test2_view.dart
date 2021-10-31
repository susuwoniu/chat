import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/test2_controller.dart';

class Test2View extends GetView<Test2Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test2View'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Test2View is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
