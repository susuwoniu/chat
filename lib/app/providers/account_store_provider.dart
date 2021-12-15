import './store_provider.dart';

class AccountStoreProvider extends StoreProvider {
  static final AccountStoreProvider _instance =
      AccountStoreProvider._internal();
  static AccountStoreProvider get to => _instance;
  factory AccountStoreProvider() => _instance;
  AccountStoreProvider._internal();
  Future<void> init() async {
    super.initStore("account_store");
  }
}
