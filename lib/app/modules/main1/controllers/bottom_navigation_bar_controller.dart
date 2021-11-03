import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarController extends GetxController {
  static BottomNavigationBarController get to => Get.find(); // add this line
  final backgroundColor = RxString("");

  @override
  void onInit() {
    super.onInit();
  }

  final isInit = false.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void changeBackgroundColor(String value) {
    if (value.isNotEmpty) {
      backgroundColor.value = value;
    }
  }
}
