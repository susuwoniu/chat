import 'package:get/get.dart';

class StartController extends GetxController {
  final isInit = false.obs;

  @override
  void onReady() {
    super.onReady();
    startCountdownTimer();
  }

  // 获取欢迎页面数据
  Future startCountdownTimer() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      isInit.value = true;
    });
  }
}
