import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputWidget extends StatefulWidget {
  final int maxLines;
  final int maxLength;
  final String initialContent;
  final bool isShowClear;

  const InputWidget(
      {Key? key,
      required this.maxLines,
      required this.maxLength,
      required this.initialContent,
      required this.isShowClear});

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  void initState() {
    super.initState();
    //初始化状态
    print("initState");
  }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: widget.initialContent);

    return TextFormField(
      controller: textController,
      maxLines: widget.maxLines,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      autofocus: true,
      style: TextStyle(
        fontSize: 17,
        height: 1.5,
      ),
      decoration: InputDecoration(
        suffixIcon: widget.isShowClear
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
