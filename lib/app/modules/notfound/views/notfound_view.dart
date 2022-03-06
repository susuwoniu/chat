import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notfound_controller.dart';

class NotfoundView extends GetView<NotfoundController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('NotfoundView'),
      ),
      body: Center(
        child: Text(
          'NotfoundView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
