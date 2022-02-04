import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AboutView',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Center(
        child: Text(
          'AboutView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
