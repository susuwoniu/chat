import './store_provider.dart';
import 'package:chat/types/types.dart';
import '../../constants/storage.dart';

class SimpleAccountMapCacheProvider extends StoreProvider {
  static late final SimpleAccountMapCacheProvider _instance =
      SimpleAccountMapCacheProvider._internal();
  static SimpleAccountMapCacheProvider get to => _instance;
  factory SimpleAccountMapCacheProvider() => _instance;

  SimpleAccountMapCacheProvider._internal();
  Future<void> initial() async {
    await super.initStore("simple_account_map_cache_store");
  }

  Future<void> addAll(Map<String, SimpleAccountEntity> accountMap) async {
    for (var key in accountMap.keys) {
      await super.setExpiredObject(key, accountMap[key]!.toJson(),
          DateTime.now().add(Duration(days: 7)));
    }
  }

  Map<String, SimpleAccountEntity> getAll() {
    final rawKeys = super.getKeys();
    // remove expired keys
    final keys = rawKeys
        .where((element) => !element.startsWith(STORAGE_EXPIRING_PREFIX_KEY));
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
