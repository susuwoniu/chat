import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/providers/auth_provider.dart';

class EditNameController extends GetxController {
  static EditNameController get to => Get.find();

  final isShowClear = true.obs;
  final isActived = false.obs;
  final String initialContent = AuthProvider.to.account.value.name;
  final currentTitle = Get.arguments["action"];

  final textController = TextEditingController(text: '');

  final count = 0.obs;
  @override
  void onInit() {
    textController.text = initialContent;

    super.onInit();
  }

  @override
  void onReady() {
    textController.addListener(() {
      final text = textController.text.trim();
      if (isShowClear.value) {
        if (text.isEmpty) {
          showClear(false);
          setIsActived(false);
        }
      } else {
        if (text.isNotEmpty) {
          showClear(true);
        }
      }

      if (text.isNotEmpty) {
        if (text != initialContent) {
          setIsActived(true);
        } else {
          setIsActived(false);
        }
      }
    });

    super.onReady();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
  void showClear(bool value) {
    isShowClear.value = value;
    isActived.value = !isShowClear.value;
  }

  void setIsActived(bool value) {
    isActived.value = value;
  }
}
