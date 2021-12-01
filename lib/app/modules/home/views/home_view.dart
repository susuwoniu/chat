import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/widges/main_bottom_navigation_bar.dart';
import 'package:chat/app/widges/max_text.dart';
import 'package:chat/config/config.dart';

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
            child: IconButton(
              icon: CircleAvatar(),
              onPressed: () {
                Get.toNamed(Routes.ME);
              },
            ),
          )
        ]);

    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: appBar,
        body: Obx(
          () => TikTokStyleFullPageScroller(
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
                      Get.toNamed(Routes.ROOM, arguments: {
                        "id":
                            "im${controller.postMap[controller.postIndexes[index]]!.accountId}@$imDomain"
                      });
                    },
                    child: SafeArea(
                      child: index == controller.postIndexes.length &&
                              controller.isLoading.value
                          ? Text("loading")
                          : index == controller.postIndexes.length &&
                                  controller.isDataEmpty.value
                              ? Text("no data")
                              : Stack(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 16, right: 16),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MaxText(
                                              controller
                                                      .postMap[controller
                                                          .postIndexes[index]]!
                                                      .content *
                                                  100,
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
                                                  child:
                                                      CircleAvatar(radius: 28),
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0)),
                                                Text(
                                                  '$index',
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
                                          padding:
                                              const EdgeInsets.only(bottom: 40),
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
                                                  child:
                                                      CircleAvatar(radius: 25),
                                                ),
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
                                ),
                    ),
                  ));
            },
          ),
        ));
  }

  void _handleCallbackEvent(ScrollEventType type, {int? currentIndex}) {
    if (currentIndex != null && currentIndex > 0) {
      controller.setIndex(currentIndex);
    }
    print(
        "Scroll callback received with data: {type: $type, and index: ${currentIndex ?? 'not given'}}");
  }
}
