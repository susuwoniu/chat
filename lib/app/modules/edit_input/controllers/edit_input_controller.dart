import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/types/types.dart';

class EditInputController extends GetxController {
  static EditInputController get to => Get.find();
  final isShowClear = true.obs;
  final isActived = false.obs;
  final initialContent = Get.arguments['content'];

  final textController =
      TextEditingController(text: Get.arguments['content'] ?? 'null');

  final count = 0.obs;
  @override
  void onInit() {
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

  Future<void> postChange(String title, String content) async {
    final body =
        await APIProvider().patch("/account/me", body: {title: content});
    final account = AccountEntity.fromJson(body["data"]["attributes"]).obs;
    await AuthProvider.to.saveAccount(account);
  }
}
