import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/explore_controller.dart';
import 'package:chat/common.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'single_explore.dart';

class ExploreView extends GetView<ExploreController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'ExploreView'.tr,
            style: TextStyle(fontSize: 16),
          ),
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
        ),
        body: SafeArea(
            child: RefreshIndicator(
          backgroundColor: Theme.of(context).colorScheme.surface,
          onRefresh: () => Future.sync(
            () => controller.pagingController.refresh(),
          ),
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: 12),
            ), // Bug fix: https://github.com/flutter/flutter/issues/55170,
            PagedSliverGrid<String?, String>(
                showNewPageProgressIndicatorAsGridChild: false,
                showNewPageErrorIndicatorAsGridChild: false,
                showNoMoreItemsIndicatorAsGridChild: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 5,
                  crossAxisCount: 1,
                ),
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<String>(
                    noItemsFoundIndicatorBuilder: (BuildContext context) {
                  return Empty();
                }, itemBuilder: (context, id, index) {
                  final postTemplate = controller.postTemplatesMap[id]!;

                  return SingleExplore(
                    postTemplateId: id,
                    postTemplate: postTemplate,
                    index: index,
                    onTap: () {
                      Get.toNamed(Routes.POST_SQUARE,
                          arguments: {"id": id, "title": postTemplate.title});
                    },
                  );
                })),
          ]),
        )));
  }
}
