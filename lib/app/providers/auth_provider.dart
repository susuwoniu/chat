import 'package:get/get.dart';
import 'package:chat/app/providers/cache_provider.dart';
import 'package:chat/app/providers/account_store_provider.dart';
import 'package:chat/app/providers/simple_account_map_cache_provider.dart';
import 'package:chat/app/providers/router_provider.dart';

import 'package:chat/common.dart';
import 'dart:async';

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
      try {
        account(AccountEntity.fromJson(_accountObj));
      } catch (e) {
        await cleanToken();
        return;
      }
    }
    final _simpleAccountMap = SimpleAccountMapCacheProvider.to.getAll();
    if (_simpleAccountMap.keys.isNotEmpty) {
      simpleAccountMap.addAll(_simpleAccountMap);
    }
    //todo refresh token to access token
    if (accessToken != null && imAccessToken != null && accountId != null) {
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
      await persistToken();
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

    return accountEntity;
  }

  AccountEntity formatTokenAccount(dynamic body) {
    AccountEntity? accountEntity;
    var included = [];
    if (body["included"] != null) {
      included = body["included"] as List;
    }

    for (var v in included) {
      if (v["type"] == "full-accounts") {
        accountEntity = AccountEntity.fromJson(v["attributes"]);
      }
    }

    return accountEntity!;
  }

  Future<void> saveAccountToStore(AccountEntity accountEntity) async {
    account(accountEntity);
    // save to simple account map same time.
    await saveSimpleAccounts(
        {accountId!: SimpleAccountEntity.fromAccount(accountEntity)});
    await AccountStoreProvider.to
        .putObject(STORAGE_ACCOUNT_KEY, account.toJson());
  }

  checkActions(List<ActionEntity> actions) {
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
      "add_account_avatar": true,
      "add_account_gender": true
    };
    // other unknow actions, we don't care.
    final List<ActionEntity> validActions = [];

    if (actions.isNotEmpty) {
      for (var element in actions) {
        if (validActionsMap[element.type] != null &&
            validActionsMap[element.type] == true) {
          validActions.add(element);
        }
      }
    }
    if (validActions.isNotEmpty) {
      RouterProvider.to.toNextAction(
        validActions[0],
        isLastAction: validActions.length == 1,
      );
    } else {
      RouterProvider.to.toNextPageOrHome();
    }
  }

  Future<void> saveAccount(AccountEntity accountEntity,
      {bool ignoreActions = false}) async {
    await saveAccountToStore(accountEntity);
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
