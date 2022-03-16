import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

class OtherDots extends StatelessWidget {
  final void Function() onPressedReport;
  final void Function()? onPressedBlock;
  final String? bottomText;
  final IconData? bottomIcon;

  OtherDots(
      {Key? key,
      required this.onPressedReport,
      this.onPressedBlock,
      this.bottomText,
      this.bottomIcon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Wrap(alignment: WrapAlignment.center, children: [
      Container(
          margin: EdgeInsets.only(bottom: _height * 0.18),
          width: _width * 0.96,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            ListTile(
              onTap: () {
                onPressedReport();
              },
              title: Text('Report'.tr,
                  style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.onBackground)),
            ),
            Divider(height: 1),
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                if (bottomText != null) {
                  onPressedBlock!();
                } else {
                  final FlutterShareMe flutterShareMe = FlutterShareMe();
                  // TODO right share url
                  final response =
                      await flutterShareMe.shareToSystem(msg: "test");
                  print(response);
                }
              },
              title: Text(
                bottomText ?? 'share'.tr,
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              trailing: Icon(
                bottomIcon ?? Icons.send_rounded,
                color: bottomText == null
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onBackground,
                size: 30,
              ),
            ),
          ])),
    ]);
  }
}
