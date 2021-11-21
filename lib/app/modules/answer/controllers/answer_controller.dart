import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/types/types.dart';

class AnswerController extends GetxController {
  static AnswerController get to => Get.find();

  final count = 0.obs;
  final content = ''.obs;
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
  postInputContent(String content, String id) async {
    await APIProvider().post("/post/posts",
        body: {"content": content, "post_template_id": id});
    setIsComposing(false);
  }

  void setContent(String input) {
    content.value = input;
  }

  void setIsComposing(bool value) => isComposing.value = value;
}
