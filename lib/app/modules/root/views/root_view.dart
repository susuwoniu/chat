import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/root_controller.dart';
import 'package:chat/common.dart';

class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Obx(() {
        final isLoading = controller.isLoading;
        final isInit = controller.isInit;
        final error = controller.error;
        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (isInit) {
          return Text("ready");
        } else if (error != null) {
          return Retry(onRetry: () {}, message: error);
        } else {
          return Text("");
        }
      }),
    ));
  }
}
