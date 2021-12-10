import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/widges/max_text.dart';
import 'package:chat/config/config.dart';
import 'package:chat/app/widges/avatar.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final imDomain = AppConfig().config.imDomain;
    final appBar = AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Text("🤓", style: Theme.of(context).textTheme.headline5),
          onPressed: () {
            Get.toNamed(Routes.SETTING);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Text("🔑"),
            onPressed: () {
              Get.toNamed(
                Routes.DEBUG,
              );
            },
          ),
          IconButton(
            icon: Text("🐻"),
            onPressed: () {
              Get.toNamed(
                Routes.LOGIN,
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Obx(() {
              final isLogin = AuthProvider.to.isLogin;
              if (isLogin) {
                final account = AuthProvider.to.account.value;

                return IconButton(
                  icon: Avatar(name: account.name, uri: account.avatar),
                  onPressed: () {
                    Get.toNamed(Routes.ME);
                  },
                );
              } else {
                return SizedBox.shrink();
              }
            }),
          )
        ]);

    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: appBar,
        body: Obx(() {
          final isLogin = AuthProvider.to.isLogin;
          final account = AuthProvider.to.account.value;
          return TikTokStyleFullPageScroller(
            contentSize: controller.postIndexes.length + 1,
            swipePositionThreshold: 0.2,
            swipeVelocityThreshold: 2000,
            animationDuration: const Duration(milliseconds: 300),
            onScrollEvent: _handleCallbackEvent,
            builder: (BuildContext context, int index) {
              return Container(
                  color: index < controller.postIndexes.length
                      ? HexColor(controller
                          .postMap[controller.postIndexes[index]]!
                          .backgroundColor)
                      : Colors.blue,
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      final post =
                          controller.postMap[controller.postIndexes[index]]!;
                      Get.toNamed(Routes.ROOM, arguments: {
                        "id": "im${post.accountId}@$imDomain",
                        "post_id": controller.postIndexes[index]
                      });
                    },
                    child: SafeArea(
                      child: index == controller.postIndexes.length &&
                              controller.isLoadingHomePosts.value
                          ? Text("loading")
                          : index == controller.postIndexes.length &&
                                  controller.isDataEmpty.value
                              ? Text("no data")
                              : Builder(builder: (BuildContext context) {
                                  final post = controller
                                      .postMap[controller.postIndexes[index]]!;
                                  final author = AuthProvider
                                      .to.simpleAccountMap[post.accountId]!;
                                  return Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 16, right: 16),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MaxText(
                                                post.content,
                                                context,
                                                // textDirection: TextDirection.ltr,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  height: 1.6,
                                                  fontSize: 26.0,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 20, bottom: 120),
                                                child: Row(children: [
                                                  TextButton(
                                                    onPressed: () async {},
                                                    child: Avatar(
                                                        name: author.name,
                                                        uri: author.avatar),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0)),
                                                  Text(
                                                    author.name,
                                                    key: Key('$index-text'),
                                                    style: const TextStyle(
                                                        fontSize: 24,
                                                        color: Colors.white),
                                                  ),
                                                ]),
                                              ),
                                            ]),
                                      ),
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 40),
                                            child: SafeArea(
                                              child: Container(
                                                height: 60,
                                                width: screenWidth * 0.88,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.white,
                                                ),
                                                child: Row(children: [
                                                  TextButton(
                                                      onPressed: () async {},
                                                      child: isLogin
                                                          ? Avatar(
                                                              uri: account
                                                                  .avatar,
                                                              name:
                                                                  account.name)
                                                          : Text("🤠",
                                                              style: const TextStyle(
                                                                  fontSize: 32,
                                                                  color: Colors
                                                                      .white))),
                                                  Text(
                                                    '$index',
                                                    key: Key('$index-text'),
                                                    style: const TextStyle(
                                                        fontSize: 24,
                                                        color: Colors.white),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ))
                                    ],
                                  );
                                }),
                    ),
                  ));
            },
          );
        }));
  }

  void _handleCallbackEvent(ScrollEventType type, {int? currentIndex}) {
    if (currentIndex != null && currentIndex > 0) {
      controller.setIndex(currentIndex);
      controller.PatchPostCountView(controller.postIndexes[currentIndex]);
    }
    print(
        "Scroll callback received with data: {type: $type, and index: ${currentIndex ?? 'not given'}}");
  }
}
