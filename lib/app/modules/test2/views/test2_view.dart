import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';

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
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  Get.toNamed(Routes.TEST3);
                },
                child: Text("Test1")),
            TextButton(
                onPressed: () {
                  Get.offAllNamed(Routes.MAIN);
                },
                child: Text("Main")),
            Text(
              'Test2View is working',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
