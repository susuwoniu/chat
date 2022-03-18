import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/utils/random.dart';
import 'package:get/get.dart';
import '../controllers/post_square_controller.dart';
import 'package:chat/common.dart';
import '../../me/views/small_post.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:flutter/services.dart';
import 'package:chat/app/common/get_time_stop.dart';

class PostSquareView extends GetView<PostSquareController> {
  final _title = Get.arguments['title'];
  final _id = int.parse(Get.arguments['id']);
  final backgroundColorIndex = get_random_index(BACKGROUND_COLORS.length);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final backgroundColor = BACKGROUND_COLORS[backgroundColorIndex];
    final frontColor = FRONT_COLORS[backgroundColorIndex];

    final postMap = controller.postMap;
    final height = AppBar().preferredSize.height;
    final safePadding = MediaQuery.of(context).padding.top;

    return RefreshIndicator(
        color: backgroundColor,
        backgroundColor: Colors.white,
        onRefresh: () => Future.sync(
              () => controller.pagingController.refresh(),
            ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(alignment: AlignmentDirectional.topCenter, children: [
            CustomScrollView(slivers: [
              SliverAppBar(
                systemOverlayStyle:
                    SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
                iconTheme: IconThemeData(color: Colors.white),
                stretch: true,
                pinned: true,
                backgroundColor: backgroundColor,
                actions: [_dropButton()],
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                      padding: EdgeInsets.fromLTRB(
                          25, safePadding + height + 10, 25, 0),
                      width: _width,
                      child: Column(children: [
                        Text('# ' + _title,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                color: frontColor)),
                        SizedBox(height: 20),
                        Obx(() {
                          final usedCount = controller.usedCount;
                          return Text(
                              usedCount > 1
                                  ? usedCount > 9999
                                      ? '9999+' + ' Posts'.tr
                                      : usedCount.toString() + ' Posts'.tr
                                  : usedCount.toString() + ' Post'.tr,
                              style:
                                  TextStyle(fontSize: 16.0, color: frontColor));
                        }),
                      ])),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 15)),
              PagedSliverGrid<String?, String>(
                  showNewPageProgressIndicatorAsGridChild: false,
                  showNewPageErrorIndicatorAsGridChild: false,
                  showNoMoreItemsIndicatorAsGridChild: false,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.75,
                    crossAxisCount: 2,
                  ),
                  pagingController: controller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<String>(
                      noItemsFoundIndicatorBuilder: (BuildContext context) {
                    return Empty();
                  }, itemBuilder: (context, id, index) {
                    final post = postMap[id]!;
                    final author =
                        AuthProvider.to.simpleAccountMap[post.accountId]!;
                    return SmallPost(
                        postId: id,
                        type: 'needName',
                        name: author.name,
                        uri: author.avatar?.thumbnail.url,
                        index: index,
                        onTap: () {
                          controller.setIndex(index: index);
                          Get.toNamed(Routes.POST_SQUARE_CARD_VIEW,
                              arguments: {'color': post.color});
                        },
                        post: post);
                  })),
              SliverToBoxAdapter(
                  child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 12),
                height: 80,
                child: Obx(() => Text(
                      controller.isReachHomePostsEnd ? 'no_more'.tr : '',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    )),
              ))
            ]),
            Positioned(
                bottom: 35,
                child: _join(Theme.of(context).colorScheme.onPrimary))
          ]),
        ));
  }

  Widget _dropButton() {
    return Container(
        margin: EdgeInsets.only(right: 15),
        child: DropdownButton<String>(
          dropdownColor: Colors.white,
          icon: Icon(Icons.swap_vert_outlined, color: Colors.white),
          iconSize: 28,
          elevation: 0,
          borderRadius: BorderRadius.circular(12),
          underline: Container(
            height: 0,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.setListOrder(newValue);
            }
          },
          items: <String>['In_chronological_order', 'By_hot_degree']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Obx(
                  () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(value.tr,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: controller.listOrder.value == value
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                        controller.listOrder.value == value
                            ? Icon(
                                Icons.check_outlined,
                                size: 20,
                                color: Color(0xFF7371fc),
                              )
                            : SizedBox.shrink(),
                      ]),
                ));
          }).toList(),
        ));
  }

  Widget _join(Color color) {
    return GestureDetector(
      onTap: () {
        if (getTimeStop() > 0) {
          UIUtils.showError("It's_not_time_to_post_yet".tr);
        } else {
          Get.toNamed(Routes.CREATE, arguments: {
            "id": _id.toString(),
            "background-color-index": backgroundColorIndex,
          });
        }
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: ChatThemeData.baseBlack),
          child: Row(children: [
            Avatar(
                name: AuthProvider.to.account.value.name,
                uri: AuthProvider.to.account.value.avatar?.thumbnail.url,
                size: 16),
            SizedBox(width: 8),
            Text('Join_topic'.tr,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                )),
          ])),
    );
  }
}
