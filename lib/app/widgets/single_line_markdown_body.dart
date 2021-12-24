import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SingleLineMarkdownBody extends MarkdownWidget {
  final TextOverflow? overflow;
  final int? maxLines;

  const SingleLineMarkdownBody(
      {Key? key,
      required String data,
      MarkdownStyleSheet? styleSheet,
      SyntaxHighlighter? syntaxHighlighter,
      MarkdownTapLinkCallback? onTapLink,
      String? imageDirectory,
      bool? selectable,
      this.overflow,
      this.maxLines})
      : super(
          key: key,
          selectable: selectable ?? false,
          data: data,
          styleSheet: styleSheet,
          syntaxHighlighter: syntaxHighlighter,
          onTapLink: onTapLink,
          imageDirectory: imageDirectory,
        );

  @override
  Widget build(BuildContext context, List<Widget>? children) {
    if (children != null) {
      final richText = _findWidgetOfType<RichText>(children.first);
      if (richText != null) {
        return RichText(
            text: richText.text,
            textAlign: richText.textAlign,
            textDirection: richText.textDirection,
            softWrap: richText.softWrap,
            overflow: overflow ?? TextOverflow.clip,
            textScaleFactor: richText.textScaleFactor,
            maxLines: maxLines,
            locale: richText.locale);
      } else {
        final selectableText =
            _findWidgetOfType<SelectableText>(children.first);
        if (selectableText != null) {
          return SelectableText.rich(selectableText.textSpan!,
              textScaleFactor: selectableText.textScaleFactor,
              textAlign: selectableText.textAlign ?? TextAlign.start,
              textDirection: selectableText.textDirection,
              // style: TextStyle(overflow: overflow),
              onTap: selectableText.onTap,
              style: selectableText.style?.copyWith(
                overflow: overflow ?? TextOverflow.clip,
              ),
              key: selectableText.key,
              maxLines: 10);
        }
      }

      return children.first;
    } else {
      return SizedBox.shrink();
    }
  }

  T? _findWidgetOfType<T>(Widget? widget) {
    if (widget is T) {
      return widget as T;
    }

    if (widget is MultiChildRenderObjectWidget) {
      MultiChildRenderObjectWidget multiChild = widget;
      for (var child in multiChild.children) {
        return _findWidgetOfType<T>(child);
      }
    } else if (widget is SingleChildRenderObjectWidget) {
      SingleChildRenderObjectWidget singleChild = widget;
      return _findWidgetOfType<T>(singleChild.child);
    }

    return null;
  }
}
