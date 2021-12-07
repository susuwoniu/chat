import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/providers/auth_provider.dart';

class EditNameController extends GetxController {
  static EditNameController get to => Get.find();

  final isShowClear = true.obs;
  final isActived = false.obs;
  late String initialContent;
  final currentTitle = Get.arguments["action"];

  final textController = TextEditingController(text: '');

  late String title;

  final count = 0.obs;
  @override
  void onInit() {
    if (currentTitle == 'add_account_name') {
      initialContent = AuthProvider.to.account.value.name;
      title = "name";
    } else if (currentTitle == 'add_account_bio') {
      initialContent = AuthProvider.to.account.value.bio ?? '';
      title = "bio";
    } else {
      // TODO
      initialContent = '';
    }
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
