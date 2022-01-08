import 'dart:async';
import 'package:get/get.dart';
import 'package:chat/types/types.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/common.dart';
import 'package:chat/app/ui_utils/location.dart';

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

class PageState {
  bool isHomeInitial;
  bool isLoadingHomePosts;

  bool isDataEmpty;
  bool isReachHomePostsEnd;

  int currentIndex;

  String name;
  String homeInitError;

  String? homePostsFirstCursor;
  String? homePostsLastCursor;
  // [{first:"",end:"",expiresAt:""}]
  List<Skip> skips = [];

  List<String> postIndexes = [];

  // final String storageHomeFirstCursorKey;

  PageState({
    this.isHomeInitial = false,
    this.isLoadingHomePosts = false,
    this.currentIndex = 0,
    this.name = 'Home',
    this.homeInitError = '',
    this.homePostsFirstCursor,
    this.homePostsLastCursor,
    this.isDataEmpty = false,
    this.isReachHomePostsEnd = false,
    // required this.storageHomeFirstCursorKey,
  });
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
  final int? endDistance;

  PostsFilter({this.gender, this.startAge, this.endAge, this.endDistance});

  static PostsFilter empty() {
    return PostsFilter();
  }
}

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final pageState = RxMap<String, PageState>(
      {"home": PageState(), "nearby": PageState(name: 'Nearby')});

  final isLoadingHomePosts = false.obs;

  final _currentPage = 'home'.obs;
  String get currentPage => _currentPage.value;

  final isMeInitial = false.obs;
  final myPostsIndexes = RxList<String>([]);
  final isLoadingMyPosts = false.obs;

  final postMap = RxMap<String, PostEntity>({});

  final Rx<PostsFilter> postsFilter = PostsFilter.empty().obs;

  @override
  void onReady() async {
    super.onReady();
    await initReady();
  }

  Future<void> initReady() async {
    try {
      isLoadingHomePosts.value = true;
      await initSkips();
      await getHomePosts();
      isLoadingHomePosts.value = false;
      pageState[currentPage]!.isHomeInitial = true;
    } catch (e) {
      isLoadingHomePosts.value = false;
      pageState[currentPage]!.isHomeInitial = true;
      pageState[currentPage]!.homeInitError = e.toString();

      UIUtils.showError(e);
    }
  }

  Future<PostsResult> getRawPosts(
      {String? after,
      String? before,
      String? selectedGender,
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

  Future<List<String>> getHomePosts({
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
    if (postsFilter.value.gender != null && postsFilter.value.gender != 'all') {
      {
        selectedGender = postsFilter.value.gender;
      }
    }
    double? longitude;
    double? latitude;
    double? distance;
    if (currentPage == "nearby") {
      // get location
      final location = await getLocation();
      longitude = location.longitude;
      latitude = location.latitude;
      distance = 50000;
    }
    final result = await getRawPosts(
        longitude: longitude,
        latitude: latitude,
        distance: distance,
        after: after,
        before: before,
        skips: pageState[currentPage]!.skips,
        url: "/post/posts",
        startAge: startAge,
        endAge: endAge,
        selectedGender: selectedGender);
    if (result.indexes.isNotEmpty &&
        result.endCursor != null &&
        result.startCursor != null) {
      postMap.addAll(result.postMap);

      if (replace) {
        pageState[currentPage]!.postIndexes.clear();
      }

      pageState[currentPage]!.postIndexes.addAll(result.indexes);

      var isFirstCursorChanged = false;
      if (after == null && before == null) {
        // first request
        pageState[currentPage]!.homePostsFirstCursor = result.startCursor;
        pageState[currentPage]!.homePostsLastCursor = result.endCursor;
        isFirstCursorChanged = true;
      } else if (before != null && after == null) {
        pageState[currentPage]!.homePostsFirstCursor = result.startCursor;
        isFirstCursorChanged = true;
      } else if (after != null && before == null) {
        pageState[currentPage]!.homePostsLastCursor = result.endCursor;
      }
      // put accoutns to simple accounts
      await AuthProvider.to.saveSimpleAccounts(result.accountMap);
      patchPostCountView(result.indexes[0]).catchError((e) {
        report(e);
      });
      // save current first cursor
      if (isFirstCursorChanged &&
          pageState[currentPage]!.homePostsFirstCursor != null) {
        await CacheProvider.to.setExpiredString(
            "STORAGE_${currentPage}_FIRST_CURSOR_KEY",
            pageState[currentPage]!.homePostsFirstCursor!,
            getExpiresAt());
      }
    } else {
      if (replace) {
        pageState[currentPage]!.isDataEmpty = true;
      }
      pageState[currentPage]!.isReachHomePostsEnd = true;
      if (pageState[currentPage]!.isHomeInitial == false) {
        pageState[currentPage]!.isDataEmpty = true;
      }
    }

    isLoadingHomePosts.value = false;
    return result.indexes;
  }

  Future<void> initSkips() async {
    if (ConfigProvider.to.skipViewedPost.value == false) {
      return;
    }
    final now = DateTime.now();
    // 1. check expires _skips
    final List<Skip> validSkips = [];
    CacheProvider.to.parseObjectList("STORAGE_${currentPage}_SKIPS_KEY",
        (value) {
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
    final firstCursorValue = await CacheProvider.to
        .getExpiredString("STORAGE_${currentPage}_FIRST_CURSOR_KEY");
    final lastCursorValue = await CacheProvider.to
        .getExpiredString("STORAGE_${currentPage}_LAST_CURSOR_KEY");
    if (firstCursorValue != null &&
        lastCursorValue != null &&
        firstCursorValue != lastCursorValue) {
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
      pageState[currentPage]!.skips.addAll(validSkips);
    }
    // _skips most 6 groups;
    if (pageState[currentPage]!.skips.length > 6) {
      pageState[currentPage]!
          .skips
          .removeRange(6, pageState[currentPage]!.skips.length);
    }
    // save to store
    await CacheProvider.to.putObjectList(
        "STORAGE_${currentPage}_SKIPS_KEY", pageState[currentPage]!.skips);
  }

  Future<List<String>> getMePosts({String? after}) async {
    isLoadingMyPosts.value = true;
    final result = await getRawPosts(after: after, url: "/post/me/posts");
    postMap.addAll(result.postMap);
    myPostsIndexes.addAll(result.indexes);
    await AuthProvider.to.saveSimpleAccounts(result.accountMap);

    isLoadingMyPosts.value = false;
    if (isMeInitial.value == false) {
      isMeInitial.value = true;
    }
    return result.indexes;
  }

  insertEntity() async {}

  void setIndex({required int index}) {
    var backgroundColor = BACKGROUND_COLORS[0].value;

    pageState[currentPage]!.currentIndex = index;

    if (index >= pageState[currentPage]!.postIndexes.length) {
      // loading more
    } else {
      final post = postMap[pageState[currentPage]!.postIndexes[index]];
      if (post != null) {
        backgroundColor = post.backgroundColor;
        patchPostCountView(pageState[currentPage]!.postIndexes[index])
            .catchError((e) {
          report(e);
        });
      }
    }

    BottomNavigationBarController.to.changeBackgroundColor(backgroundColor);

    if (pageState[currentPage]!.postIndexes.length >= 3 &&
        pageState[currentPage]!.postIndexes.length - index < 3) {
      if (!isLoadingHomePosts.value &&
          pageState[currentPage]!.isDataEmpty == false) {
        isLoadingHomePosts.value = true;
        String? after;
        if (pageState[currentPage]!.homePostsLastCursor != null) {
          after = pageState[currentPage]!.homePostsLastCursor;
        }
        getHomePosts(after: after).then((data) {
          isLoadingHomePosts.value = false;
        }).catchError((e) {
          isLoadingHomePosts.value = false;
          UIUtils.showError(e);
        });
      } else if (pageState[currentPage]!.isReachHomePostsEnd &&
          isLoadingHomePosts.value == false) {
        Log.debug("reach post end");
        // maybe loading newest posts

        // put current array to _skips array
        if (pageState[currentPage]!.homePostsFirstCursor != null &&
            pageState[currentPage]!.homePostsLastCursor != null) {
          pageState[currentPage]!.skips.insert(
              0,
              Skip(
                  start: pageState[currentPage]!.homePostsFirstCursor!,
                  end: pageState[currentPage]!.homePostsLastCursor!,
                  expiresAt: getExpiresAt()));

          // save _skips
          CacheProvider.to
              .putObjectList(
                  'STORAGE_${currentPage}_SKIPS_KEY',
                  pageState[currentPage]!
                      .skips
                      .map((item) => item.toJson())
                      .toList())
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
    // 强制更新
    pageState[currentPage] = pageState[currentPage]!;
  }

  void refreshHomePosts() {
    if (isLoadingHomePosts.value == false) {
      isLoadingHomePosts.value = true;
      getHomePosts(replace: true).then((data) {
        isLoadingHomePosts.value = false;
        if (data.isNotEmpty) {
          setIndex(index: 0);
        }
      }).catchError((e) {
        isLoadingHomePosts.value = false;
        UIUtils.showError(e);
      });
    }
  }

  Future<void> patchPostCountView(String postId) async {
    // change last cursor
    await CacheProvider.to.setExpiredString(
        'STORAGE_${currentPage}_LAST_CURSOR_KEY',
        postMap[postId]!.cursor,
        getExpiresAt());
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

  void onSubmittedFilter({
    required int startAge,
    required int endAge,
    required String selectedGender,
    required int endDistance,
  }) async {
    postsFilter(PostsFilter(
        gender: selectedGender,
        startAge: startAge,
        endAge: endAge,
        endDistance: endDistance));
    // first init skips,
    try {
      pageState[currentPage]!.postIndexes.clear();
      pageState[currentPage]!.currentIndex = 0;
      isLoadingHomePosts.value = true;
      await initSkips();
      await getHomePosts(replace: true);
      isLoadingHomePosts.value = false;
    } catch (e) {
      isLoadingHomePosts.value = false;

      pageState[currentPage]!.homeInitError = e.toString();
    }
  }

  Future<SimpleAccountEntity?> getOtherAccount(
      {required String id, bool persist = false}) async {
    if (AuthProvider.to.simpleAccountMap[id] == null) {
      final result = await APIProvider.to.get('/account/accounts/$id');
      final account =
          SimpleAccountEntity.fromJson(result["data"]["attributes"]);
      await AuthProvider.to.saveSimpleAccounts({result["data"]["id"]: account},
          persist: persist);
      return account;
    }
    return null;
  }

  onPressedTabSwitch(String page) async {
    _currentPage.value = page;
    if (!pageState[page]!.isHomeInitial) {
      await initReady();
      setIndex(index: 0);
    }
  }
}

DateTime getExpiresAt({int days = 7}) {
  final now = DateTime.now();
  final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      now.millisecondsSinceEpoch + Duration(days: 7).inMilliseconds);
  return expiresAt;
}
