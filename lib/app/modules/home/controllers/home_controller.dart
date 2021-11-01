import 'package:get/get.dart';
import 'package:chat/types/types.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';

class HomeController extends GetxController {
  final currentIndex = RxInt(-1);
  final postIndexes = RxList<String>(["1", "2", "3", "4"]);
  final postMap = RxMap<String, PostEntity>({
    "1": PostEntity(
      id: "1",
      content: "djsjljflsdjfl",
      backgroundColor: "#dfd333",
    ),
    "2": PostEntity(
      id: "2",
      content: "你好世界2",
      backgroundColor: "#264653",
    ),
    "3": PostEntity(
      id: "3",
      content: "djsjljflsdjfl",
      backgroundColor: "#e76f51",
    ),
    "4": PostEntity(
      id: "4",
      content: "你好世界4",
      backgroundColor: "#ddbea9",
    )
  });

  @override
  void onReady() {
    super.onReady();
    // todo
  }

  @override
  void onClose() {}
  void setIndex(int index) {
    currentIndex.value = index;

    // changet backgroundColor

    final backgroundColor = currentIndex.value == -1
        ? "#FFFFFF"
        : postMap[postIndexes[currentIndex.value]]!.backgroundColor;
    print("backgroundColor $backgroundColor");
    BottomNavigationBarController.to.changeBackgroundColor(backgroundColor);
  }
}
