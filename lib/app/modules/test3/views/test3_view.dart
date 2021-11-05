import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';

import '../controllers/test3_controller.dart';
import 'package:chat/app/widges/max_text.dart';

class Test3View extends GetView<Test3Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Test3View'),
        //   centerTitle: true,
        // ),
        body: SafeArea(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 100),
            child: Obx(() => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(child: MaxText("test" * 1000, context)),
                      Row(children: [
                        TextButton(
                          onPressed: () async {},
                          child: CircleAvatar(radius: 28),
                        ),
                        Padding(padding: const EdgeInsets.only(right: 8.0)),
                        Text(
                          controller.count.value.toString(),
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white),
                        ),
                      ]),
                    ],
                  ),
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.blue,
              child: Center(
                child: Text('Test3View'),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget textBody(String text, BuildContext context) {
    return Flexible(
      child: LayoutBuilder(builder: (context, constraints) {
        final TextStyle style = Theme.of(context).textTheme.headline4!;

        //use a text painter to calculate the height taking into account text scale factor.
        //could be moved to a extension method or similar
        final Size size = (TextPainter(
                text: TextSpan(text: text, style: style),
                maxLines: 1,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textDirection: TextDirection.ltr)
              ..layout())
            .size;

        //lets not return 0 max lines or less
        final maxLines =
            max(1, (constraints.biggest.height / size.height).floor());

        return Text(
          text,
          style: style,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        );
      }),
    );
  }
}
