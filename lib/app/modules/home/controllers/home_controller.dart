import 'dart:async';

import 'package:get/get.dart';
import 'package:chat/types/types.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';
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

class PostsFilter {
  final String? gender;
  final int? startAge;
  final int? endAge;

  PostsFilter({
    this.gender,
    this.startAge,
    this.endAge,
  });

  static PostsFilter empty() {
    return PostsFilter();
  }
}

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final isHomeInitial = false.obs;
  final isMeInitial = false.obs;
  final currentIndex = RxInt(0);
  final postIndexes = RxList<String>([]);
  final myPostsIndexes = RxList<String>([]);
  final homeInitError = RxnString();
  final isLoadingHomePosts = false.obs;
  String? homePostsFirstCursor;
  String? homePostsLastCursor;
  // [{first:"",end:"",expiresAt:""}]
  final List<Skip> _skips = [];

  final isLoadingMyPosts = false.obs;

  final isDataEmpty = false.obs;
  final isReachHomePostsEnd = false.obs;

  final postMap = RxMap<String, PostEntity>({});

  final postTemplatesIndexes = RxList<String>([]);
  final postTemplatesMap = RxMap<String, PostTemplatesEntity>({});

  final Rx<PostsFilter> postsFilter = PostsFilter.empty().obs;

  @override
  void onReady() async {
    try {
      isLoadingHomePosts.value = true;
      super.onReady();
      await initSkips();
      await getHomePosts();
      isLoadingHomePosts.value = false;
      isHomeInitial.value = true;
    } catch (e) {
      isLoadingHomePosts.value = false;
      isHomeInitial.value = true;
      homeInitError.value = e.toString();

      UIUtils.showError(e);
    }
  }

  Future<PostsResult> getRawPosts(
      {String? after,
      String? before,
      String? selectedGender,
      int? startAge,
      int? endAge,
      required String url,
      List<Skip>? skips}) async {
    Map<String, dynamic> query = {};
    if (after != null) {
      query["after"] = after;
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
    final body = await APIProvider.to.get(url, query: query);
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
          newAccountMap[v["id"]] =
              SimpleAccountEntity.fromJson(v["attributes"]);
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

  getHomePosts({
    String? after,
    String? before,
    bool replace = false,
  }) async {
    int? startAge;
    int? endAge;
    String? selectedGender;
    // 默认98
    if (postsFilter.value.endAge != null &&
        postsFilter.value.endAge != DEFAULT_END_AGE) {
      {
        endAge = postsFilter.value.endAge;
      }
    }
    // 默认18
    if (postsFilter.value.startAge != null &&
        postsFilter.value.startAge != DEFAULT_START_AGE) {
      {
        startAge = postsFilter.value.startAge;
      }
    }
    if (postsFilter.value.gender != null) {
      {
        selectedGender = postsFilter.value.gender;
      }
    }
    final result = await getRawPosts(
        after: after,
        before: before,
        skips: _skips,
        url: "/post/posts",
        startAge: startAge,
        endAge: endAge,
        selectedGender: selectedGender);
    if (result.indexes.isNotEmpty &&
        result.endCursor != null &&
        result.startCursor != null) {
      postMap.addAll(result.postMap);

      postIndexes.addAll(result.indexes);

      var isFirstCursorChanged = false;
      if (after == null && before == null) {
        // first request
        homePostsFirstCursor = result.startCursor;
        homePostsLastCursor = result.endCursor;
        isFirstCursorChanged = true;
      } else if (before != null && after == null) {
        homePostsFirstCursor = result.startCursor;
        isFirstCursorChanged = true;
      } else if (after != null && before == null) {
        homePostsLastCursor = result.endCursor;
      }
      // put accoutns to simple accounts
      await AuthProvider.to.saveSimpleAccounts(result.accountMap);
      patchPostCountView(result.indexes[0]).catchError((e) {
        report(e);
      });
      // save current first cursor
      if (isFirstCursorChanged && homePostsFirstCursor != null) {
        await CacheProvider.to.setExpiredString(STORAGE_HOME_FIRST_CURSOR_KEY,
            homePostsFirstCursor!, getExpiresAt());
      }
    } else {
      if (replace) {
        isDataEmpty.value = true;
      }
      isReachHomePostsEnd.value = true;
      if (isHomeInitial.value == false) {
        isDataEmpty.value = true;
      }
    }

    isLoadingHomePosts.value = false;
  }

  Future<void> initSkips() async {
    final now = DateTime.now();
    // 1. check expires _skips
    final List<Skip> validSkips = [];
    CacheProvider.to.parseObjectList(STORAGE_HOME_SKIPS_KEY, (value) {
      if (value["expiresAt"] != null) {
        final expiresAt = DateTime.parse(value["expiresAt"]);
        if (expiresAt.millisecondsSinceEpoch > now.millisecondsSinceEpoch) {
          validSkips.insert(
              0,
              Skip(
                  start: value["start"],
                  end: value["end"],
                  expiresAt: expiresAt));
        }
      }
    });
    // 2. get latest first cursor , and cursor
    final firstCursorValue =
        await CacheProvider.to.getExpiredString(STORAGE_HOME_FIRST_CURSOR_KEY);
    final lastCursorValue =
        await CacheProvider.to.getExpiredString(STORAGE_HOME_LAST_CURSOR_KEY);
    if (firstCursorValue != null && lastCursorValue != null) {
      if (validSkips.isNotEmpty) {
        if (firstCursorValue != validSkips.first.start) {
          validSkips.insert(
              0,
              Skip(
                  start: firstCursorValue,
                  end: lastCursorValue,
                  expiresAt: getExpiresAt()));
        }
      } else {
        validSkips.insert(
            0,
            Skip(
                start: firstCursorValue,
                end: lastCursorValue,
                expiresAt: getExpiresAt()));
      }
    }
    if (validSkips.isNotEmpty) {
      _skips.addAll(validSkips);
    }
    // _skips most 6 groups;
    if (_skips.length > 6) {
      _skips.removeRange(6, _skips.length);
    }
    // save to store
    await CacheProvider.to.putObjectList(STORAGE_HOME_SKIPS_KEY, _skips);
  }

  getMePosts({String? after}) async {
    final result = await getRawPosts(after: after, url: "/post/me/posts");
    postMap.addAll(result.postMap);
    myPostsIndexes.addAll(result.indexes);
    await AuthProvider.to.saveSimpleAccounts(result.accountMap);

    isLoadingMyPosts.value = false;
    if (isMeInitial.value == false) {
      isMeInitial.value = true;
    }
  }

  insertEntity() async {}

  void setIndex(int index) {
    var backgroundColor = "#FFFFFF";
    currentIndex.value = index;

    if (index >= postIndexes.length) {
      // loading more
    } else {
      final post = postMap[postIndexes[index]];
      if (post != null) {
        backgroundColor = post.backgroundColor;
        patchPostCountView(postIndexes[index]).catchError((e) {
          report(e);
        });
      }
    }

    BottomNavigationBarController.to.changeBackgroundColor(backgroundColor);

    if (postIndexes.length - index < 3) {
      if (!isLoadingHomePosts.value && isDataEmpty.value == false) {
        isLoadingHomePosts.value = true;
        String? after;
        if (homePostsLastCursor != null) {
          after = homePostsLastCursor;
        }
        getHomePosts(after: after).then((data) {
          isLoadingHomePosts.value = false;
        }).catchError((e) {
          isLoadingHomePosts.value = false;
          UIUtils.showError(e);
        });
      } else if (isReachHomePostsEnd.value &&
          isLoadingHomePosts.value == false) {
        Log.debug("reach post end");
        // maybe loading newest posts

        // put current array to _skips array
        if (homePostsFirstCursor != null && homePostsLastCursor != null) {
          _skips.insert(
              0,
              Skip(
                  start: homePostsFirstCursor!,
                  end: homePostsLastCursor!,
                  expiresAt: getExpiresAt()));

          // save _skips
          CacheProvider.to
              .putObjectList(STORAGE_HOME_SKIPS_KEY,
                  _skips.map((item) => item.toJson()).toList())
              .catchError((e) {
            report(e);
          });
        }
        isLoadingHomePosts.value = true;

        getHomePosts().then((data) {
          isLoadingHomePosts.value = false;
        }).catchError((e) {
          isLoadingHomePosts.value = false;
          UIUtils.showError(e);
        });
      }
    }
  }

  Future<void> patchPostCountView(String postId) async {
    // change last cursor
    await CacheProvider.to.setExpiredString(
        STORAGE_HOME_LAST_CURSOR_KEY, postMap[postId]!.cursor, getExpiresAt());
    if (AuthProvider.to.accountId == postMap[postId]!.accountId) {
      await APIProvider.to.patch("/post/posts/$postId",
          body: {"viewed_count_action": "increase_one"});
    }
  }

  Future<void> getRawVisitorList(String postId, {String? after}) async {
    var post = postMap[postId];
    if (post != null) {
      post.isLoadingViewersList = true;
      postMap[postId] = post;
    }
    Map<String, dynamic> query = {};
    if (after != null) {
      query["after"] = after;
    }
    final body =
        await APIProvider.to.get("/post/posts/$postId/views", query: query);

    final Map<String, SimpleAccountEntity> newAccountMap = {};
    final List<String> newIndexes = [];

    // String? newEndCursor;
    for (var i = 0; i < body["data"].length; i++) {
      final item = body["data"][i];
      final viewerId = item["attributes"]["viewed_by"];
      newIndexes.add(viewerId);
    }
    if (body["included"] != null) {
      for (var v in body["included"]) {
        if (v["type"] == "accounts") {
          newAccountMap[v["id"]] =
              SimpleAccountEntity.fromJson(v["attributes"]);
        }
      }
    }
    AuthProvider.to.saveSimpleAccounts(newAccountMap);

    if (post != null) {
      post.views = newIndexes;
      post.isLoadingViewersList = false;
      postMap[postId] = post;
    }
    // if (body["meta"]["page_info"]["end"] != null) {
    //   newEndCursor = body["meta"]["page_info"]["end"];
    // }
    // return PostsResult(
    //     postMap: newPostMap, indexes: newIndexes, endCursor: newEndCursor);
  }

  void onSubmittedFilter(
      {required int startAge,
      required int endAge,
      required String selectedGender}) async {
    postsFilter(PostsFilter(
        gender: selectedGender, startAge: startAge, endAge: endAge));
    // first init skips,
    try {
      postIndexes.clear();
      currentIndex.value = 0;
      isLoadingHomePosts.value = true;
      await initSkips();
      await getHomePosts(replace: true);
      isLoadingHomePosts.value = false;
    } catch (e) {
      isLoadingHomePosts.value = false;

      homeInitError.value = e.toString();
    }
  }
}

DateTime getExpiresAt({int days = 7}) {
  final now = DateTime.now();
  final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      now.millisecondsSinceEpoch + Duration(days: 7).inMilliseconds);
  return expiresAt;
}
