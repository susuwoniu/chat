import 'package:get/get.dart';
import './api_provider.dart';
import 'package:chat/types/types.dart';
import './auth_provider.dart';
import './router_provider.dart';

class AccountProvider extends GetxService {
  static AccountProvider get to => Get.find();
  // 发送验证码
  handleSendCode(String countryCode, String phoneNumber) async {
    await APIProvider().post("/account/phone-codes/$countryCode/$phoneNumber",
        body: {"timezone_in_seconds": 28800, "device_id": "ttttt"},
        options: ApiOptions(withSignature: true, withAuthorization: false));
  }

  // 执行登录操作
  handleLogin(String countryCode, String phoneNumber, String verificationCode,
      {int? closePageCount, bool enabledDefaultNexPage = true}) async {
    final body = await APIProvider().post(
        "/account/phone-sessions/$countryCode/$phoneNumber/$verificationCode",
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
      if (account.actions.isNotEmpty) {
        // 如果需要跳actions页面则关闭当前登录页面
        closePageCount++;
      }
      Get.close(closePageCount);
    }
    // if not
    if (enabledDefaultNexPage && RouterProvider.to.nextPage == null) {
      RouterProvider.to.setNextPage(NextPage.fromDefault());
    }
    await AuthProvider.to.saveAccount(account);

    // Get.offAndToNamed(AppRoutes.Application);
  }

  handleLogout() async {
    await APIProvider().delete("/account/sessions");
    await AuthProvider.to.cleanToken();
    // await ImProvider.to.logout();
  }

  // 执行登录操作
  getMe() async {
    final _ = await APIProvider().get(
      "/account/me",
    );

    // Get.offAndToNamed(AppRoutes.Application);
  }

  Future<void> postAccountInfoChange(Map<String, dynamic> data) async {
    final body = await APIProvider().patch("/account/me", body: data);
    final account = AuthProvider.to.formatMainAccount(body);

    await AuthProvider.to.saveAccount(account);
  }
}
