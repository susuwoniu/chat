import 'package:chat/types/types.dart';
import 'package:chat/constants/constants.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/kv_provider.dart';
import 'package:chat/app/providers/router_provider.dart';

import 'package:chat/common.dart';
import 'dart:async';
import 'package:chat/app/routes/app_pages.dart';

class AuthProvider extends GetxService {
  static AuthProvider get to => Get.find();
  final simpleAccountMap = RxMap<String, SimpleAccountEntity>({});

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
  String? get imAccessToken => _imAccessToken;
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
    // clear all cached data;
    await KVProvider.to.clear();
    // await KVProvider.to.removeExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY);
    // await KVProvider.to
    //     .removeExpiredString(STORAGE_ACCOUNT_IM_ACCESS_TOKEN_KEY);

    // await KVProvider.to.removeExpiredString(STORAGE_ACCOUNT_REFRESH_TOKEN_KEY);
    // await KVProvider.to.remove(STORAGE_ACCOUNT_ID_KEY);
    // await KVProvider.to.remove(STORAGE_ACCOUNT_KEY);
    _authUpdatedStreamController.add(AuthStatus.logoutSuccess);
  }

  // 清楚access token test ,not use production
  Future<void> cleanAccessToken() async {
    _accessToken = null;
    _isLogin.value = false;
    await KVProvider.to.removeExpiredString(STORAGE_ACCOUNT_ACCESS_TOKEN_KEY);
  }

  AccountEntity formatMainAccount(dynamic body) {
    final accountEntity = AccountEntity.fromJson(body["data"]["attributes"]);
    var included = [];
    if (body["included"] != null) {
      included = body["included"] as List;
    }

    final List<ProfileImageEntity> profileImageList = [];

    for (var v in included) {
      if (v["type"] == "profile-images") {
        profileImageList.insert(v["atrributes"]["order"],
            ProfileImageEntity.fromJson(v["atrributes"]));
      }
    }

    accountEntity.profileImages = profileImageList;
    return accountEntity;
  }

  AccountEntity formatTokenAccount(dynamic body) {
    AccountEntity? accountEntity;
    var included = [];
    if (body["included"] != null) {
      included = body["included"] as List;
    }
    List<ProfileImageEntity> profileImageList = [];

    for (var v in included) {
      if (v["type"] == "profile-images") {
        final profileImageEntity = ProfileImageEntity.fromJson(v["attributes"]);
        // final order = v["attributes"]["order"];
        profileImageList.add(profileImageEntity);
        // profileImageList.insert(v["attributes"]["order"],
        //     ProfileImageEntity.fromJson(v["atrributes"]));
      } else if (v["type"] == "full-accounts") {
        accountEntity = AccountEntity.fromJson(v["attributes"]);
      }
    }
    // sort

    profileImageList.sort((a, b) => a.order.compareTo(b.order));

    accountEntity!.profileImages = profileImageList;
    return accountEntity;
  }

  Future<void> saveAccount(AccountEntity accountEntity) async {
    account(accountEntity);
    await KVProvider.to.putObject(STORAGE_ACCOUNT_KEY, account.toJson());

    if (accountEntity.actions.isNotEmpty) {
      final actionType = accountEntity.actions[0].type;
      if (actionType == 'add_account_birthday') {
        RouterProvider.to.setClosePageCountBeforeNextPage(
            RouterProvider.to.closePageCountBeforeNextPage + 1);
        Get.toNamed(Routes.AGE_PICKER);
      } else if (actionType == 'add_account_gender') {
        RouterProvider.to.setClosePageCountBeforeNextPage(
            RouterProvider.to.closePageCountBeforeNextPage + 1);
        Get.toNamed(Routes.GENDER_SELECT);
      } else if (actionType == 'add_account_name') {
        RouterProvider.to.setClosePageCountBeforeNextPage(
            RouterProvider.to.closePageCountBeforeNextPage + 1);
        Get.toNamed(Routes.EDIT_NAME, arguments: {'action': actionType});
      } else if (actionType == 'add_account_bio') {
        RouterProvider.to.setClosePageCountBeforeNextPage(
            RouterProvider.to.closePageCountBeforeNextPage + 1);
        Get.toNamed(Routes.EDIT_BIO, arguments: {'action': actionType});
      } else if (actionType == 'add_account_profile_image') {
        RouterProvider.to.setClosePageCountBeforeNextPage(
            RouterProvider.to.closePageCountBeforeNextPage + 1);

        Get.toNamed(Routes.ADD_PROFILE_IMAGE,
            arguments: {'action': actionType});
      } else {
        RouterProvider.to.toNextPage();
      }

      // TODO
    } else {
      RouterProvider.to.toNextPage();
    }
  }

  Future<void> saveSimpleAccounts(
      Map<String, SimpleAccountEntity> accountMap) async {
    simpleAccountMap.addAll(accountMap);
    // TODO cache
  }
}

enum AuthStatus {
  // 登录成功
  loginSuccess,
  // 退出成功
  logoutSuccess,
}
