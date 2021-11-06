import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat/constants/constants.dart';

class KVService extends GetxService {
  static KVService get to => Get.find();
  late final SharedPreferences _prefs;

  Future<KVService> init() async {
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

  String getString(String key) {
    return _prefs.getString(key) ?? '';
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
}
