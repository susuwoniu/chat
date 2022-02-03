import 'package:chat/common.dart';
import 'package:get/get.dart';
import './api_provider.dart';
import 'package:chat/types/types.dart';
import './auth_provider.dart';
import './router_provider.dart';

class AccountProvider extends GetxService {
  static AccountProvider get to => Get.find();
  var diffTime = 0;

  // 发送验证码
  handleSendCode(String countryCode, String phoneNumber) async {
    await APIProvider().post("/account/phone-codes/$countryCode/$phoneNumber",
        body: {"timezone_in_seconds": 28800, "device_id": "ttttt"},
        options: ApiOptions(withSignature: true, withAuthorization: false));
  }

  // 执行登录操作
  handleLogin(String countryCode, String phoneNumber, String verificationCode,
      {int? closePageCount,
      bool enabledDefaultNexPage = true,
      dynamic arguments}) async {
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
    // 不为空，则暂时不保存token到本地

    await AuthProvider.to.saveToken(token, persist: account.actions.isEmpty);
    await AuthProvider.to.saveAccountToStore(account);
    await AuthProvider.to.init();
    if (closePageCount != null && closePageCount > 0) {
      if (account.actions.isNotEmpty) {
        // 如果需要跳actions页面则关闭当前登录页面
        closePageCount++;
      }
      Get.close(closePageCount);
    }
    // if not
    String? next, mode;
    if (arguments != null) {
      next = arguments['next'];
      mode = arguments['mode'];
    }
    if (next != null || mode != null) {
      final nextPage = NextPage.fromArguments(arguments);
      RouterProvider.to.setNextPage(nextPage);
    } else if (enabledDefaultNexPage) {
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
    final result = await APIProvider().get(
      "/account/me",
    );
    final serverTime = DateTime.parse(result['data']['attributes']['now']);
    diffTime = DateTime.now().difference(serverTime).inMilliseconds;
    // Get.offAndToNamed(AppRoutes.Application);
  }

  Future<void> postAccountInfoChange(Map<String, dynamic> data,
      {bool ignoreActions = false}) async {
    final body = await APIProvider().patch("/account/me", body: data);
    final account = AuthProvider.to.formatMainAccount(body);
    await AuthProvider.to.saveAccount(account, ignoreActions: ignoreActions);
  }
}
