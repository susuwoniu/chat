import 'package:get/get.dart';
import 'package:chat/types/types.dart';

class RoomController extends GetxController {
  static RoomController get to => Get.find();

  //TODO: Implement RoomController

  final isComposing = false.obs;
  final indexes = RxList<String>(["1"]);
  final entities = <String, MessageEntity>{
    "1": MessageEntity(
      id: "1",
      text: "中文测试中文测试",
      name: "#dfd333",
    ),
    "2": MessageEntity(
      id: "2",
      text: "中文测试中文测试",
      name: "#dfd333",
    ),
    "3": MessageEntity(
      id: "3",
      text: "中文测试中文测试",
      name: "#dfd333",
    ),
  };

  final count = 0.obs;
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
  void postMessage(String text, String name) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    entities[id] = MessageEntity(id: id, text: text, name: name);
    indexes.add(id);
  }

  void setIsComposing(bool value) => isComposing.value = value;
}
