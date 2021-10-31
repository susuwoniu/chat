import 'package:get/get.dart';

class RootController extends GetxController {
  //TODO: Implement RootController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  final isInit = false.obs;

  @override
  void onReady() {
    super.onReady();
    initData();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  // 初始化数据
  Future initData() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      isInit.value = true;
    });
  }
}
