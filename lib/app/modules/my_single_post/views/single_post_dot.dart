import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'visibility_sheet.dart';

class SinglePostDot extends StatelessWidget {
  final Function(String visibility) onPressedVisibility;
  final Function onPressedDelete;
  final Function onPressedPolish;
  final String postId;

  SinglePostDot(
      {Key? key,
      required this.postId,
      required this.onPressedVisibility,
      required this.onPressedPolish,
      required this.onPressedDelete})
      : super(key: key);
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
                text: 'Visibility'.tr,
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return VisibilitySheet(
                            onPressedVisibility: onPressedVisibility);
                      });
                }),
            _buttons(
                icon: Icons.auto_fix_high_outlined,
                color: Colors.purple,
                text: 'Polish'.tr,
                onPressed: onPressedPolish),
            _buttons(
                icon: Icons.delete_forever_rounded,
                text: 'Delete'.tr,
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

  Widget _buttons(
      {required IconData icon,
      Color? color,
      required String text,
      required Function onPressed}) {
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
                    gradient: color == null
                        ? null
                        : LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.topRight,
                            colors: [
                                Colors.purple.shade400,
                                Colors.blue.shade600
                              ]),
                    color: color == null ? Colors.grey.shade200 : null,
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  icon,
                  size: 30,
                  color: color == null ? Colors.grey.shade600 : Colors.white,
                ),
              ),
              SizedBox(height: 14),
              Text(text, style: TextStyle(fontSize: 16)),
            ])));
  }
}
