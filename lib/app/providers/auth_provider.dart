import 'package:chat/types/types.dart';
import 'package:chat/constants/constants.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/kv_provider.dart';
import 'package:chat/common.dart';
import 'dart:async';

class AuthProvider extends GetxService {
  static AuthProvider get to => Get.find();

  // 是否登录
  final _isLogin = false.obs;
  // 令牌 token
  String? _accessToken;
  // refresh token
  String? _refreshToken;
  // im token
  String? _imAccessToken;
  // current account id
  String? _accountId;
  String? get accountId => _accountId;
  bool get isLogin => _isLogin.value;
  bool get hasAccessToken => _accessToken != null;
  bool get hasImAccessToken => _imAccessToken != null;
  bool get hasRefreshToken => _refreshToken != null;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  Stream<AuthStatus> get authUpdated => _authUpdatedStreamController.stream;
  final StreamController<AuthStatus> _authUpdatedStreamController =
      StreamController.broadcast();

  Rx<AccountEntity> account = AccountEntity.empty().obs;

  Future<void> init() async {
    _accessToken =
        await KVProvider.to.getExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY);
    _imAccessToken = await KVProvider.to
        .getExpiredString(STORAGE_ACCOUNT_IM_ACCESS_TOKEN_KEY);
    _refreshToken =
        await KVProvider.to.getExpiredString(STORAGE_ACCOUNT_REFRESH_TOKEN_KEY);
    _accountId = KVProvider.to.getString(STORAGE_ACCOUNT_ID_KEY);
    final _accountObj = KVProvider.to.getObject(STORAGE_ACCOUNT_KEY);
    if (_accountObj != null) {
      account(AccountEntity.fromJson(_accountObj));
    }
    //todo refresh token to access token
    if (_accessToken != null && _imAccessToken != null && _accountId != null) {
      // await ImProvider.to.login(_accountId!, _imAccessToken!);
      _isLogin.value = true;
      _authUpdatedStreamController.add(AuthStatus.loginSuccess);
    } else {
      _isLogin.value = false;
    }
  }

  Future<bool> isNeedRenewToken() async {
    final accessTokenExpiresMs =
        await KVProvider.to.getExpiredMs(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY);
    final imAccessTokenExpiresMs =
        await KVProvider.to.getExpiredMs(STORAGE_ACCOUNT_IM_ACCESS_TOKEN_KEY);
    if (accessTokenExpiresMs == null ||
        imAccessTokenExpiresMs == null ||
        accessTokenExpiresMs < 30 * 60 * 1000 ||
        imAccessTokenExpiresMs < 30 * 60 * 1000) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveToken(TokenEntity token) async {
    Log.debug(token);
    // 保存access token
    _accessToken = token.accessToken;
    _refreshToken = token.refreshToken;
    _imAccessToken = token.imAccessToken;
    _accountId = token.accountId;
    await KVProvider.to.setExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY,
        _accessToken!, token.accessTokenExpiresAt);
    await KVProvider.to.setExpiredString(STORAGE_ACCOUNT_IM_ACCESS_TOKEN_KEY,
        _imAccessToken!, token.imAccessTokenExpiresAt);

    await KVProvider.to.setExpiredString(STORAGE_ACCOUNT_REFRESH_TOKEN_KEY,
        _accessToken!, token.refreshTokenExpiresAt);
    await KVProvider.to.setString(STORAGE_ACCOUNT_ID_KEY, token.accountId);
  }

  // 注销
  Future<void> cleanToken() async {
    _isLogin.value = false;
    _accessToken = null;
    _imAccessToken = null;
    _accountId = null;
    _refreshToken = null;
    await KVProvider.to.removeExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY);
    await KVProvider.to
        .removeExpiredString(STORAGE_ACCOUNT_IM_ACCESS_TOKEN_KEY);

    await KVProvider.to.removeExpiredString(STORAGE_ACCOUNT_REFRESH_TOKEN_KEY);
    await KVProvider.to.remove(STORAGE_ACCOUNT_ID_KEY);
    await KVProvider.to.remove(STORAGE_ACCOUNT_KEY);
    _authUpdatedStreamController.add(AuthStatus.logoutSuccess);
  }

  // 清楚access token test ,not use production
  Future<void> cleanAccessToken() async {
    _accessToken = null;
    _isLogin.value = false;
    await KVProvider.to.removeExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY);
  }

  Future<void> saveAccount(AccountEntity accountEntity) async {
    account(accountEntity);
    await KVProvider.to.putObject(STORAGE_ACCOUNT_KEY, account.toJson());
  }
}

enum AuthStatus {
  // 登录成功
  loginSuccess,
  // 退出成功
  logoutSuccess,
}
