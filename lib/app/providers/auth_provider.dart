import 'package:chat/types/types.dart';
import 'package:chat/constants/constants.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/kv_provider.dart';
import 'package:chat/common.dart';

class AuthProvider extends GetxService {
  static AuthProvider get to => Get.find();

  // 是否登录
  final _isLogin = false.obs;
  // 令牌 token
  String? _accessToken;
  // refresh token
  String? _refreshToken;
  bool get isLogin => _isLogin.value;
  bool get hasAccessToken => _accessToken != null;
  bool get hasRefreshToken => _refreshToken != null;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  @override
  void onInit() async {
    super.onInit();
    _accessToken =
        await KVProvider.to.getExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY);
    _refreshToken =
        await KVProvider.to.getExpiredString(STORAGE_ACCOUNT_REFRESH_TOKEN_KEY);
    if (_accessToken != null) {
      _isLogin.value = true;
    } else {
      _isLogin.value = false;
    }
  }

  Future<void> saveToken(TokenEntity token) async {
    Log.debug(token);
    // 保存access token
    _accessToken = token.accessToken;
    _refreshToken = token.refreshToken;

    await KVProvider.to.setExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY,
        _accessToken!, token.accessTokenExpiresAt);

    await KVProvider.to.setExpiredString(STORAGE_ACCOUNT_REFRESH_TOKEN_KEY,
        _accessToken!, token.refreshTokenExpiresAt);
    _isLogin.value = true;
  }

  // 注销
  Future<void> cleanToken() async {
    _isLogin.value = false;
    _accessToken = null;
    _refreshToken = null;
    await KVProvider.to.removeExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY);
    await KVProvider.to.removeExpiredString(STORAGE_ACCOUNT_REFRESH_TOKEN_KEY);
  }

  // 清楚access token
  Future<void> cleanAccessToken() async {
    _accessToken = null;
    _isLogin.value = false;
    await KVProvider.to.removeExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY);
  }
}
