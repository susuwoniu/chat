import 'package:get/get.dart';

class Entity {
  int count;
  Entity({required this.count});
}

class Test1Controller extends GetxController {
  final count = 0.obs;
  final indexes = RxList<String>(["1", "2"]);
  final entities = RxMap<String, Entity>({
    "1": Entity(count: 0),
    "2": Entity(count: 10),
  });

  void increment() {
    entities.update("1", (value) {
      value.count = value.count + 1;
      return value;
    });
  }

  void sort() {
    indexes.shuffle();
  }
}
