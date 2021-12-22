import 'package:chat/constants/colors.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import '../../post/controllers/post_controller.dart';

class CreateController extends GetxController {
  static CreateController get to => Get.find();
  static String formatEditorContent(String content) {
    return content.replaceAll("____", '');
  }

  static int getDefaultTextPosition(String content) {
    return content.indexOf("____");
  }

  String answer = '';
  late int backgroundColorIndex;
  late Color backgroundColor;
  String postTemplateId = "";
  String postTemplateFormattedText = "";
  late int defaultTextPosition;
  final _isComposing = false.obs;
  final _isSubmitting = false.obs;
  bool get isComposing => _isComposing.value;
  bool get isSubmitting => _isSubmitting.value;

  @override
  void onInit() {
    backgroundColorIndex = Get.arguments["background-color-index"] ?? 0;
    backgroundColor = BACKGROUND_COLORS[backgroundColorIndex];
    postTemplateId = Get.arguments["id"] ?? "";
    final postTemplate = PostController.to.postTemplatesMap[postTemplateId]!;
    postTemplateFormattedText = formatEditorContent(postTemplate.content);
    defaultTextPosition = getDefaultTextPosition(postTemplate.content);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  handleChange(
      TextStyle style, TextAlign align, Color theBackgroundColor, String text) {
    answer = text;
    backgroundColor = theBackgroundColor;
    _isComposing.value = answer.isNotEmpty;
  }

  postAnswer() async {
    await APIProvider.to.post("/post/posts", body: {
      "content": answer,
      "post_template_id": postTemplateId,
      "background_color": backgroundColor.value,
    });
  }

  void setAnswer(String input) {
    answer = input;
  }

  void setIsComposing(bool value) {
    _isComposing.value = value;
  }

  void setIsSubmitting(bool value) {
    _isSubmitting.value = value;
  }
}
