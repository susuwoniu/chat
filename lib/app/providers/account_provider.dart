import 'package:chat/app/providers/chat_provider/chat_provider.dart';
import 'package:chat/common.dart';
import 'package:get/get.dart';
import './api_provider.dart';
import 'package:chat/types/types.dart';
import './auth_provider.dart';
import './router_provider.dart';
import './push_provider.dart';

class AccountProvider extends GetxService {
  static AccountProvider get to => Get.find();
  var diffTime = 0;

  // 发送验证码
  handleSendCode(
      {required String countryCode,
      required String phoneNumber,
      required String deviceId}) async {
    await APIProvider().post("/account/phone-codes/$countryCode/$phoneNumber",
        body: {"timezone_in_seconds": 28800, "device_id": deviceId},
        options: ApiOptions(withSignature: true, withAuthorization: false));
  }

  // 执行登录操作
  handleLogin(
      {required String deviceId,
      required String countryCode,
      required String phoneNumber,
      required String verificationCode,
      int? closePageCount,
      bool enabledDefaultNexPage = false,
      dynamic arguments}) async {
    // try to get device token
    final bodyJson = {"timezone_in_seconds": 28800, "device_id": deviceId};

    var deviceToken = "";
    // ToDo
    // try {
    //   deviceToken = await PushProvider.to.jpush.getRegistrationID();
    // } catch (e) {
    //   print('get device token error: $e');
    // }
    if (deviceToken != "") {
      bodyJson["push_service_type"] = 'jiguang';
      bodyJson["device_token"] = deviceToken;
    }
    final body = await APIProvider().post(
        "/account/phone-sessions/$countryCode/$phoneNumber/$verificationCode",
        body: bodyJson,
        options: ApiOptions(
            withSignature: true,
            checkDataAttributes: true,
            withAuthorization: false));
    final token = TokenEntity.fromJson(body["data"]["attributes"]);
    final account = AuthProvider.to.formatTokenAccount(body);
    // login im service
    // 不为空，则暂时不保存token到本地

    await AuthProvider.to.saveToken(token, persist: account.actions.isEmpty);
    await AuthProvider.to.saveAccount(account);
    await AuthProvider.to.init();

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
    // if (closePageCount != null && closePageCount > 0) {
    //   if (account.actions.isNotEmpty) {
    //     // 如果需要跳actions页面则关闭当前登录页面
    //     closePageCount++;
    //   }
    //   Get.close(closePageCount);
    // }
    // Get.close(2);
    if (closePageCount != null && closePageCount > 0) {
      // todo
      Get.close(closePageCount);
    }
    // check actions
    AuthProvider.to.checkActions(
      account.actions,
    );

    // Get.offAndToNamed(AppRoutes.Application);
  }

  Future<void> handleLogout() async {
    // remove xmpp session
    await ChatProvider.to.logout();
    // get device
    final bodyJson = {};
    var deviceToken = "";
    // try {
    //   deviceToken = await PushProvider.to.jpush.getRegistrationID();
    // } catch (e) {
    //   print('get device token error: $e');
    // }
    if (deviceToken != "") {
      bodyJson["push_service_type"] = 'jiguang';
      bodyJson["device_token"] = deviceToken;
    }
    await APIProvider().delete("/account/sessions", body: bodyJson);
    await AuthProvider.to.cleanToken();
    await ChatProvider.to.dipose();
  }

  // 执行登录操作
  getMe() async {
    final result = await APIProvider().get(
      "/account/me",
    );
    final serverTime = DateTime.parse(result['data']['attributes']['now']);
    diffTime = DateTime.now().difference(serverTime).inMilliseconds;
    final accountEntity = AccountEntity.fromJson(result["data"]["attributes"]);
    await AuthProvider.to.saveAccount(accountEntity);
    // Get.offAndToNamed(AppRoutes.Application);
  }

  Future<AccountEntity> postAccountInfoChange(Map<String, dynamic> data,
      {bool ignoreActions = false}) async {
    final body = await APIProvider().patch("/account/me", body: data);
    final account = AuthProvider.to.formatMainAccount(body);
    await AuthProvider.to.saveAccount(account, ignoreActions: ignoreActions);
    return account;
  }
}
