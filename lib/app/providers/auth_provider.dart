import 'package:get/get.dart';
import 'package:chat/app/providers/cache_provider.dart';
import 'package:chat/app/providers/account_store_provider.dart';
import 'package:chat/app/providers/simple_account_map_cache_provider.dart';
import 'package:chat/app/providers/router_provider.dart';

import 'package:chat/common.dart';
import 'dart:async';
import 'package:chat/app/routes/app_pages.dart';

class AuthProvider extends GetxService {
  static AuthProvider get to => Get.find();
  final simpleAccountMap = RxMap<String, SimpleAccountEntity>({});

  // 是否登录
  final _isLogin = false.obs;
  TokenEntity? tokenEntity;
  String? get accountId => tokenEntity?.accountId;
  bool get isLogin => _isLogin.value;

  String? get accessToken {
    if (tokenEntity?.accessToken != null &&
        tokenEntity?.accessTokenExpiresAt != null) {
      if (tokenEntity!.accessTokenExpiresAt.isAfter(DateTime.now())) {
        return tokenEntity!.accessToken;
      }
    }
    return null;
  }

  String? get refreshToken {
    if (tokenEntity?.refreshToken != null &&
        tokenEntity?.refreshTokenExpiresAt != null) {
      if (tokenEntity!.refreshTokenExpiresAt.isAfter(DateTime.now())) {
        return tokenEntity!.refreshToken;
      }
    }
    return null;
  }

  String? get imAccessToken {
    if (tokenEntity?.imAccessToken != null &&
        tokenEntity?.imAccessTokenExpiresAt != null) {
      if (tokenEntity!.imAccessTokenExpiresAt.isAfter(DateTime.now())) {
        return tokenEntity!.imAccessToken;
      }
    }
    return null;
  }

  Stream<AuthStatus> get authUpdated => _authUpdatedStreamController.stream;
  final StreamController<AuthStatus> _authUpdatedStreamController =
      StreamController.broadcast();

  Rx<AccountEntity> account = AccountEntity.empty().obs;
  bool isNeedCompleteActions = false;
  Future<void> init() async {
    final tokenEntityJson = await AccountStoreProvider.to
        .getExpiredObject(STORAGE_ACCOUNT_TOKEN_KEY);
    if (tokenEntity == null && tokenEntityJson != null) {
      tokenEntity = TokenEntity.fromJson(tokenEntityJson);
    }
    final _accountObj = AccountStoreProvider.to.getObject(STORAGE_ACCOUNT_KEY);
    if (_accountObj != null) {
      account(AccountEntity.fromJson(_accountObj));
    }
    final _simpleAccountMap = SimpleAccountMapCacheProvider.to.getAll();
    if (_simpleAccountMap.keys.isNotEmpty) {
      simpleAccountMap.addAll(_simpleAccountMap);
    }
    //todo refresh token to access token
    if (accessToken != null && imAccessToken != null && accountId != null) {
      // await ImProvider.to.login(_accountId!, _imAccessToken!);
      _isLogin.value = true;
      _authUpdatedStreamController.add(AuthStatus.loginSuccess);
    } else {
      _isLogin.value = false;
    }
  }

  bool isNeedRenewToken() {
    final accessTokenExpiresMs =
        tokenEntity?.accessTokenExpiresAt.millisecondsSinceEpoch;
    if (accessTokenExpiresMs == null || accessTokenExpiresMs < 30 * 60 * 1000) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveToken(TokenEntity token, {bool persist = true}) async {
    Log.debug(token);
    // 保存access token
    tokenEntity = token;
    if (persist) {
      await AccountStoreProvider.to.setExpiredObject(STORAGE_ACCOUNT_TOKEN_KEY,
          token.toJson(), token.accessTokenExpiresAt);
    }
  }

  Future<void> persistToken() async {
    if (tokenEntity != null) {
      await AccountStoreProvider.to.setExpiredObject(STORAGE_ACCOUNT_TOKEN_KEY,
          tokenEntity!.toJson(), tokenEntity!.accessTokenExpiresAt);
    }
  }

  // 注销
  Future<void> cleanToken() async {
    _isLogin.value = false;
    tokenEntity = null;
    account(AccountEntity.empty());
    await CacheProvider.to.clear();
    await AccountStoreProvider.to.clear();
    _authUpdatedStreamController.add(AuthStatus.logoutSuccess);
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
        profileImageList.insert(v["attributes"]["order"],
            ProfileImageEntity.fromJson(v["attributes"]));
      }
    }

    accountEntity.profile_images = profileImageList;
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
        //     ProfileImageEntity.fromJson(v["attributes"]));
      } else if (v["type"] == "full-accounts") {
        accountEntity = AccountEntity.fromJson(v["attributes"]);
      }
    }
    // sort

    profileImageList.sort((a, b) => a.order.compareTo(b.order));

    accountEntity!.profile_images = profileImageList;
    return accountEntity;
  }

  Future<void> saveAccountToStore(AccountEntity accountEntity) async {
    account(accountEntity);
    // save to simple account map same time.
    await saveSimpleAccounts(
        {accountId!: SimpleAccountEntity.fromAccount(accountEntity)});
    await AccountStoreProvider.to
        .putObject(STORAGE_ACCOUNT_KEY, account.toJson());
  }

  Future<void> saveAccount(AccountEntity accountEntity,
      {bool ignoreActions = false}) async {
    await saveAccountToStore(accountEntity);

    final nextAction = RouterProvider.to.nextAction;
    //
    // AgreeCommunityRules,
    // AddAccountName,
    // AddAccountBio,
    // AddAccountBirthday,
    // AddAccountProfileImage,
    // AddAccountGender,
    final validActionsMap = {
      "agree_community_rules": true,
      "add_account_name": true,
      "add_account_bio": true,
      "add_account_birthday": true,
      "add_account_profile_image": true,
      "add_account_gender": true
    };
    // other unknow actions, we don't care.
    final List<ActionEntity> validActions = [];

    if (accountEntity.actions.isNotEmpty) {
      for (var element in accountEntity.actions) {
        if (validActionsMap[element.type] != null &&
            validActionsMap[element.type] == true) {
          validActions.add(element);
        }
      }
    }

    if (validActions.isNotEmpty && ignoreActions == false) {
      if (isNeedCompleteActions == false) {
        isNeedCompleteActions = true;
      }
      final actionType = validActions[0].type;
      if (actionType == 'agree_community_rules') {
        RouterProvider.to.setClosePageCountBeforeNextPage(
            RouterProvider.to.closePageCountBeforeNextPage + 1);
        Get.toNamed(Routes.RULE, arguments: {
          "content": validActions[0].content,
        });
      } else if (actionType == 'add_account_birthday') {
        RouterProvider.to.setClosePageCountBeforeNextPage(
            RouterProvider.to.closePageCountBeforeNextPage + 1);

        Get.toNamed(Routes.AGE_PICKER);
      } else if (actionType == 'add_account_gender') {
        RouterProvider.to.setClosePageCountBeforeNextPage(
            RouterProvider.to.closePageCountBeforeNextPage + 1);

        Get.toNamed(Routes.COMPLETE_GENDER);
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
      }
    } else {
      if (isNeedCompleteActions && nextAction != null) {
        // 需要减去1页，因为这个需要保留一个登录页
        RouterProvider.to.setClosePageCountBeforeNextPage(
            RouterProvider.to.closePageCountBeforeNextPage - 1);
        isNeedCompleteActions = false;
      }
      // now we can persistToken;
      await persistToken();
      RouterProvider.to.toNextPage();
    }
  }

  Future<void> saveSimpleAccounts(
    Map<String, SimpleAccountEntity> accountMap, {
    bool persist = false,
  }) async {
    simpleAccountMap.addAll(accountMap);
    if (persist) {
      await SimpleAccountMapCacheProvider.to.addAll(accountMap);
    }
  }
}

enum AuthStatus {
  // 登录成功
  loginSuccess,
  // 退出成功
  logoutSuccess,
}
