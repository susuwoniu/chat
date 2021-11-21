import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import '../../post/controllers/post_controller.dart';
import '../controllers/answer_controller.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/rendering.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../../post/views/templates.dart';

class AnswerView extends GetView<PostController> {
  final _answerController = AnswerController.to;
  final _id = Get.arguments['id'];

  final _item = PostController.to.postTemplatesMap[Get.arguments['id']]!;

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
          final question = _item.content;
          final _inputIsNotEmpty = question.isNotEmpty;
          final _backgroundColor =
              controller.postTemplatesMap[_id]!.backgroundColor;

          return Center(
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    width: _width,
                    color: HexColor(_backgroundColor),
                    child: Stack(children: <Widget>[
                      Templates(
                          question: _item.content,
                          id: _id,
                          autofocus: true,
                          onChanged: (text) {
                            _answerController
                                .setIsComposing(text.trim().isNotEmpty);
                            _answerController.setAnswer(text.trim());
                          }),
                      Positioned(
                        bottom: MediaQuery.of(context).viewInsets.bottom +
                            _marginWidth,
                        right: _marginWidth,
                        child: Container(
                            padding: EdgeInsets.only(right: 1),
                            height: 40,
                            width: 60,
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: _inputIsNotEmpty
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: _inputIsNotEmpty
                                  ? Colors.blue
                                  : HexColor(_backgroundColor),
                            ),
                            child: IconButton(
                                color: _inputIsNotEmpty
                                    ? Colors.white
                                    : Colors.grey,
                                iconSize: 26,
                                icon: const Icon(Icons.send),
                                padding: const EdgeInsets.all(0),
                                onPressed: () => {
                                      _isComposing
                                          ? () => _handleSubmitted(
                                              _answerController.answer.value,
                                              _id)
                                          : null,
                                    })),
                      )
                    ]),
                  )));
        },
      ),
    );
  }

  void _handleSubmitted(String answer, String id) {
    _answerController.postAnswer(answer, id);
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
