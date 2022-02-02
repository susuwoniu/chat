import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import './single_line_markdown_body.dart';

// 外层不能套Container
// 只能放在Column的直接子元素中
Widget MaxText(String text, BuildContext context,
    {TextStyle? style, TextAlign? textAlign}) {
  return Flexible(
    child: LayoutBuilder(builder: (context, constraints) {
      final double minFontsize = 22;
      final maxLines = (constraints.maxHeight / minFontsize / 1.5).floor();
      return AutoSizeText(
        text,
        style: style,
        maxLines: maxLines,
        minFontSize: minFontsize,
        overflow: TextOverflow.ellipsis,
      );
    }),
  );
}
