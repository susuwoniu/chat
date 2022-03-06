import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../controllers/star_controller.dart';
import 'package:chat/app/providers/auth_provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/common.dart';
import '../../me/views/small_post.dart';

class StarView extends GetView<StarController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          centerTitle: true,
          title: Text('StarView'.tr, style: TextStyle(fontSize: 16)),
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
        ),
        body: RefreshIndicator(
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
                  childAspectRatio: 0.75,
                  crossAxisCount: 2,
                ),
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<String>(
                    noItemsFoundIndicatorBuilder: (BuildContext context) {
                  return Empty();
                }, itemBuilder: (context, id, index) {
                  final favorite = controller.favoriteMap[id]!;
                  final post = controller.postMap[favorite.post_id]!;
                  final author =
                      AuthProvider.to.simpleAccountMap[post.accountId]!;
                  return SmallPost(
                      type: 'needName',
                      postId: favorite.post_id,
                      name: author.name,
                      uri: author.avatar?.thumbnail.url,
                      index: index,
                      onTap: () {
                        Get.toNamed(Routes.MY_SINGLE_POST,
                            arguments: {"id": favorite.post_id});
                      },
                      post: post);
                })),
          ]),
        ));
  }
}
