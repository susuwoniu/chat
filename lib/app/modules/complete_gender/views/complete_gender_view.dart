import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/complete_gender_controller.dart';

class CompleteGenderView extends GetView<CompleteGenderController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CompleteGenderView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'CompleteGenderView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
