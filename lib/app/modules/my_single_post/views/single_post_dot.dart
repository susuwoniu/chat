import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'visibility_sheet.dart';
import '../../home/controllers/home_controller.dart';

final VisibilityMap = {'public': 'Public', 'private': 'Private'};

class SinglePostDot extends StatelessWidget {
  final Function(String visibility) onPressedVisibility;
  final Function onPressedDelete;
  final Function onPressedPolish;
  final String postId;
  final String visibility;

  SinglePostDot({
    Key? key,
    required this.postId,
    required this.onPressedVisibility,
    required this.onPressedPolish,
    required this.onPressedDelete,
    required this.visibility,
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
            _buttons(
                context: context,
                icon: visibility == 'public'
                    ? Icons.visibility_outlined
                    : Icons.lock_outline,
                text: VisibilityMap[visibility]!.tr,
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return VisibilitySheet(
                            onPressedVisibility: onPressedVisibility);
                      });
                }),
            SizedBox(width: 20),
            Obx(() {
              final is_can_promote =
                  HomeController.to.postMap[postId]!.is_can_promote;
              return _buttons(
                  context: context,
                  icon: Icons.auto_fix_high_outlined,
                  text: 'Polish',
                  onPressed: onPressedPolish,
                  is_can_promote: is_can_promote);
            }),
            SizedBox(width: 20),
            _buttons(
                context: context,
                icon: Icons.delete_outline,
                text: 'Delete',
                onPressed: onPressedDelete)
          ]),
          Row(children: [
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
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
    required BuildContext context,
    bool? is_can_promote,
  }) {
    final _is_can_promote = is_can_promote ?? false;
    bool isColorful = false;
    if (text == 'Polish') {
      isColorful = !AuthProvider.to.account.value.vip || _is_can_promote;
    }
    return Expanded(
        child: GestureDetector(
            onTap: () {
              onPressed();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  gradient: isColorful
                      ? LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primaryVariant
                            ])
                      : null,
                  color: isColorful ? null : Color(0xfff2f2f7),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                Icon(icon,
                    size: 30,
                    color: isColorful ? Colors.white : Color(0xff46494c)),
                SizedBox(height: 5),
                Text(text.tr,
                    style: TextStyle(
                        fontSize: 14,
                        color: isColorful ? Colors.white : Color(0xff46494c))),
              ]),
            )));
  }
}
