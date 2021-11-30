import 'package:chat/types/types.dart';
import 'package:chat/constants/constants.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/kv_provider.dart';
import 'package:chat/common.dart';
import './chat_provider/chat_provider.dart';

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

  AccountEntity? _account;
  AccountEntity? get account => _account;

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
      _account = AccountEntity.fromJson(_accountObj);
    }
    //todo refresh token to access token
    if (_accessToken != null && _imAccessToken != null && _accountId != null) {
      // init im login
      try {
        await ChatProvider.to.login(
            "user3",
            "xmpp.scuinfo.com",
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJ1c2VyMyIsIm5hbWUiOiJKb2huIERvZSIsImFkbWluIjp0cnVlLCJuYmYiOjE2Mzc2OTIzNDQsImlhdCI6MTYzNzY5MjM0NCwiZXhwIjoxNzk5Njk1OTQ0fQ.OvsgTeNtjMZCiwaJUDW5uorukHVVIhsieLg_e5X5HQ86VA7MH-On-s-y81VuBKJFiJ6JiDyBr9zbABnseCVJyuRfgBwAacZAqpqHrqGkGdLpz6h1GPEC7Myh4_f-cdhGuzssSD3d2fAVkbM6B5a7b5NQzCPr_e_dwqP1Pe2g_kcsw9iBu9kjqes5tDX7Fx5zDrcBPhOPoBQobLPUPtTVSm6K_IINFiLWhIZg9SVN9SgQFciEiY7y7b5m5laYgZaxEjWyU34vsr8QNCeMbWUd73B0-g7j_x3lQzd-YJXltnpVTNVEMYsmVC_jI7lCPlLt-ILwTvT-vG8SI_IrKzktLg",
            "flutter");
      } catch (e) {
        print(e);
      }

      // await ImProvider.to.login(_accountId!, _imAccessToken!);
      _isLogin.value = true;
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
  }

  // 清楚access token test ,not use production
  Future<void> cleanAccessToken() async {
    _accessToken = null;
    _isLogin.value = false;
    await KVProvider.to.removeExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY);
  }

  Future<void> saveAccount(AccountEntity account) async {
    _account = account;
    await KVProvider.to.putObject(STORAGE_ACCOUNT_KEY, account.toJson());
  }
}
