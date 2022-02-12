import 'package:chat/common.dart';
import 'package:chat/app/providers/providers.dart';

class IdResult {
  final Map<String, SimpleAccountEntity> accountMap;
  final List<String> indexes;
  final String? startCursor;
  final String? endCursor;

  IdResult({
    this.indexes = const [],
    this.endCursor,
    this.startCursor,
    this.accountMap = const {},
  });
}

Future<IdResult> getIdResult(
    {required String url, String? before, String? after}) async {
  Map<String, dynamic> query = {};

  final Map<String, SimpleAccountEntity> accountMap = {};
  final List<String> idIndexes = [];

  if (after != null) {
    query["after"] = after;
  }
  if (before != null) {
    query["before"] = before;
  }
  final result = await APIProvider.to.get(url, query: query);
  final endCursor = result['meta']['page_info']['end'];
  final startCursor = result['meta']['page_info']['start'];

  List<String> indexes = [];

  if (result["included"] != null && result["data"] != null) {
    for (var v in result['included']) {
      if (v['type'] == "accounts") {
        indexes.add(v['id']);
        accountMap[v['id']] = SimpleAccountEntity.fromJson(v['attributes']);
      }
    }
    idIndexes.addAll(indexes);
    return IdResult(
        accountMap: accountMap,
        indexes: idIndexes,
        startCursor: startCursor,
        endCursor: endCursor);
  }

  return IdResult(accountMap: {}, indexes: [], startCursor: '', endCursor: '');
}
