import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class AnswerController extends GetxController {
  static AnswerController get to => Get.find();

  final count = 0.obs;
  final answer = ''.obs;
  final _isComposing = false.obs;
  final _isSubmitting = false.obs;
  bool get isComposing => _isComposing.value;
  bool get isSubmitting => _isSubmitting.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void increment() => count.value++;
  postAnswer(String answer, String id, {required int backgroundColor}) async {
    await APIProvider.to.post("/post/posts", body: {
      "content": answer,
      "post_template_id": id,
      "background_color": backgroundColor
    });
  }

  void setAnswer(String input) {
    answer.value = input;
  }

  void setIsComposing(bool value) {
    _isComposing.value = value;
  }

  void setIsSubmitting(bool value) {
    _isSubmitting.value = value;
  }
}
