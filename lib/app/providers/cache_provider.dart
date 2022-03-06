// 可以被清空的缓存

import './store_provider.dart';

class CacheProvider extends StoreProvider {
  static late final CacheProvider _instance = CacheProvider._internal();
  static CacheProvider get to => _instance;
  factory CacheProvider() => _instance;

  CacheProvider._internal();
  Future<void> initial() async {
    await super.initStore("cache_store");
  }
}
