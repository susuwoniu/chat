// import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

// import 'package:chat/app/providers/providers.dart';
// import 'package:sprintf/sprintf.dart';

// class DataPersistence {
//   static const _FREQUENT_CONTACTS = "%s_frequentContacts";
//   static const _CALL_RECORDS = "%s_callRecords";
//   static const _LOGIN_INFO = 'loginCertificate';
//   static const _AT_USER_INFO = '%s_atUserInfo';
//   static const _SERVER = "server";

//   DataPersistence._();

//   static String getKey(String key) {
//     return sprintf(key, [OpenIM.iMManager.uid]);
//   }

//   /// 常用联系人
//   static List<String> getFrequentContacts() {
//     return KVProvider.to.getStringList(getKey(_FREQUENT_CONTACTS));
//   }

//   /// 常用联系人
//   static Future<bool?> putFrequentContacts(List<String> uidList) {
//     return KVProvider.to.putStringList(getKey(_FREQUENT_CONTACTS), uidList);
//   }

//   static Future<bool?> putAtUserMap(String gid, Map<String, String> atMap) {
//     return KVProvider.to.putObject(sprintf(_AT_USER_INFO, [gid]), atMap);
//   }

//   static Map? getAtUserMap(String gid) {
//     return KVProvider.to.getObject(sprintf(_AT_USER_INFO, [gid]));
//   }

//   static void removeAtUserMap(String gid) {
//     KVProvider.to.remove(sprintf(_AT_USER_INFO, [gid]));
//   }

//   static Future<bool?> putServerConfig(Map<String, String> config) {
//     return KVProvider.to.putObject(_SERVER, config);
//   }

//   static Map? getServerConfig() {
//     return KVProvider.to.getObject(_SERVER);
//   }
// }
