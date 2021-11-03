import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      body: TikTokStyleFullPageScroller(
        contentSize: controller.postIndexes.length,
        swipePositionThreshold: 0.2,
        // ^ the fraction of the screen needed to scroll
        swipeVelocityThreshold: 2000,
        // ^ the velocity threshold for smaller scrolls
        animationDuration: const Duration(milliseconds: 300),
        // ^ how long the animation will take
        onScrollEvent: _handleCallbackEvent,
        // ^ registering our own function to listen to page changes
        builder: (BuildContext context, int index) {
          return Container(
              color: HexColor(controller
                  .postMap[controller.postIndexes[index]]!.backgroundColor),
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () async {
                  print("tap");
                  Get.rootDelegate.toNamed(Routes.ROOM);
                },
                child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 50.0, left: 16, right: 16),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: [
                            AppBar(
                                leading: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.settings,
                                    color: IconTheme.of(context).color,
                                  ),
                                  onPressed: () {
                                    Get.rootDelegate.toNamed(Routes.SETTING);
                                  },
                                ),
                                actions: <Widget>[CircleAvatar()]),
                            Padding(
                              child: Obx(() => Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    controller
                                            .postMap[
                                                controller.postIndexes[index]]!
                                            .content *
                                        100,
                                    key: Key('$index-text'),
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 8,
                                  ))),
                              padding: const EdgeInsets.only(right: 0),
                            ),
                            Row(children: [
                              TextButton(
                                onPressed: () async {},
                                child: CircleAvatar(),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(right: 0.0)),
                              Text(
                                '$index',
                                key: Key('$index-text'),
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ]),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 60,
                            width: screenWidth * 0.88,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            child: Row(children: [
                              TextButton(
                                onPressed: () async {},
                                child: CircleAvatar(radius: 25),
                              ),
                              Text(
                                '$index',
                                key: Key('$index-text'),
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ]),
                          ),
                        )
                      ],
                    )),
              ));
        },
      ),
    );
  }

  void _handleCallbackEvent(ScrollEventType type, {int? currentIndex}) {
    if (currentIndex != null && currentIndex > 0) {
      controller.setIndex(currentIndex);
    }
    print(
        "Scroll callback received with data: {type: $type, and index: ${currentIndex ?? 'not given'}}");
  }
}
