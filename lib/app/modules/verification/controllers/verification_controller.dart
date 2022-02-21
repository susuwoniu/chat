import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/common.dart';
import 'package:chat/app/common/get_device_id.dart';

class VerificationController extends GetxController {
  //TODO: Implement VerificationController
  static VerificationController get to => Get.find();
  final verificationCode = AppConfig.to.isDev ? "123456".obs : ''.obs;

  final count = 0.obs;
  final countryCode = Get.arguments['countryCode'];
  final phoneNumber = Get.arguments['phoneNumber'];
  final isShowCount = true.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  // 发送验证码
  handleSendCode() async {
    final deviceId = await getDeviceId() ?? '';

    await AccountProvider.to.handleSendCode(
        countryCode: countryCode, phoneNumber: phoneNumber, deviceId: deviceId);
  }

  setVerificationCode(String code) {
    verificationCode.value = code;
  }

  void increment() => count.value++;

  setShowCount(bool show) {
    isShowCount.value = show;
  }
}
