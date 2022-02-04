import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

class MoreDots extends StatelessWidget {
  final void Function() onPressedReport;
  final void Function()? onPressedBlock;

  final BuildContext context;
  final String? bottomText;
  final IconData? bottomIcon;

  MoreDots(
      {Key? key,
      required this.onPressedReport,
      this.onPressedBlock,
      required this.context,
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
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                width: _width,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                )),
                child: GestureDetector(
                  onTap: () {
                    onPressedReport();
                  },
                  child: Text('Report'.tr,
                      style: TextStyle(fontSize: 17, color: Colors.red)),
                )),
            GestureDetector(
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
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  color: Colors.transparent,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          bottomText ?? 'Share'.tr,
                          style: TextStyle(fontSize: 17),
                        ),
                        Icon(
                          bottomIcon ?? Icons.send_rounded,
                          color:
                              bottomText == null ? Colors.blue : Colors.black,
                          size: 30,
                        ),
                      ])),
            )
          ])),
    ]);
  }
}
