import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_markdown/flutter_markdown.dart';

// 外层不能套Container
// 只能放在Column的直接子元素中
Widget MaxText(String text, BuildContext context,
    {TextStyle? style, TextAlign? textAlign}) {
  return Flexible(
    child: LayoutBuilder(builder: (context, constraints) {
      //use a text painter to calculate the height taking into account text scale factor.
      //could be moved to a extension method or similar
      final Size size = (TextPainter(
              text: TextSpan(text: text.toString(), style: style),
              maxLines: 1,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textDirection: TextDirection.ltr)
            ..layout())
          .size;

      //lets not return 0 max lines or less
      final maxLines = max(1, (constraints.maxHeight / size.height).floor());

      return MarkdownBody(
        data: text,
        styleSheet: MarkdownStyleSheet(
            textAlign: WrapAlignment.start,
            p: style,
            a: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.white,
              height: 1.6,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            )),
        // style: style,
        // textAlign: textAlign,
        // overflow: TextOverflow.ellipsis,
        // maxLines: maxLines,
      );
    }),
  );
}
