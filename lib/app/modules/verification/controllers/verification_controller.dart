import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class VerificationController extends GetxController {
  //TODO: Implement VerificationController
  static VerificationController get to => Get.find();
  final verificationCode = ''.obs;

  final count = 0.obs;
  final countryCode = Get.arguments['countryCode'];
  final phoneNumber = Get.arguments['phoneNumber'];
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  // 发送验证码
  handleSendCode() async {
    await AccountProvider.to.handleSendCode(countryCode, phoneNumber);
  }

  setVerificationCode(String code) {
    verificationCode.value = code;
  }

  void increment() => count.value++;
}
