import 'package:get/get.dart';
import 'package:chat/types/types.dart';
import 'package:chat/app/providers/api_provider.dart';

class FeedbackController extends GetxController {
  //TODO: Implement FeedbackController

  final count = 0.obs;
  final reportType = ''.obs;
  final imgList = RxList([]);
  final isShowBlank = true.obs;
  ImageEntity? imgEntity;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void setReportType(String type) {
    reportType.value = type;
  }

  void setImgEntity(ImageEntity img) {
    imgEntity = img;
  }

  void increment() => count.value++;

  onPressFeedback({required String content}) async {
    final body = {};

    if (imgEntity != null) {
      body['images'] = [imgEntity!.toJson()];
    }
    body['content'] = content;

    await APIProvider.to.post('/report/reports', body: body);
  }
}
