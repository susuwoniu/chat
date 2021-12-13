import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/types/types.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();
  final countryCode = ''.obs;
  final phoneNumber = ''.obs;
  final isNumberValid = false.obs;
  final verificationCode = ''.obs;
  @override
  onInit() {
    if (Get.arguments != null) {
      final data = Get.arguments as Map<String, dynamic>;
      if (data['next'] != null) {
        RouterProvider.to.setNextPage(
          data['next'],
        );
      }
    }

    super.onInit();
  }

  // 发送验证码
  handleSendCode() async {
    await APIProvider().post("/account/phone-codes/$countryCode/$phoneNumber",
        body: {"timezone_in_seconds": 28800, "device_id": "ttttt"},
        options: ApiOptions(withSignature: true, withAuthorization: false));
  }

  // 执行登录操作
  handleLogin({int? closePageCount}) async {
    final body = await APIProvider().post(
        "/account/phone-sessions/$countryCode/$phoneNumber/${verificationCode.value}",
        body: {"timezone_in_seconds": 28800, "device_id": "ttttt"},
        options: ApiOptions(
            withSignature: true,
            checkDataAttributes: true,
            withAuthorization: false));
    final token = TokenEntity.fromJson(body["data"]["attributes"]);
    final account = AuthProvider.to.formatTokenAccount(body);
    // login im service

    await AuthProvider.to.saveToken(token);
    await AuthProvider.to.init();
    if (closePageCount != null && closePageCount > 0) {
      Get.close(closePageCount);
    }
    await AuthProvider.to.saveAccount(account);

    // Get.offAndToNamed(AppRoutes.Application);
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

  // 执行登录操作
  getMe() async {
    final _ = await APIProvider().get(
      "/account/me",
    );

    // Get.offAndToNamed(AppRoutes.Application);
  }

  handleLogout() async {
    await APIProvider().delete("/account/sessions");
    await AuthProvider.to.cleanToken();
    // await ImProvider.to.logout();
  }

  handleCleanAccessToken() async {
    await AuthProvider.to.cleanAccessToken();
  }

  Future<void> postAccountInfoChange(Map<String, dynamic> data) async {
    final body = await APIProvider().patch("/account/me", body: data);
    final account = AuthProvider.to.formatMainAccount(body);

    await AuthProvider.to.saveAccount(account);
  }
}
