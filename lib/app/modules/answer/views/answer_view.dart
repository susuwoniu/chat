import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../post/controllers/post_controller.dart';
import '../controllers/answer_controller.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import '../../post/views/templates.dart';
import 'package:chat/common.dart';

class AnswerView extends GetView<AnswerController> {
  final _answerController = AnswerController.to;
  final _id = Get.arguments['id'];
  final backgroundColor = Color(Get.arguments['background-color']);
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
          final _isComposing = _answerController.isComposing;
          final _isSubmitting = _answerController.isSubmitting;
          print("_isComposing $_isComposing");
          print("_isSubmitting $_isSubmitting");

          final isCanSend = _isComposing && !_isSubmitting;
          final question = _item.content;

          return Center(
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    width: _width,
                    color: backgroundColor,
                    child: Stack(children: <Widget>[
                      Templates(
                        question: _item.content ?? _item.title,
                        id: _id,
                        autofocus: true,
                        onChanged: (String text) {
                          _answerController
                              .setIsComposing(text.trim().isNotEmpty);
                          _answerController.setAnswer(text.trim());
                        },
                      ),
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
                                color: isCanSend ? Colors.white : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: isCanSend ? Colors.blue : backgroundColor,
                            ),
                            child: IconButton(
                                color: isCanSend ? Colors.white : Colors.grey,
                                iconSize: 26,
                                icon: const Icon(Icons.send),
                                padding: const EdgeInsets.all(0),
                                onPressed: () => {
                                      _handleSubmitted(
                                          _answerController.answer.value, _id)
                                    })),
                      )
                    ]),
                  )));
        },
      ),
    );
  }

  Future<void> _handleSubmitted(String answer, String id) async {
    if (!_answerController.isComposing || _answerController.isSubmitting) {
      return;
    }
    _answerController.setIsSubmitting(true);

    try {
      UIUtils.showLoading();

      await _answerController.postAnswer(answer, id,
          backgroundColor: backgroundColor.value);
      _answerController.setIsSubmitting(false);

      UIUtils.toast("send_successfully".tr);
      RouterProvider.to.toHome();
    } catch (e) {
      UIUtils.showError(e);
      _answerController.setIsSubmitting(false);
    }
    UIUtils.hideLoading();
  }

  isNotEmpty(text) {
    if (text == '') {
      return false;
    } else {
      return true;
    }
  }
}
