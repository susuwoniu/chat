import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/types/types.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  // 发送验证码
  handleSendCode() async {
    await APIProvider().post("/account/phone-codes/86/15523324324",
        body: {"timezone_in_seconds": 28800, "device_id": "ttttt"},
        options: ApiOptions(withSignature: true, withAuthorization: false));
  }

  // 执行登录操作
  handleLogin() async {
    final body = await APIProvider().post(
        "/account/phone-sessions/86/15523324324/123456",
        body: {"timezone_in_seconds": 28800, "device_id": "ttttt"},
        options: ApiOptions(
            withSignature: true,
            checkDataAttributes: true,
            withAuthorization: false));
    final token = TokenEntity.fromJson(body["data"]["attributes"]);
    await AuthProvider.to.saveToken(token);
    // Get.offAndToNamed(AppRoutes.Application);
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
  }

  handleCleanAccessToken() async {
    await AuthProvider.to.cleanAccessToken();
  }
}
