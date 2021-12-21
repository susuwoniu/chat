import 'package:chat/app/modules/post/views/templates.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../controllers/post_controller.dart';
import 'package:tcard/tcard.dart';
import './templates.dart';
import 'package:chat/common.dart';
import 'package:chat/utils/random.dart';

class PostView extends GetView<PostController> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("PostView"),
              centerTitle: true,
            ),
            body: Obx(() {
              final isLoading = controller.isLoading.value;
              final isEmpty = controller.isDataEmpty.value;
              final isReachEnd = controller.isReachEnd.value;
              final initError = controller.initError.value;
              final isInit = controller.isInit.value;
              if (!isInit || isLoading) {
                return Center(child: Loading());
              } else if (isEmpty) {
                return Center(
                    child:
                        Retry(message: "暂无数据~", onRetry: controller.getPosts));
              } else if (isReachEnd) {
                return Center(
                    child: Retry(
                        message: "没有更多数据啦~",
                        onRetry: () {
                          controller.getPosts(before: controller.firstCursor);
                        }));
              } else if (PostController.to.postTemplatesIndexes.isNotEmpty) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 15),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: _width * 0.075),
                        child: Text("Select_a_question".tr,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 10),
                      TCard(
                        size: Size(_width * 0.95,
                            MediaQuery.of(context).size.height * 0.7),
                        cards: List.generate(
                          PostController.to.postTemplatesIndexes.length,
                          (int index) {
                            final _item = PostController.to.postTemplatesMap[
                                PostController.to.postTemplatesIndexes[index]];
                            final backgroundColor =
                                get_random_element(BACKGROUND_COLORS);

                            return GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.ANSWER, arguments: {
                                    "id":
                                        controller.postTemplatesIndexes[index],
                                    "background-color": backgroundColor.value
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(10)),
                                    color: backgroundColor,
                                  ),
                                  child: Templates(
                                      question: _item!.content,
                                      enabled: false,
                                      id: PostController
                                          .to.postTemplatesIndexes[index]),
                                ));
                          },
                        ),
                        controller: controller.tcardController,
                        onForward: (index, info) {
                          controller.setIndex(index);
                        },
                        onBack: (index, info) {
                          controller.setIndex(index);
                        },
                        onEnd: () {
                          print('end');
                        },
                      ),
                    ],
                  ),
                );
              } else if (initError != null) {
                return Center(child: Text(initError.toString()));
              } else {
                return Center(child: Text('出错了'));
              }
            })));
  }
}
