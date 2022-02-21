import 'package:chat/app/providers/providers.dart';
import 'package:chat/common.dart';

class Skip {
  String start;
  String end;
  DateTime expiresAt;
  Skip({required this.start, required this.end, required this.expiresAt});
  Object toJson() {
    return {"start": start, "end": end, "expiresAt": expiresAt.toString()};
  }

  Skip fromJson(dynamic value) {
    return Skip(
        end: value["end"] as String,
        start: value["start"],
        expiresAt: DateTime.parse(value["expiresAt"]));
  }
}

class PostsResult {
  final Map<String, PostEntity> postMap;
  final Map<String, SimpleAccountEntity> accountMap;
  final List<String> indexes;
  final String? startCursor;
  final String? endCursor;

  PostsResult({
    this.postMap = const {},
    this.indexes = const [],
    this.endCursor,
    this.startCursor,
    this.accountMap = const {},
  });
}

class FavoriteResult {
  final Map<String, FavoriteEntity> favoriteMap;
  final Map<String, PostEntity> postMap;

  final Map<String, SimpleAccountEntity> accountMap;
  final List<String> indexes;
  final String? startCursor;
  final String? endCursor;

  FavoriteResult({
    this.favoriteMap = const {},
    this.postMap = const {},
    this.indexes = const [],
    this.endCursor,
    this.startCursor,
    this.accountMap = const {},
  });
}

Future<PostsResult> getApiPosts(
    {String? after,
    String? before,
    String? selectedGender,
    String? sort,
    int? startAge,
    int? endAge,
    String? postTemplateId,
    double? longitude,
    double? latitude,
    double? distance,
    required String url,
    List<Skip>? skips}) async {
  Map<String, dynamic> query = {
    // "featured": "true",
    "limit": DEFAULT_PAGE_SIZE.toString(),
  };
  if (after != null) {
    query["after"] = after;
  }
  if (sort != null) {
    query["sort"] = sort;
  }
  if (before != null) {
    query["before"] = before;
  }
  if (skips != null && skips.isNotEmpty) {
    query["skip"] = skips.map((value) {
      return "${value.start}-${value.end}";
    }).join(",");
  }
  if (selectedGender != null) {
    query["gender"] = selectedGender;
  }
  if (startAge != null) {
    query["start_age"] = startAge.toString();
  }
  if (endAge != null) {
    query["end_age"] = endAge.toString();
  }
  if (postTemplateId != null) {
    query["post_template_id"] = postTemplateId.toString();
  }

  if (longitude != null && latitude != null && distance != null) {
    query["longitude"] = longitude.toString();
    query["latitude"] = latitude.toString();
    query["distance"] = distance.toString();
  }

  final body = await APIProvider.to.get(url, query: query);
  print(query);
  if (body["data"].length == 0) {
    return PostsResult();
  }
  final Map<String, PostEntity> newPostMap = {};
  final List<String> newIndexes = [];

  String? newEndCursor;
  String? newStartCursor;
  for (var i = 0; i < body["data"].length; i++) {
    final item = body["data"][i];
    newPostMap[item["id"]] = PostEntity.fromJson(item["attributes"]);
    newIndexes.add(item["id"]);
  }
  final Map<String, SimpleAccountEntity> newAccountMap = {};
  if (body["included"] != null) {
    for (var v in body["included"]) {
      if (v["type"] == "accounts") {
        newAccountMap[v["id"]] = SimpleAccountEntity.fromJson(v["attributes"]);
      }
    }
  }

  if (body["meta"]["page_info"]["end"] != null) {
    newEndCursor = body["meta"]["page_info"]["end"];
  }
  if (body["meta"]["page_info"]["start"] != null) {
    newStartCursor = body["meta"]["page_info"]["start"];
  }
  return PostsResult(
      postMap: newPostMap,
      indexes: newIndexes,
      endCursor: newEndCursor,
      startCursor: newStartCursor,
      accountMap: newAccountMap);
}

Future<FavoriteResult> getFavoritePosts({
  String? after,
  String? before,
}) async {
  Map<String, dynamic> query = {
    // "featured": "true",
    "limit": DEFAULT_PAGE_SIZE.toString(),
  };
  if (after != null) {
    query["after"] = after;
  }
  if (before != null) {
    query["before"] = before;
  }

  final body =
      await APIProvider.to.get('/post/me/post-favorites', query: query);
  print(query);
  if (body["data"].length == 0) {
    return FavoriteResult();
  }
  final Map<String, FavoriteEntity> newFavoriteMap = {};
  final Map<String, PostEntity> newPostMap = {};

  final List<String> newIndexes = [];

  String? newEndCursor;
  String? newStartCursor;
  for (var i = 0; i < body["data"].length; i++) {
    final item = body["data"][i];
    newFavoriteMap[item["id"]] = FavoriteEntity.fromJson(item["attributes"]);
    newIndexes.add(item["id"]);
  }
  final Map<String, SimpleAccountEntity> newAccountMap = {};
  if (body["included"] != null) {
    for (var v in body["included"]) {
      if (v["type"] == "accounts") {
        newAccountMap[v["id"]] = SimpleAccountEntity.fromJson(v["attributes"]);
      } else if (v["type"] == "posts") {
        newPostMap[v["id"]] = PostEntity.fromJson(v["attributes"]);
      }
    }
  }

  if (body["meta"]["page_info"]["end"] != null) {
    newEndCursor = body["meta"]["page_info"]["end"];
  }
  if (body["meta"]["page_info"]["start"] != null) {
    newStartCursor = body["meta"]["page_info"]["start"];
  }
  return FavoriteResult(
      favoriteMap: newFavoriteMap,
      postMap: newPostMap,
      indexes: newIndexes,
      endCursor: newEndCursor,
      startCursor: newStartCursor,
      accountMap: newAccountMap);
}
