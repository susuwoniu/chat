import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat/constants/constants.dart';
import 'dart:convert';

class KVProvider extends GetxService {
  static KVProvider get to => Get.find();
  late final SharedPreferences _prefs;

  Future<KVProvider> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setExpiredString(
      String key, String value, DateTime expiresAt) async {
    await _prefs.setString(key, value);
    await _prefs.setInt(
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
    final value = _prefs.getString(key);
    if (value == null) return null;

    final expiresAt = _prefs.getInt(STORAGE_EXPIRING_PREFIX_KEY + key);
    final ms = DateTime.now().millisecondsSinceEpoch;
    if (expiresAt == null || expiresAt > ms) {
      if (expiresAt == null) {
        return 9007199254740991;
      }
      return expiresAt - ms;
    } else {
      await _prefs.remove(key);
      await _prefs.remove(STORAGE_EXPIRING_PREFIX_KEY + key);
      return null;
    }
  }

  Future<String?> getExpiredString(String key) async {
    // Guard
    final value = _prefs.getString(key);
    if (value == null) return null;

    final expiresAt = _prefs.getInt(STORAGE_EXPIRING_PREFIX_KEY + key);
    final ms = DateTime.now().millisecondsSinceEpoch;
    if (expiresAt == null || expiresAt > ms) {
      return value;
    } else {
      await _prefs.remove(key);
      await _prefs.remove(STORAGE_EXPIRING_PREFIX_KEY + key);
      return null;
    }
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool> setList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }

  List<String> getList(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// put object.
  Future<bool?> putObject(String key, Map<String, dynamic> value) async {
    return _prefs.setString(key, value == null ? "" : json.encode(value));
  }

  /// get T.
  T? parseObject<T>(String key, T f(Map v), {T? defValue}) {
    Map? map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  Map<String, dynamic>? getObject(String key) {
    String? _data = _prefs.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// put object list.
  Future<bool?> putObjectList(String key, List<Object>? list) async {
    if (list == null) return null;
    List<String> data = list.map((value) => json.encode(value)).toList();
    return _prefs.setStringList(key, data);
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
    List<String>? data = _prefs.getStringList(key);
    return data?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    }).toList();
  }

  /// put string.
  Future<bool?> putString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  /// put bool.
  Future<bool?> putBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  /// get int.
  int getInt(String key, {int defValue = 0}) {
    if (_prefs == null) return defValue;
    return _prefs.getInt(key) ?? defValue;
  }

  /// put int.
  Future<bool?> putInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  /// get double.
  double getDouble(String key, {double defValue = 0.0}) {
    if (_prefs == null) return defValue;
    return _prefs.getDouble(key) ?? defValue;
  }

  /// put double.
  Future<bool?> putDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  /// get string list.
  List<String> getStringList(String key, {List<String> defValue = const []}) {
    if (_prefs == null) return defValue;
    return _prefs.getStringList(key) ?? defValue;
  }

  /// put string list.
  Future<bool?> putStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  /// get dynamic.
  dynamic getDynamic(String key, {Object? defValue}) {
    if (_prefs == null) return defValue;
    return _prefs.get(key) ?? defValue;
  }

  /// have key.
  bool? haveKey(String key) {
    return _prefs.getKeys().contains(key);
  }

  /// get keys.
  Set<String>? getKeys() {
    return _prefs.getKeys();
  }

  /// clear.
  Future<bool?> clear() async {
    return _prefs.clear();
  }

  Future<void> reload() async {
    return _prefs.reload();
  }
}
