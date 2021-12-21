import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:chat/app/widgets/max_text.dart';
import '../controllers/my_single_post_controller.dart';
import '../../home/controllers/home_controller.dart';
import 'viewers_list.dart';

class MySinglePostView extends GetView<MySinglePostController> {
  final _content = Get.arguments['content'];
  final _backgroundColor = (Get.arguments['backgroundColor']);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _homeController = HomeController.to;
    final _postId = Get.arguments['postId'];

    return Scaffold(
        appBar: AppBar(
          title: Text('MySinglePostView'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            margin: EdgeInsets.fromLTRB(_width * 0.03, 10, _width * 0.03, 10),
            padding: EdgeInsets.symmetric(
                vertical: _width * 0.02, horizontal: _width * 0.04),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(_backgroundColor),
            ),
            height: _height * 0.4,
            width: _width * 0.95,
            child: MaxText(
              _content,
              context,
              // textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                height: 1.6,
                fontSize: 26.0,
              ),
            ),
          ),
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
        ])));
  }
}
