import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_single_post_controller.dart';
import '../../home/controllers/home_controller.dart';
import 'viewers_list.dart';
import 'package:intl/intl.dart';
import 'single_post_dot.dart';

class MySinglePostView extends GetView<MySinglePostController> {
  final _postId = (Get.arguments['postId']);
  final DateFormat formatter = DateFormat('yyyy-MM-dd  H:mm');

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _homeController = HomeController.to;

    final _post = HomeController.to.postMap[_postId]!;
    final _content = _post.content;
    final _backgroundColor = _post.backgroundColor;

    final String _createAt = formatter.format(DateTime.parse(_post.created_at));

    return Scaffold(
        appBar: AppBar(
          title: Text('MySinglePostView'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(children: [
            Container(
                margin: EdgeInsets.fromLTRB(12, 6, 12, 23),
                padding: EdgeInsets.fromLTRB(15, 5, 0, 25),
                constraints: BoxConstraints(minHeight: _height * 0.4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(_backgroundColor),
                ),
                width: _width * 0.9,
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _createAt,
                          style: TextStyle(color: Colors.black45),
                        ),
                        Row(children: [
                          Obx(() => Text(
                                controller.visibility.tr,
                                style: TextStyle(color: Colors.black45),
                              )),
                          _dotIcon(context: context, postId: _postId)
                        ]),
                      ]),
                  Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(_content,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                          ))),
                ])),
            Obx(() {
              final post = _homeController.postMap[_postId]!;

              final isLoading = post.isLoadingViewersList;

              final List<Widget> list = post.views != null
                  ? post.views!.isNotEmpty
                      ? post.views!.map((e) {
                          final account = AuthProvider.to.simpleAccountMap[e];
                          return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: _width * 0.04),
                              child: ViewersList(
                                  name: account!.name,
                                  img: account.avatar,
                                  likeCount: account.like_count,
                                  viewerId: e));
                        }).toList()
                      : [Container(child: Text("no_one_has_seen_it_yet".tr))]
                  : [];

              final Widget loadingWidget =
                  isLoading ? Container(child: Text("loading")) : Container();

              list.add(loadingWidget);

              return Column(children: list);
            }),
          ]),
        ));
  }

  Widget _dotIcon({required BuildContext context, required String postId}) {
    return IconButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SinglePostDot(
                    postId: postId,
                    onPressedVisibility: (String visibility) async {
                      try {
                        UIUtils.showLoading();
                        await controller.postVisibility(
                            type: visibility, postId: postId);
                        UIUtils.toast('okk');
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                      UIUtils.hideLoading();
                      Navigator.pop(context);
                    },
                    onPressedDelete: () async {
                      try {
                        UIUtils.showLoading();
                        await controller.onDeletePost(postId);
                        UIUtils.toast('okk');
                        Get.back();
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                      UIUtils.hideLoading();
                      Navigator.pop(context);
                    });
              });
        },
        icon: Icon(
          Icons.more_vert_rounded,
          size: 26,
          color: Colors.black87,
        ));
  }
}
