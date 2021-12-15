import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();
  final countryCode = ''.obs;
  final phoneNumber = ''.obs;
  final isNumberValid = false.obs;
  final verificationCode = ''.obs;
  @override
  onInit() {
    super.onInit();
  }

  @override
  onClose() {
    super.onClose();
  }

  // 发送验证码
  handleSendCode() async {
    await AccountProvider.to
        .handleSendCode(countryCode.value, phoneNumber.value);
  }

  setPhoneNumber(String _phoneNumber, String _countryCode) {
    phoneNumber.value = _phoneNumber.substring(_countryCode.length);
    if (_countryCode == ("+86")) {
      isNumberValid.value = isPhoneNumberValid(phoneNumber.value);
    }
  }

  setCountryCode(String _countryCode) {
    countryCode.value = _countryCode;
  }

  bool isPhoneNumberValid(String number) {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool result = exp.hasMatch(number);
    return result;
  }

  setVerificationCode(String code) {
    verificationCode.value = code;
  }
}
