import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final int maxLines;
  final int maxLength;
  final String initialContent;
  final Function(String value) onChange;
  final int minLines;
  const InputWidget(
      {Key? key,
      required this.maxLines,
      this.minLines = 1,
      required this.maxLength,
      required this.initialContent,
      required this.onChange});

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final textController = TextEditingController(text: '');
  bool isShowClear = false;
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
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      maxLines: widget.maxLines,
      keyboardType: TextInputType.multiline,
      minLines: widget.minLines,
      autofocus: true,
      style: TextStyle(
        fontSize: 17,
        height: 1.5,
      ),
      decoration: InputDecoration(
        suffixIcon: isShowClear
            ? IconButton(
                onPressed: () => {textController.clear()},
                icon: Icon(Icons.clear),
                splashColor: Colors.transparent,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(17),
      ),
      maxLength: widget.maxLength,
    );
  }
}
