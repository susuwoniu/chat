import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../../home/views/vip_sheet.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:chat/app/common/get_time_stop.dart';

class CreatePost extends StatelessWidget {
  final String? id;
  final int? backgroundColorIndex;

  CreatePost({
    Key? key,
    this.id,
    this.backgroundColorIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double paddingLeft = 13;
    final double paddingTop = 12;
    final _createText = Text("Create_Post".tr,
        style: TextStyle(
            color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500));

    final _lockText = Wrap(alignment: WrapAlignment.center, children: [
      Text('Unlocks_at: '.tr,
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
      SizedBox(height: 6),
      Countdown(
        seconds: getTimeStop() ?? 0,
        build: (BuildContext context, double time) {
          return Text(getCountDown(time),
              style: TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.w500));
        },
        interval: Duration(milliseconds: 1000),
        onFinished: () {
          AuthProvider.to.account.update((value) {
            if (value != null) {
              value.is_can_post = true;
            }
          });
        },
      ),
    ]);
    return Obx(() {
      final isCreate = getTimeStop() > 0 ? false : true;

      return GestureDetector(
          onTap: () {
            if (isCreate) {
              Get.toNamed(Routes.POST);
            } else {
              if (!AuthProvider.to.account.value.vip) {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return VipSheet(context: context, index: 4);
                    });
              }
            }
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(
                paddingLeft, paddingTop, paddingLeft, paddingTop),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Color(0xffe4e6ec),
                borderRadius: BorderRadius.circular(5)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                isCreate
                    ? Icons.add_circle_outline_rounded
                    : Icons.timer_outlined,
                size: 44,
                color: Colors.black54,
              ),
              SizedBox(height: 10),
              isCreate ? _createText : _lockText,
            ]),
          ));
    });
  }

  getCountDown(double time) {
    int h, m, s;

    h = time ~/ 3600;

    m = ((time - h * 3600)) ~/ 60;

    s = time.toInt() - (h * 3600) - (m * 60);
    String hourLeft =
        h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();

    String result = "$hourLeft:$minuteLeft:$secondsLeft";

    return result;
  }
}
