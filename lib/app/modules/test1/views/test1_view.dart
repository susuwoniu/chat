import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/test1_controller.dart';

class Test1View extends GetView<Test1Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test1View'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Test1View is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
