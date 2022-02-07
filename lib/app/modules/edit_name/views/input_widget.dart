import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final int maxLines;
  final int maxLength;
  final String initialContent;
  final Function(String value) onChange;
  final int minLines;
  final bool underline;
  final Color? fillColor;
  final String hintText;
  const InputWidget(
      {Key? key,
      required this.maxLines,
      this.minLines = 1,
      required this.maxLength,
      required this.initialContent,
      required this.onChange,
      this.fillColor,
      this.hintText = "",
      this.underline = false});

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final textController = TextEditingController(text: '');
  bool isShowClear = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //初始化状态
    textController.text = widget.initialContent;
    textController.addListener(() {
      final text = textController.text;
      if (isShowClear) {
        if (text.isEmpty) {
          isShowClear = true;
        }
      } else {
        if (text.isNotEmpty) {
          isShowClear = true;
        }
      }
      widget.onChange(text);
    });
  }

  @override
  void dispose() {
    _focusNode.unfocus();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      maxLines: widget.maxLines,
      keyboardType: TextInputType.multiline,
      minLines: widget.minLines,
      focusNode: _focusNode,
      autofocus: true,
      style: TextStyle(
        fontSize: 17,
        height: 1.5,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: isShowClear
            ? IconButton(
                onPressed: () => {textController.clear()},
                icon: Icon(Icons.clear),
                splashColor: Colors.transparent,
              )
            : null,
        filled: widget.underline ? false : true,
        fillColor: widget.fillColor ?? Theme.of(context).colorScheme.surface,
        border: widget.underline ? UnderlineInputBorder() : InputBorder.none,
        contentPadding: EdgeInsets.all(17),
      ),
      maxLength: widget.maxLength,
    );
  }
}
