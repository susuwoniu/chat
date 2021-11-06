import 'dart:convert';

import 'package:chat/app/providers/providers.dart';
import 'package:chat/types/types.dart';
import 'package:chat/constants/constants.dart';
import 'package:get/get.dart';
import './kv.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  // 是否登录
  final _isLogin = false.obs;
  // 令牌 token
  String? access_token;
  // 用户 profile
  final _token = TokenEntity.getDefault().obs;

  bool get isLogin => _isLogin.value;
  TokenEntity get tokenInfo => _token.value;
  bool get hasToken => access_token != null;

  @override
  void onInit() async {
    super.onInit();
    access_token =
        await KVService.to.getExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY);
  }

  Future<void> login() async {
    final responseData = await APIProvider().post(
        "/account/phone-sessions/86/15523324324/123456",
        body: {"timezone_in_seconds": 28800, "device_id": "ttttt"});
    final data = json.decode(responseData);
    access_token = data['data']['attributes']['access_token'];
    final access_token_expires_at = data['data']['attributes']['expires_at'];
    _isLogin.value = true;
    await KVService.to.setExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY,
        access_token!, access_token_expires_at);
  }

  // 注销
  Future<void> logout() async {
    if (_isLogin.value) await APIProvider().delete("/account/sessions");
    await KVService.to.removeExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY);
    _isLogin.value = false;
    access_token = '';
  }
}
