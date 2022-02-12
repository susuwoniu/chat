import './store_provider.dart';
import 'package:chat/types/types.dart';

class SimpleAccountMapCacheProvider extends StoreProvider {
  static late final SimpleAccountMapCacheProvider _instance =
      SimpleAccountMapCacheProvider._internal();
  static SimpleAccountMapCacheProvider get to => _instance;
  factory SimpleAccountMapCacheProvider() => _instance;

  SimpleAccountMapCacheProvider._internal();
  Future<void> init() async {
    super.initStore("simple_account_map_cache_store");
  }

  Future<void> addAll(Map<String, SimpleAccountEntity> accountMap) async {
    for (var key in accountMap.keys) {
      await super.putObject(key, accountMap[key]!.toJson());
    }
  }

  Map<String, SimpleAccountEntity> getAll() {
    final keys = super.getKeys();
    Map<String, SimpleAccountEntity> accountMap = {};
    for (var key in keys) {
      final value = super.getObject(key);
      if (value != null) {
        try {
          accountMap[key] = SimpleAccountEntity.fromJson(value);
        } catch (e) {
          super.clear();
          return {};
        }
      }
    }
    return accountMap;
  }
}
