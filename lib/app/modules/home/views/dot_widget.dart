import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import 'package:chat/common.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

class DotWidget extends StatelessWidget {
  final void Function() onPressedReport;
  final String postId;

  DotWidget({
    Key? key,
    required this.onPressedReport,
    required this.postId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Wrap(alignment: WrapAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(bottom: _height * 0.18),
        width: _width * 0.96,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          Row(children: [
            Obx(() {
              final isFavorite = HomeController.to.postMap[postId]?.is_favorite;
              final isStar =
                  HomeController.to.postMap[postId]?.is_favorite ?? false;
              return _buttons(
                  icon: isStar ? Icons.star_rounded : Icons.star_border_rounded,
                  text: isStar ? 'Marked' : 'Mark',
                  iconSize: 32,
                  onPressed: () async {
                    Navigator.pop(context);
                    if (isStar) {
                      try {
                        await HomeController.to.patchFavorite(
                            postId: postId,
                            increase: false,
                            current: isFavorite);
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                    } else {
                      try {
                        await HomeController.to.patchFavorite(
                            postId: postId,
                            increase: true,
                            current: isFavorite);
                        UIUtils.toast("Marked.".tr);
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                    }
                  });
            }),
            SizedBox(width: 18),
            _buttons(
                icon: Icons.ios_share_outlined,
                text: 'Share',
                onPressed: () async {
                  Navigator.pop(context);
                  final FlutterShareMe flutterShareMe = FlutterShareMe();
                  // TODO right share url
                  final response =
                      await flutterShareMe.shareToSystem(msg: "test");
                  print(response);
                }),
            SizedBox(width: 18),
            _buttons(
                icon: Icons.feedback_outlined,
                text: 'Report',
                onPressed: onPressedReport)
          ]),
          SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(Routes.MY_SINGLE_POST,
                          arguments: {"id": postId}, preventDuplicates: false);
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(10)),
                        child:
                            Text('More'.tr, style: TextStyle(fontSize: 16)))))
          ]),
          SizedBox(height: 20),
          Row(children: [
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(10)),
                        child:
                            Text('Cancel'.tr, style: TextStyle(fontSize: 16)))))
          ]),
        ]),
      ),
    ]);
  }

  Widget _buttons({
    required IconData icon,
    required String text,
    required Function onPressed,
    double iconSize = 28,
  }) {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              onPressed();
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                  color: Color(0xfff2f2f7),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, size: iconSize, color: Color(0xff46494c)),
                    SizedBox(height: 8),
                    Text(text.tr,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff46494c))),
                  ]),
            )));
  }
}
