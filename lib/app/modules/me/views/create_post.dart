import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../../home/views/vip_sheet.dart';

class CreatePost extends StatelessWidget {
  final bool isCreate;
  final String nextCreateTime;
  final String? id;
  final int? backgroundColorIndex;

  CreatePost({
    Key? key,
    required this.isCreate,
    required this.nextCreateTime,
    this.id,
    this.backgroundColorIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double paddingLeft = 13;
    final double paddingTop = 12;
    final _createText = Text("Create_Post".tr,
        style: TextStyle(
            color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold));

    final _lockText = Wrap(alignment: WrapAlignment.center, children: [
      Text('Unlocks_at: ',
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
      SizedBox(height: 3),
      Text(nextCreateTime,
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
    ]);
    return GestureDetector(
        onTap: () {
          if (isCreate) {
            Get.toNamed(Routes.POST);
          } else {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                enableDrag: false,
                builder: (context) {
                  return VipSheet(context: context, index: 4);
                });
          }
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(
              paddingLeft, paddingTop, paddingLeft, paddingTop),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: Color(0xffe4e6ec), borderRadius: BorderRadius.circular(5)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              isCreate
                  ? Icons.add_circle_outline_rounded
                  : Icons.timer_outlined,
              size: 52,
              color: Colors.black54,
            ),
            SizedBox(height: 10),
            isCreate ? _createText : _lockText,
          ]),
        ));
  }
}
