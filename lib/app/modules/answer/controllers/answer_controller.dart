import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class AnswerController extends GetxController {
  static AnswerController get to => Get.find();

  final count = 0.obs;
  final answer = ''.obs;
  final isComposing = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
  postAnswer(String answer, String id) async {
    await APIProvider()
        .post("/post/posts", body: {"content": answer, "post_template_id": id});
    setIsComposing(false);
  }

  void setAnswer(String input) {
    answer.value = input;
  }

  void setIsComposing(bool value) => isComposing.value = value;
}
