import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/test1_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Test1View extends GetView<Test1Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
        // child: TextField()
        child: PinCodeTextField(
          appContext: context,
          length: 4,
          obscureText: false,
          onChanged: (value) {
            print(value);
          },
        ),
      )),
    );
  }
}
