import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SinglePostDot extends StatelessWidget {
  final Function onPressedVisibility;
  final Function onPressedDelete;

  SinglePostDot(
      {Key? key,
      required this.onPressedVisibility,
      required this.onPressedDelete})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final _height = MediaQuery.of(context).size.height;
    // final _width = MediaQuery.of(context).size.width;
    return Wrap(alignment: WrapAlignment.center, children: [
      Container(
        padding: EdgeInsets.only(bottom: 35),
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
                onPressed: onPressedVisibility),
            _buttons(
                icon: Icons.delete_forever_rounded,
                text: 'Delete',
                onPressed: onPressedDelete)
          ]),
          Container(
            height: 10,
            color: Colors.black12,
          ),
          SizedBox(height: 20),
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Text('Cancle', style: TextStyle(fontSize: 16))),
        ]),
      ),
    ]);
  }

  Widget _buttons(
      {required IconData icon,
      required String text,
      required Function onPressed}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
        child: GestureDetector(
            onTap: () {
              onPressed();
            },
            child: Column(children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 14),
              Text(text, style: TextStyle(fontSize: 16)),
            ])));
  }
}
