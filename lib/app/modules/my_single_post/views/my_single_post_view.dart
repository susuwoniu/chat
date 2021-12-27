import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/widgets/max_text.dart';
import '../controllers/my_single_post_controller.dart';
import '../../home/controllers/home_controller.dart';
import 'viewers_list.dart';
import 'package:intl/intl.dart';
import 'single_post_dot.dart';

class MySinglePostView extends GetView<MySinglePostController> {
  final _content = Get.arguments['content'];
  final _backgroundColor = (Get.arguments['backgroundColor']);
  final String _visibility = Get.arguments['visibility'];
  final DateFormat formatter = DateFormat('yyyy-MM-dd  H:m');

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _homeController = HomeController.to;
    final _postId = Get.arguments['postId'];
    final String _createAt =
        formatter.format(DateTime.parse(Get.arguments['createAt']));

    return Scaffold(
        appBar: AppBar(
          title: Text('MySinglePostView'),
          centerTitle: true,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            Container(
                margin: EdgeInsets.fromLTRB(15, 6, 10, 15),
                padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(_backgroundColor),
                ),
                // height: _height * 0.4,
                width: _width * 0.95,
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _createAt,
                          style: TextStyle(color: Colors.black45),
                        ),
                        Row(children: [
                          Text(
                            _visibility.tr,
                            style: TextStyle(color: Colors.black45),
                          ),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return SinglePostDot(
                                          onPressedVisibility: () {
                                        Navigator.pop(context);
                                      }, onPressedDelete: () {
                                        try {
                                          controller.onDeletePost(_postId);
                                          UIUtils.toast('ok');
                                          Navigator.pop(context);
                                          Get.back();
                                        } catch (e) {
                                          UIUtils.showError(e);
                                        }
                                      });
                                    });
                              },
                              icon: Icon(
                                Icons.more_vert_rounded,
                                size: 26,
                                color: Colors.black87,
                              )),
                        ]),
                      ]),
                  Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(_content,
                          textAlign: TextAlign.center,
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
                              margin: EdgeInsets.fromLTRB(
                                  _width * 0.03, 13, _width * 0.03, 0),
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
        )));
  }
}
