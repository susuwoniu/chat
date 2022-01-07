import 'package:chat/constants/colors.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import '../../post/controllers/post_controller.dart';
import 'package:location/location.dart';
import '../../home/controllers/home_controller.dart';
import 'package:chat/types/types.dart';

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
  final _visibility = 'public'.obs;
  String get visibility => _visibility.value;

  @override
  void onInit() {
    backgroundColorIndex = Get.arguments["background-color-index"] ?? 0;
    backgroundColor = BACKGROUND_COLORS[backgroundColorIndex];
    postTemplateId = Get.arguments["id"] ?? "";
    final postTemplate = PostController.to.postTemplatesMap[postTemplateId]!;
    postTemplateFormattedText = formatEditorContent(postTemplate.content ?? '');
    defaultTextPosition = getDefaultTextPosition(postTemplate.content ?? '');
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

  postAnswer({LocationData? location}) async {
    final dynamic body = {
      "content": answer,
      "post_template_id": postTemplateId,
      "background_color": backgroundColor.value,
      "visibility": visibility
    };
    if (location != null) {
      body["latitude"] = location.latitude;
      body["longitude"] = location.longitude;
    }
    final result = await APIProvider.to.post("/post/posts", body: body);
    HomeController.to.myPostsIndexes.insert(0, result['data']['id']);
    HomeController.to.postMap[result['data']['id']] =
        PostEntity.fromJson(result['data']["attributes"]);
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

  void setIsVisibility(String visibility) {
    _visibility.value = visibility;
  }
}
