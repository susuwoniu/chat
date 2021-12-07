import 'package:flutter/material.dart';
import '../controllers/edit_name_controller.dart';
import 'package:get/get.dart';

class InputWidget extends StatefulWidget {
  final int maxLines;
  final int maxLength;

  const InputWidget(
      {Key? key, required this.maxLines, required this.maxLength});

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final _controller = EditNameController.to;

  @override
  void initState() {
    super.initState();
    //初始化状态
    print("initState");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
          controller: _controller.textController,
          maxLines: widget.maxLines,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          autofocus: true,
          style: TextStyle(
            fontSize: 17,
            height: 1.5,
          ),
          decoration: InputDecoration(
            suffixIcon: _controller.isShowClear.value
                ? IconButton(
                    onPressed: () => {_controller.textController.clear()},
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
        ));
  }
}
