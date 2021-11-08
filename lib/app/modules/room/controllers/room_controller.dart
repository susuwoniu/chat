import 'package:get/get.dart';
import 'package:chat/types/types.dart';

class RoomController extends GetxController {
  static RoomController get to => Get.find();

  //TODO: Implement RoomController

  final isComposing = false.obs;
  final indexes = RxList<String>(["1", "2", "3"]);
  final entities = <String, MessageEntity>{
    "1": MessageEntity(
        id: "1", text: "中文测试111中文测试" * 50, name: "#dfd333", isMe: false),
    "2": MessageEntity(
        id: "2", text: "中文测试222中文测试", name: "#dfd333", isMe: false),
    "3": MessageEntity(
        id: "3", text: "中文测试333中文测试", name: "#dfd333", isMe: false),
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
  void postMessage(String text, String name, bool isMe) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    entities[id] = MessageEntity(id: id, text: text, name: name, isMe: isMe);
    indexes.add(id);
    setIsComposing(false);
  }

  void setIsComposing(bool value) => isComposing.value = value;
}
