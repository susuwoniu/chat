// 可以被清空的缓存
import 'package:get_storage/get_storage.dart';
import 'package:chat/constants/constants.dart';
import 'dart:convert';

class StoreProvider {
  late GetStorage _prefs;
  initStore(String namespace) {
    _prefs = GetStorage(namespace);
  }

  Future<void> setString(String key, String value) async {
    return _prefs.write(key, value);
  }

  String? getString(String key) {
    return _prefs.read<String>(key);
  }

  Future<void> setBool(String key, bool value) async {
    return _prefs.write(key, value);
  }

  bool getBool(String key) {
    return _prefs.read<bool>(key) ?? false;
  }

  Future<void> setInt(String key, int value) async {
    return _prefs.write(key, value);
  }

  /// get int.
  int getInt(String key, {int defValue = 0}) {
    return _prefs.read(key) ?? defValue;
  }

  Future<void> remove(String key) async {
    return _prefs.remove(key);
  }

  Future<void> clear() async {
    return _prefs.erase();
  }

  Future<bool> setExpiredString(
      String key, String value, DateTime expiresAt) async {
    await setString(key, value);
    await setInt(
        STORAGE_EXPIRING_PREFIX_KEY + key, expiresAt.millisecondsSinceEpoch);
    return true;
  }

  Future<bool> removeExpiredString(
    String key,
  ) async {
    await _prefs.remove(key);
    await _prefs.remove(STORAGE_EXPIRING_PREFIX_KEY + key);
    return true;
  }

  // 获取过期毫秒
  Future<int?> getExpiredMs(String key) async {
    // Guard
    final value = getString(key);
    if (value == null) return null;

    final expiresAt = getInt(STORAGE_EXPIRING_PREFIX_KEY + key);
    final ms = DateTime.now().millisecondsSinceEpoch;
    if (expiresAt > ms) {
      return expiresAt - ms;
    } else {
      await _prefs.remove(key);
      await _prefs.remove(STORAGE_EXPIRING_PREFIX_KEY + key);
      return null;
    }
  }

  Future<String?> getExpiredString(String key) async {
    // Guard
    final value = getString(key);
    if (value == null) return null;

    final expiresAt = getInt(STORAGE_EXPIRING_PREFIX_KEY + key);
    final ms = DateTime.now().millisecondsSinceEpoch;
    if (expiresAt > ms) {
      return value;
    } else {
      await _prefs.remove(key);
      await _prefs.remove(STORAGE_EXPIRING_PREFIX_KEY + key);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getExpiredObject(String key) async {
    // Guard
    final value = getObject(key);
    if (value == null) return null;

    final expiresAt = getInt(STORAGE_EXPIRING_PREFIX_KEY + key);
    final ms = DateTime.now().millisecondsSinceEpoch;
    if (expiresAt > ms) {
      return value;
    } else {
      await _prefs.remove(key);
      await _prefs.remove(STORAGE_EXPIRING_PREFIX_KEY + key);
      return null;
    }
  }

  Future<bool> setExpiredObject(
      String key, Map<String, dynamic> value, DateTime expiresAt) async {
    await putObject(key, value);
    await setInt(
        STORAGE_EXPIRING_PREFIX_KEY + key, expiresAt.millisecondsSinceEpoch);
    return true;
  }

  Future<bool> removeExpired(
    String key,
  ) async {
    await _prefs.remove(key);
    await _prefs.remove(STORAGE_EXPIRING_PREFIX_KEY + key);
    return true;
  }

  Future<void> putObjectList(String key, List<Object>? list) async {
    if (list == null) return;
    String data = json.encode(list);
    return _prefs.write(key, data);
  }

  /// get T list.
  List<T> parseObjectList<T>(String key, T f(Map v),
      {List<T> defValue = const []}) {
    List<Map>? data = getObjectList(key);
    List<T>? list = data?.map((value) => f(value)).toList();
    return list ?? defValue;
  }

  /// get object list.
  List<Map>? getObjectList(String key) {
    String? data = _prefs.read(key);
    if (data != null) {
      return List.from(json.decode(data) as List);
    } else {
      return null;
    }
  }

  /// put object.
  Future<void> putObject(String key, Map<String, dynamic> value) async {
    return setString(key, json.encode(value));
  }

  /// get T.
  T? parseObject<T>(String key, T f(Map v), {T? defValue}) {
    Map? map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  Map<String, dynamic>? getObject(String key) {
    String? _data = getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  Iterable<String> getKeys() {
    return _prefs.getKeys();
  }
}
