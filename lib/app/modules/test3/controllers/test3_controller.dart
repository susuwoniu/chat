import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class Test3Controller extends GetxController {
  //TODO: Implement Test3Controller

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    final arguments = NextPage(
        route: '/post',
        mode: NextMode.Off,
        arguments: {"test": "333", "xxx": "444"}).toArguments();
    print("arguments: $arguments");
    super.onReady();
  }

  void increment() => count.value++;
}
