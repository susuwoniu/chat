import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import '../../post/controllers/post_controller.dart';
import '../controllers/answer_controller.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/rendering.dart';
import 'package:chat/app/routes/app_pages.dart';

class AnswerView extends GetView<PostController> {
  final id = Get.arguments['id'];
  final _answerController = AnswerController.to;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _marginWidth = _width * 0.05;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('AnswerView'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          final _isComposing = _answerController.isComposing.value;
          final _inputIsNotEmpty = _answerController.content.trim().isNotEmpty;
          final _backgroundColor =
              controller.postTemplatesMap[id]!.backgroundColor;

          return Center(
              child: Container(
            width: _width,
            color: HexColor(_backgroundColor),
            child: Stack(children: <Widget>[
              Column(children: [
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: _marginWidth),
                  child: Text(
                    controller.postTemplatesMap[id]!.content,
                    style: TextStyle(fontSize: 26.0, color: Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  width: _width * 0.88,
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 4,
                    style: TextStyle(fontSize: 26.0, color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    onChanged: (String text) {
                      _answerController.setContent(text.trim());
                      _answerController.setIsComposing(text.trim().isNotEmpty);
                    },
                    // MOD
                  ),
                ),
              ]),
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom + _marginWidth,
                right: _marginWidth,
                child: Container(
                    padding: EdgeInsets.only(right: 1),
                    height: 40,
                    alignment: Alignment.topRight,
                    width: 60,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: _inputIsNotEmpty ? Colors.white : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: _inputIsNotEmpty
                          ? Colors.blue
                          : HexColor(_backgroundColor),
                    ),
                    child: IconButton(
                        color: _inputIsNotEmpty ? Colors.white : Colors.grey,
                        iconSize: 26,
                        icon: const Icon(Icons.send),
                        padding: const EdgeInsets.all(0),
                        onPressed: () => {
                              _isComposing
                                  ? () => _handleSubmitted(
                                      _answerController.content.value, id)
                                  : null,
                            })),
              )
            ]),
          ));
        },
      ),
    );
  }

  void setIsComposing(bool value) =>
      _answerController.isComposing.value = value;

  void _handleSubmitted(String content, String id) {
    _answerController.postInputContent(content, id);
    UIUtils.toast("send_successfully".tr);
    Get.offAllNamed(Routes.MAIN);
  }

  isNotEmpty(text) {
    if (text == '') {
      return false;
    } else {
      return true;
    }
  }
}
