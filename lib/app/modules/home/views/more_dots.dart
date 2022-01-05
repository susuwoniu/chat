import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

class MoreDots extends StatelessWidget {
  final void Function() onPressedReport;
  final void Function() onPressedShare;
  final BuildContext context;

  MoreDots({
    Key? key,
    required this.onPressedReport,
    required this.onPressedShare,
    required this.context,
  }) : super(key: key);
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                width: _width,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                  ),
                )),
                child: GestureDetector(
                  onTap: () {
                    onPressedReport();
                  },
                  child: Text('Report',
                      style: TextStyle(fontSize: 20, color: Colors.red)),
                )),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                final FlutterShareMe flutterShareMe = FlutterShareMe();
                // TODO right share url
                final response =
                    await flutterShareMe.shareToSystem(msg: "test");
                print(response);
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  color: Colors.transparent,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Share',
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.send_rounded,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ])),
            )
          ])),
    ]);
  }
}
