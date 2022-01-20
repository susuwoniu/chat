import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'visibility_sheet.dart';
import '../../home/controllers/home_controller.dart';

class SinglePostDot extends StatelessWidget {
  final Function(String visibility) onPressedVisibility;
  final Function onPressedDelete;
  final Function onPressedPolish;
  final String postId;

  SinglePostDot({
    Key? key,
    required this.postId,
    required this.onPressedVisibility,
    required this.onPressedPolish,
    required this.onPressedDelete,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final _height = MediaQuery.of(context).size.height;
    // final _width = MediaQuery.of(context).size.width;

    return Wrap(alignment: WrapAlignment.center, children: [
      Container(
        padding: EdgeInsets.only(bottom: 30),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          Row(children: [
            _buttons(
                icon: Icons.lock_outline_rounded,
                text: 'Visibility',
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return VisibilitySheet(
                            onPressedVisibility: onPressedVisibility);
                      });
                }),
            Obx(() {
              final is_can_promote =
                  HomeController.to.postMap[postId]!.is_can_promote;
              return _buttons(
                  icon: Icons.auto_fix_high_outlined,
                  text: 'Polish',
                  onPressed: onPressedPolish,
                  is_can_promote: is_can_promote);
            }),
            _buttons(
                icon: Icons.delete_forever_rounded,
                text: 'Delete',
                onPressed: onPressedDelete)
          ]),
          Container(
            height: 10,
            color: Colors.grey.shade100,
          ),
          SizedBox(height: 20),
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Text('Cancel'.tr, style: TextStyle(fontSize: 16))),
        ]),
      ),
    ]);
  }

  Widget _buttons({
    required IconData icon,
    required String text,
    required Function onPressed,
    bool? is_can_promote,
  }) {
    final _is_can_promote = is_can_promote ?? false;
    bool isColorful = false;
    if (text == 'Polish') {
      isColorful = !AuthProvider.to.account.value.vip || _is_can_promote;
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: GestureDetector(
          onTap: () {
            onPressed();
          },
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  gradient: isColorful
                      ? LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.topRight,
                          colors: [
                              Colors.purple.shade400,
                              Colors.blue.shade600
                            ])
                      : null,
                  color: isColorful ? null : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(icon,
                  size: 30,
                  color: isColorful ? Colors.white : Colors.grey.shade600),
            ),
            SizedBox(height: 14),
            Text(text.tr, style: TextStyle(fontSize: 16)),
          ]),
        ));
  }
}
